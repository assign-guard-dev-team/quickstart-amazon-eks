#!/bin/bash
set -eou pipefail

for f in $(find templates -type f -name '*.yaml'); do
    echo "Validating $f"
    aws cloudformation validate-template \
        --template-body file://templates/amazon-eks.template.yaml \
        > /dev/null
done