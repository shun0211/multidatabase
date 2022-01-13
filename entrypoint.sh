#!/bin/bash

if [ ! -z "${AWS_SSM_AGENT_CODE}" ] && [ ! -z "${AWS_SSM_AGENT_ID}" ]; then
  amazon-ssm-agent -register -code "${AWS_SSM_AGENT_CODE}" -id "${AWS_SSM_AGENT_ID}" -region "ap-northeast-1"
  amazon-ssm-agent &
fi

env
bundle exec rails db:migrate
echo 'rails db:migrateできている'
bundle exec unicorn -c config/unicorn.rb
echo 'rails db:migrateできているjk'
