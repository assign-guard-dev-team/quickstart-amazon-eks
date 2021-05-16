#!/bin/bash
set -eou pipefail

stack=$1
template_file=$2
overrides_file=$3

aws cloudformation deploy \
    --no-execute-changeset \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --template-file $template_file \
    --stack-name $stack \
    --parameter-overrides $(cat ${overrides_file} | sed 's/,ParameterValue//' | sed 's/ParameterKey=//' | tr '\n' ' ')

# obtain the most recent change set created (via the previous command)
change_set=$(aws cloudformation \
    list-change-sets \
    --stack-name $stack \
    | jq -r '.Summaries[-1].ChangeSetId' )

# write a description of it to a temporary file for review
aws cloudformation describe-change-set \
    --change-set-name $change_set \
    > /tmp/changeset.json

echo "View staged change set at /tmp/changeset.json"