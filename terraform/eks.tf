locals {
    public-subnet-1         = aws_subnet.public[element(keys(aws_subnet.public),0)].id
    public-subnet-2         = aws_subnet.public[element(keys(aws_subnet.public),1)].id
    public-subnet-3         = aws_subnet.public[element(keys(aws_subnet.public),2)].id

    private-subnet-1        = aws_subnet.private[element(keys(aws_subnet.private),0)].id
    private-subnet-2        = aws_subnet.private[element(keys(aws_subnet.private),1)].id
    private-subnet-3        = aws_subnet.private[element(keys(aws_subnet.private),2)].id
}

# following trust policy lets eks service assume this role
resource "aws_iam_role" "eks_cluster" {
    name = "${var.env_prefix}-myapp-eks-role"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    policy_arn              = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role                    = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
    policy_arn              = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role                    = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
    name                    = var.eks_cluster_name
    role_arn                = aws_iam_role.eks_cluster.arn
    version                 = var.eks_cluster_version
  
    vpc_config {
        subnet_ids          = [local.public-subnet-1, local.public-subnet-2, local.public-subnet-3]
    }

    depends_on = [aws_iam_role.eks_cluster]

    tags = {
        Name                = "${var.env_prefix}-${var.eks_cluster_name}"
    }
}

# following trust policy lets ec2 service assume this role
resource "aws_iam_role" "eks_nodes" {
    name = "${var.env_prefix}-myapp-nodegroup-role"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn              = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role                    = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn              = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role                    = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn              = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role                    = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
    cluster_name            = aws_eks_cluster.aws_eks.name
    node_group_name         = "${var.env_prefix}-myapp-nodegroup"
    node_role_arn           = aws_iam_role.eks_nodes.arn
    subnet_ids              = [local.private-subnet-1, local.private-subnet-2, local.private-subnet-3]
    ami_type                = "AL2_x86_64"
    instance_types          = ["t3.small"]

    scaling_config {
        desired_size        = 1
        max_size            = 1
        min_size            = 1
    }

# Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
# Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}