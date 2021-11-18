resource "aws_eks_node_group" "team_3_eks_node_group" {
  cluster_name    = aws_eks_cluster.team_3_eks_cluster.name
  node_group_name = "${var.TAG_PREFIX}_${terraform.workspace}_eks_node_group"
  node_role_arn   = aws_iam_role.team_3_eks_node_group_iam_role.arn
  subnet_ids      = [aws_subnet.team_3_subnet_public_1.id, aws_subnet.team_3_subnet_public_2.id]
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.team_3_eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.team_3_eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.team_3_eks_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}
resource "aws_iam_role" "team_3_eks_node_group_iam_role" {
  name = "${var.TAG_PREFIX}_${terraform.workspace}_eks_node_group_iam_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "team_3_eks_node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.team_3_eks_node_group_iam_role.name
}

resource "aws_iam_role_policy_attachment" "team_3_eks_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.team_3_eks_node_group_iam_role.name
}

resource "aws_iam_role_policy_attachment" "team_3_eks_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.team_3_eks_node_group_iam_role.name
}