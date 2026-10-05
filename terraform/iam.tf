data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster" {
  name = "${var.environment}-eks-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Name        = "${var.environment}-eks-cluster-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_node" {
  name = "${var.environment}-eks-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

  tags = {
    Name        = "${var.environment}-eks-node-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_worker" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_cni" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_user" "jenkins" {
  name = "${var.environment}-jenkins-ci"

  tags = {
    Name        = "${var.environment}-jenkins-ci"
    Environment = var.environment
    Purpose     = "CI/CD"
  }
}

data "aws_iam_policy_document" "jenkins_ecr" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:DescribeImages"
    ]

    resources = [
      aws_ecr_repository.app.arn
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "eks:DescribeCluster"
    ]

    resources = [
      aws_eks_cluster.main.arn
    ]
  }
}

resource "aws_iam_policy" "jenkins_ecr" {
  name        = "${var.environment}-jenkins-ecr"
  description = "Allow Jenkins CI to push and inspect application images in ECR"

  policy = data.aws_iam_policy_document.jenkins_ecr.json

  tags = {
    Name        = "${var.environment}-jenkins-ecr"
    Environment = var.environment
    Purpose     = "CI/CD"
  }
}

resource "aws_iam_user_policy_attachment" "jenkins_ecr" {
  user       = aws_iam_user.jenkins.name
  policy_arn = aws_iam_policy.jenkins_ecr.arn
}
