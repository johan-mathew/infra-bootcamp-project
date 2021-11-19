resource "aws_security_group" "team_3_elb_sg" {
  vpc_id      = aws_vpc.team_3_vpc.id
  name        = "${var.TAG_PREFIX}_${terraform.workspace}_elb_sg"
  description = "security group for team3 elb"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["49.37.191.15/32", "103.170.54.87/32", "49.37.33.223/32"]
  }

  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_elb_sg"
  }
}

resource "aws_security_group_rule" "team_3_allow_elb_sg_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 30007
  protocol          = "tcp"
  source_security_group_id = aws_security_group.team_3_elb_sg.id
  security_group_id = aws_eks_cluster.team_3_eks_cluster.vpc_config[0].cluster_security_group_id
}