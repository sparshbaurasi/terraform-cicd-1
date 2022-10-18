# Makefile to kickoff terraform.
# ####################################################

STATEBUCKET = ${{ github.event.inputs.STATEBUCKET }}
STATEKEY = ${{ github.event.inputs.STATEKEY }}/terraform.tfstate
STATEREGION = ${{ github.event.inputs.STATEREGION }}

################################ Terraform Environment Variables ##################################
export TF_VAR_sinequa_platform_deployed_time=$(shell date +%s)

# # Before we start test that we have the mandatory executables available
	EXECUTABLES = git terraform-14.9
	K := $(foreach exec,$(EXECUTABLES),\
		$(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, consider apt-get install $(exec)")))


.PHONY: plan

first-run:
	@echo "initialize remote state file"
	cd services/$(SERVICE) && \
	terraform-14.9 init -upgrade -backend-config="bucket=$(STATEBUCKET)" -backend-config="key=$(STATEKEY)" -backend-config="dynamodb_table=$(STATELOCKTABLE)" -backend-config="region=$(STATEREGION)"

init:
	@echo "initialize remote state file"
	cd services/$(SERVICE) && \
	terraform-14.9 workspace select $(WORKSPACE) || terraform-14.9 workspace new $(WORKSPACE) && \
	terraform-14.9 init --force-copy -backend-config="bucket=$(STATEBUCKET)" -backend-config="key=$(STATEKEY)" -backend-config="region=$(STATEREGION)"

validate: init
	@echo "running terraform validate"
	cd services/$(SERVICE) && \
	terraform-14.9 validate

plan: validate
	@echo "running terraform plan"
	cd services/$(SERVICE) && \
	terraform-14.9 plan

apply: plan
	@echo "running terraform apply"
	cd services/$(SERVICE) && \
	terraform-14.9 apply -auto-approve

plan-destroy: validate
	@echo "running terraform plan -destroy"
	cd services/$(SERVICE) && \
	terraform-14.9 plan -destroy 

destroy: init
	@echo "running terraform destroy"
	cd services/$(SERVICE) && \
	terraform-14.9 destroy -force
