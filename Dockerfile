FROM ruby:3.0.2 as development
SHELL [ "/bin/bash", "-c" ]

ENV LANG C.UTF-8

RUN set -x \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN set -x \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get update -qq \
  && apt-get install -y \
    build-essential \
    nodejs \
    sudo \
    yarn \
  && rm -rf /var/lib/apt/lists/*

# Dockerizeで他のコンテナの起動を待つ
ENV DOCKERIZE_VERSION v0.6.1
RUN set -x \
  && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN set -x && gem install bundler

WORKDIR /usr/src/web

RUN set -x && mkdir log && mkdir -p tmp/pids

COPY package.json .
COPY yarn.lock .
RUN set -x && yarn install --frozen-lockfile

COPY Gemfile .
COPY Gemfile.lock .
RUN set -x && bundle install --jobs=4
COPY . .

RUN set -x \
  && curl https://s3.ap-northeast-1.amazonaws.com/amazon-ssm-ap-northeast-1/latest/debian_amd64/amazon-ssm-agent.deb -o /tmp/amazon-ssm-agent.deb \
  && dpkg -i /tmp/amazon-ssm-agent.deb \
  && cp /etc/amazon/ssm/seelog.xml.template /etc/amazon/ssm/seelog.xml

CMD ["./entrypoint.sh"]
