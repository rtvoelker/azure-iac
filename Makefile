help: ## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
		IFS=$$'#' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "%-30s %s\n" $$help_command $$help_info ; \
	done

##### AZURE LOGIN AND AKS CREDENTIALS #####
login: ## login for 'symmedia' tenant
	az login --tenant rolandtvoelkergmail.onmicrosoft.com

get-credentials: ## get your kubectl credentials for created cluster
	az aks get-credentials -n $(shell terraform output k8s_cluster_name) -g $(shell terraform output k8s_resource_group_name) --subscription $(shell terraform output subscription_id)

open-firewall: ## open firewall
	az sql server firewall-rule create -g $(shell terraform output sql_server_rg_name) --server $(shell terraform output sql_server_name) --name $(shell terraform output user) --subscription $(shell terraform output subscription_id) --start-ip-address $(shell curl ipinfo.io/ip) --end-ip-address $(shell curl ipinfo.io/ip)

##### TERRAFORM #####
plan: ## runs the plan for dev env
	terraform plan --var-file=variables/development.tfvars --out dev.tfplan

apply: ## runs the plan for dev env
	terraform apply "dev.tfplan"
	rm dev.tfplan

destroy: ## destroy
	terraform destroy

format: ## format terraform files
	terraform fmt -recursive
terraform-upgrade: ## Upgrade to latest provider versions
	terraform init -upgrade
