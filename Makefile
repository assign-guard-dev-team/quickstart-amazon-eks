TEMPLATE_FILE ?= templates/amazon-eks-entrypoint-existing-vpc.template.yaml
S3_BUCKET_NAME ?= aws-quickstart-assignguard
STACK_NAME ?= ag-eks
OVERRIDES_FILE ?= parameters.lst
AWS_REGION ?= us-east-1
CLUSTER_NAME ?= $(shell grep ClusterName $(OVERRIDES_FILE) | cut -d, -f2 | cut -d= -f2)

.PHONY: create
create:
	@bin/create-stack.sh $(STACK_NAME) $(TEMPLATE_FILE) $(OVERRIDES_FILE)

.PHONY: stage
stage:
	@aws s3 sync templates s3://$(S3_BUCKET_NAME)/quickstart-amazon-eks
	@bin/stage.sh $(STACK_NAME) $(TEMPLATE_FILE) $(OVERRIDES_FILE)

.PHONY: deploy
deploy:
	@bin/deploy.sh $(STACK_NAME) $(TEMPLATE_FILE)

.PHONY: validate
validate:
	aws cloudformation validate-template --template-body file://$(TEMPLATE_FILE) > /dev/null

.PHONY: kube-config
kube-config:
	@aws eks update-kubeconfig \
		--region $(AWS_REGION) \
		--name $(CLUSTER_NAME)

.PHONY: validate-all
validate-all:
	bin/validate.sh

.PHONY: lint-all
lint-all:
	cfn-lint templates/*.yaml