ami:
	# make sure old ami and snapshots are removed before run
	cd terraform-ami && terraform init
	cd terraform-ami && terraform plan 
	cd terraform-ami && terraform apply --auto-approve
	cd ansible && ansible-playbook deploy-docker-container.yaml --vault-password-file ~/.vault_secret --extra-vars="image_tag=$(build_number)"
	cd terraform-ami && python3 create_custom_ami.py
	cd terraform-ami && terraform destroy --auto-approve


eks:
	cd terraform && terraform init
	cd terraform && terraform plan 
	cd terraform && terraform apply --auto-approve

destroy_eks:
	cd terraform && terraform destroy --auto-approve