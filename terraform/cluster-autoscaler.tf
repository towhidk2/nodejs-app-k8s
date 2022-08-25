resource "aws_iam_policy" "autoscaler" {
    name        = "${var.eks_cluster_name}-autoscaling-policy"
    description = "EKS AWS autoscaling policy for the cluster ${var.eks_cluster_name}"

# Terraform's "jsonencode" function converts a
# Terraform expression result to valid JSON syntax.
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "autoscaling:DescribeAutoScalingGroups",
                    "autoscaling:DescribeAutoScalingInstances",
                    "autoscaling:DescribeLaunchConfigurations",
                    "autoscaling:DescribeTags",
                    "autoscaling:SetDesiredCapacity",
                    "autoscaling:TerminateInstanceInAutoScalingGroup",
                    "ec2:DescribeLaunchTemplateVersions"
                ],
                "Resource": "*"
            }
        ]
    })

}

# custom policy to be attached with existing nodegroup(eks-node-group-role) IAM role which was created in eks module
resource "aws_iam_role_policy_attachment" "autoscaler" {
    role       = aws_iam_role.eks_nodes.name
    policy_arn = aws_iam_policy.autoscaler.arn
}