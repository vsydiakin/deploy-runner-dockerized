#!/bin/sh

GITLAB_RUNNER_TAGLIST=${GITLAB_RUNNER_TAGLIST:-deploy}
GITLAB_URL=${GITLAB_URL:-https://yourdomain.com/}
GITLAB_TOKEN=${GITLAB_TOKEN:-zV3sGC2VSVXfKt84Ltpz}

## Register runner (once)
if [ ! -f /etc/gitlab-runner/runner.configured ]
then
  
  /usr/bin/gitlab-ci-multi-runner register -n \
     --url "${GITLAB_URL}" \
     --registration-token "${GITLAB_TOKEN}" \
     --executor shell \
     --tag-list "${GITLAB_RUNNER_TAGLIST}" \
     --description "${HOSTNAME}" \
  && touch /etc/gitlab-runner/runner.configured

fi

## Start gitlab-runner
/usr/bin/gitlab-ci-multi-runner run --working-directory /home/gitlab-runner --config /etc/gitlab-runner/config.toml --user gitlab-runner
