resource "aws_eks_addon" "ebs-csi-driver" {
    cluster_name      = var.eks_cluster_name
    addon_name        = "aws-ebs-csi-driver"
    addon_version     = "v1.10.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
}