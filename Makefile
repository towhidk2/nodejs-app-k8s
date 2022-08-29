eks:
	cd terraform && terraform init
	cd terraform && terraform plan 
	cd terraform && terraform apply --auto-approve

destroy_eks:
	cd terraform && terraform destroy --auto-approve

deploy:
    # before deploying application, do some stuff on eks cluster like ingress, external dns, cert-manager, cluster-autoscaler which are one time setup

