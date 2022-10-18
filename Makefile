# Makefile to kickoff terraform.
# ####################################################
SERVICE = $(STATEKEYNAME)
STATEBUCKET = $(STATEBUCKETNAME)
STATEKEY = $(ENVRIONMENTNAME)/$(STATEKEYNAME)/terraform.tfstate
STATEREGION = $(STATEREGIONNAME)
WORKSPACE = $(ENVRIONMENTNAME)

################################ Terraform Environment Variables ##################################
export TF_VAR_sinequa_platform_deployed_time=$(shell date +%s)

# # Before we start test that we have the mandatory executables available
# EXECUTABLES = git terraform
# K := $(foreach exec,$(EXECUTABLES),\
# 	$(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, consider apt-get install $(exec)")))


.PHONY: plan

test:
	@echo $(STATEBUCKET)
	@echo $(STATEKEY)
	@echo $(STATEREGION)
first-run:
	@echo "initialize remote state file"
	cd services/$(SERVICE) && \
	terraform init -upgrade -backend-config="bucket=$(STATEBUCKET)" -backend-config="key=$(STATEKEY)" -backend-config="region=$(STATEREGION)"
init:
	@echo "initialize remote state file"
	cd services/$(SERVICE) && \
	terraform init -upgrade -backend-config="bucket=$(STATEBUCKET)" -backend-config="key=$(STATEKEY)" -backend-config="region=$(STATEREGION)" && \
	terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

########terraform init --force-copy -backend-config="bucket=$(STATEBUCKET)" -backend-config="key=$(STATEKEY)" -backend-config="region=$(STATEREGION)"

validate: init
	@echo "running terraform validate"
	cd services/$(SERVICE) && \
	terraform validate

plan: validate
	@echo "running terraform plan"
	cd services/$(SERVICE) && \
	terraform plan

apply: plan
	@echo "running terraform apply"
	cd services/$(SERVICE) && \
	terraform apply -auto-approve

plan-destroy: validate
	@echo "running terraform plan -destroy"
	cd services/$(SERVICE) && \
	terraform plan -destroy 

destroy: init
	@echo "running terraform destroy"
	cd services/$(SERVICE) && \
	terraform destroy -force