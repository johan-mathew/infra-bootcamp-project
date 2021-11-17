resource "aws_iam_user" "ecr_user" {
  name = "${var.TAG_PREFIX}_ecr_user"

  tags = {
    name = "${var.TAG_PREFIX}_ecr_user"
  }
}

resource "aws_iam_user_policy" "ecr_user_policy" {
  name = "test"
  user = aws_iam_user.ecr_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {  
       "Sid": "VisualEditor0",
       "Action": [
                "ecr:PutImageTagMutability",
                "ecr:StartImageScan",
                "ecr:DescribeImageReplicationStatus",
                "ecr:ListTagsForResource",
                "ecr:UploadLayerPart",
                "ecr:BatchDeleteImage",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:CompleteLayerUpload",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:BatchCheckLayerAvailability",
                "ecr:ReplicateImage",
                "ecr:GetLifecyclePolicy",
                "ecr:PutLifecyclePolicy",
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:CreateRepository",
                "ecr:PutImageScanningConfiguration",
                "ecr:GetDownloadUrlForLayer",
                "ecr:DeleteLifecyclePolicy",
                "ecr:PutImage",
                "ecr:UntagResource",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:InitiateLayerUpload",
                "ecr:GetRepositoryPolicy"
            ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.ecr_repository.arn}"
    },
    {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
            "ecr:GetRegistryPolicy",
            "ecr:DescribeRegistry",
            "ecr:GetAuthorizationToken",
            "ecr:PutReplicationConfiguration"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "ecr_user_access_key" {
  user    = aws_iam_user.ecr_user.name
  pgp_key = "keybase:${var.PGP_USERNAME}"
}

output "access_key_id" {
  value = aws_iam_access_key.ecr_user_access_key.id
}

output "access_key_secret" {
  value = aws_iam_access_key.ecr_user_access_key.encrypted_secret
}