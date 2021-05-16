#!/bin/bash
set -eou pipefail

stack=$1
template_file=$2
overrides_file=$3

aws cloudformation create-stack \
    --stack-name $stack \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --disable-rollback \
    --template-body file://$template_file \
    --parameters $(cat ${overrides_file})
