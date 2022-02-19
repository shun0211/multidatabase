FROM ruby:3.0.2 as development
# -e:実行されたコマンドが0でないステータスで終了した場合にスクリプトを終了
# -o pipeline:パイプでつないだ各コマンドの中で終了ステータスが0以外(正常終了以外)だった場合、最後に0以外だったコマンドの終了ステータスが返される
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

ENV LANG C.UTF-8

# Yarnをインストールするための準備
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

ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV:-development}

FROM development as production

VOLUME ["/usr/src/web"]

# container_linux.go:380: starting container process caused: exec: "./entrypoint.sh": permission denied
RUN chmod +x entrypoint.sh
CMD ["./entrypoint.sh"]
