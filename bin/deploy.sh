#!/bin/bash
set -eou pipefail

stack=$1
template_file=$2

# obtain the most recent change set created (via stage.sh)
change_set=$(aws cloudformation \
    list-change-sets \
    --stack-name $stack \
    | jq -r '.Summaries[-1].ChangeSetId' )

# execute it
aws cloudformation execute-change-set \
    --stack-name $stack \
    --change-set-name $change_set