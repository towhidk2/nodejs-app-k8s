data "aws_caller_identity" "current" {}

data "tls_certificate" "myapp-eks" {
    url = aws_eks_cluster.myapp-eks.identity.0.oidc.0.issuer
}
resource "aws_iam_openid_connect_provider" "myapp-eks" {
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.myapp-eks.certificates.0.sha1_fingerprint]
    url = aws_eks_cluster.myapp-eks.identity.0.oidc.0.issuer
}

resource "aws_iam_role" "external-dns" {
    name  = "${var.eks_cluster_name}-external-dns"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${trimprefix(aws_eks_cluster.myapp-eks.identity.0.oidc.0.issuer, "https://")}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${trimprefix(aws_eks_cluster.myapp-eks.identity.0.oidc.0.issuer, "https://")}:aud": "sts.amazonaws.com",
                    "${trimprefix(aws_eks_cluster.myapp-eks.identity.0.oidc.0.issuer, "https://")}:sub": "system:serviceaccount:${var.namespace_name}:${var.ksa_name}"
                }
            }
        }]
    })
}


data "aws_iam_policy" "route53full" {
    arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "route53policy" {
    role       = aws_iam_role.external-dns.name
    policy_arn = data.aws_iam_policy.route53full.arn
}

output "thumbprint" {
    value = aws_iam_openid_connect_provider.myapp-eks.thumbprint_list[0]
}

# oidc.eks.ap-south-1.amazonaws.com/id/7392CB4FD098D6ACBC4B648694E33CC4
output "url" {
    value = aws_eks_cluster.myapp-eks.identity.0.oidc.0.issuer
}
