resource "aws_eks_cluster" "main" {
  name     = "${var.environment}-eks"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }

  tags = {
    Name        = "${var.environment}-eks"
    Environment = var.environment
  }
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.4.0-eksbuild.2"
  resolve_conflicts_on_create = "OVERWRITE"

  tags = {
    Name        = "${var.environment}-pod-identity-agent"
    Environment = var.environment
  }
}
