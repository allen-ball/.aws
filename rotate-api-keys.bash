#!/bin/bash
# rotate-api-keys [ profile ... ]
if [ $# -gt 0 ]; then
    profiles="$@"
else
    profiles=$(aws configure list-profiles)
fi

for profile in ${profiles}; do
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    echo -n "${profile}: "

    aws_session_token=$(aws --profile="${profile}" configure get aws_session_token)
    if [ $? -eq 0 ]; then
        >&2 echo "Skipping session token profile ${profile}"
        continue;
    fi

#    aws_session_token=$(aws --profile="${profile}-sts" configure get aws_session_token)
#    if [ $? -eq 0 ]; then
#        eval $(aws --profile="${profile}-sts" configure export-credentials --format=env)
#    fi

    user=$(aws --profile="${profile}" iam get-user)
    if [ $? -ne 0 ]; then
        >&2 echo "Cannot get user for profile ${profile}"
        continue;
    fi

    user_name="$(echo "${user}" | jq --raw-output .User.UserName)"

    aws_access_key_id=$(aws --profile="${profile}" configure get aws_access_key_id)
    if [ $? -ne 0 ]; then
        >&2 echo "Cannot get aws_access_key_id for profile ${profile}"
        continue;
    fi

    access_key=$(aws --profile="${profile}" iam create-access-key --user-name="${user_name}")
    if [ $? -ne 0 ]; then
        >&2 echo "Cannot create access_key for profile ${profile}"
        continue;
    fi

    aws --profile="${profile}" configure \
        set aws_access_key_id "$(echo "${access_key}" | jq --raw-output .AccessKey.AccessKeyId)"
    aws --profile="${profile}" configure \
        set aws_secret_access_key "$(echo "${access_key}" | jq --raw-output .AccessKey.SecretAccessKey)"

    echo "$(echo "${access_key}" | jq --raw-output .AccessKey.AccessKeyId)"

    sleep 10

    aws --profile="${profile}" iam \
        update-access-key --user-name="${user_name}" --access-key-id="${aws_access_key_id}" --status=Inactive \
        && aws --profile="${profile}" iam \
               delete-access-key --user-name="${user_name}" --access-key-id="${aws_access_key_id}"
    if [ $? -ne 0 ]; then
        >&2 echo "Cannot delete ${aws_access_key_id} from profile ${profile}"
    fi
done
