resource "aws_iam_role" "team3_eks_iam_role" {
  name = "${var.TAG_PREFIX}_${terraform.workspace}_eks_iam_role"

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

resource "aws_iam_role_policy_attachment" "team_3_eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.team3_eks_iam_role.name
}

resource "aws_iam_role_policy_attachment" "team_3_eks_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.team3_eks_iam_role.name
}

resource "aws_eks_cluster" "team_3_eks_cluster" {
  name     = "${var.TAG_PREFIX}_${terraform.workspace}_eks_cluster"
  role_arn = aws_iam_role.team3_eks_iam_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.team_3_subnet_public_1.id, aws_subnet.team_3_subnet_public_2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.team_3_eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.team_3_eks_AmazonEKSVPCResourceController,
  ]
}

output "eks_endpoint" {
  value = aws_eks_cluster.team_3_eks_cluster.endpoint
}

output "eks_kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.team_3_eks_cluster.certificate_authority[0].data
}