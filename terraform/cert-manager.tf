locals {
    k8s_service_account_cert_manager_namespace = "cert-manager"
    k8s_service_account_cert_manager = "cert-manager-route53"
}

# hosted zone was created manually which is called in data source
data "aws_route53_zone" "smart-techthings" {
    name         = "${var.root_domain}."
}

module "iam_iam-assumable-role-with-oidc" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
    version = "5.3.0"
    create_role = true
    role_name = "${var.eks_cluster_name}-cert-manager-role"
    provider_url = replace(aws_eks_cluster.myapp-eks.identity.0.oidc.0.issuer, "https://", "")
    role_policy_arns = [aws_iam_policy.cert_manager.arn]
    oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_cert_manager_namespace}:${local.k8s_service_account_cert_manager}"]
}


resource "aws_iam_policy" "cert_manager" {
    name        = "${var.eks_cluster_name}-cert-manager-policy"
    description = "EKS AWS Cert Manager policy for the cluster ${var.eks_cluster_name}"

# Terraform's "jsonencode" function converts a
# Terraform expression result to valid JSON syntax.
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": "route53:GetChange",
            "Resource": "arn:aws:route53:::change/*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "route53:ChangeResourceRecordSets",
              "route53:ListResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/${data.aws_route53_zone.smart-techthings.zone_id}"
          },
          {
            "Effect": "Allow",
            "Action": "route53:ListHostedZonesByName",
            "Resource": "*"
          }]
    })

}

