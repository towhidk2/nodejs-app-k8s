provider "aws" {
    region = "us-east-1"
}


# data "aws_eks_cluster_auth" "myapp-eks" {
#     name = aws_eks_cluster.myapp-eks.cluster_id
# }

# terraform {
#     required_version = "~> 1.0"

#     required_providers {
#         aws = {
#             source  = "hashicorp/aws"
#             version = "~> 4.0"
#         }

#         helm = {
#             source = "hashicorp/helm"
#             version = "~> 3.8"
#         }

#     }
# }

# provider "helm" {
#     host                   = data.aws_eks_cluster.myapp-eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-eks.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.myapp-eks.token
# }