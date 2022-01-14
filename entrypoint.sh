#!/bin/bash

if [ ! -z "${AWS_SSM_AGENT_CODE}" ] && [ ! -z "${AWS_SSM_AGENT_ID}" ]; then
  amazon-ssm-agent -register -code "${AWS_SSM_AGENT_CODE}" -id "${AWS_SSM_AGENT_ID}" -region "ap-northeast-1"
  amazon-ssm-agent &
fi

bundle exec rails db:migrate
bundle exec rails assets:precompile
bundle exec unicorn -c config/unicorn.rb
