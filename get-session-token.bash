#!/bin/bash
# get-session-token <profile> <token_code>

export AWS_PROFILE="$1"
token_code="$2"

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

eval $(aws --profile="${AWS_PROFILE}" configure export-credentials --format=env)

serial_number="$(aws --profile="${AWS_PROFILE}" configure get serial_number)"
if [ $? -ne 0 ]; then
    >&2 echo "${AWS_PROFILE}.serial_number is not defined"
    exit 1
fi

credentials="$(aws --output json \
                   sts get-session-token --serial-number="${serial_number}" --token-code="${token_code}")"
if [ $? -eq 0 ]; then
    aws --profile="${AWS_PROFILE}-sts" configure \
        set aws_access_key_id "$(echo "${credentials}" | jq --raw-output .Credentials.AccessKeyId)"
    aws --profile="${AWS_PROFILE}-sts" configure \
        set aws_secret_access_key "$(echo "${credentials}" | jq --raw-output .Credentials.SecretAccessKey)"
    aws --profile="${AWS_PROFILE}-sts" configure \
        set aws_session_token "$(echo "${credentials}" | jq --raw-output .Credentials.SessionToken)"

    aws --profile="${AWS_PROFILE}-sts" configure set region "$(aws configure get region)"
    aws --profile="${AWS_PROFILE}-sts" configure set output "$(aws configure get output)"
    aws --profile="${AWS_PROFILE}-sts" configure set cli_pager ""
else
    >&2 echo "Cannot generate ${AWS_PROFILE} session token"
fi
