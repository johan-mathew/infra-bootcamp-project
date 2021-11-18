resource "aws_security_group" "team_3_node_sg" {
  vpc_id      = aws_vpc.team_3_vpc.id
  name        = "${var.TAG_PREFIX}_${terraform.workspace}_node_sg"
  description = "security group for team3 ekc nodes"
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
    security_groups = [aws_security_group.team_3_lb_sg.id]
  }

  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_node_sg"
  }
}

resource "aws_security_group" "team_3_lb_sg" {
  vpc_id      = aws_vpc.team_3_vpc.id
  name        = "${var.TAG_PREFIX}_${terraform.workspace}_lb_sg"
  description = "security group for team 3 eks load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["49.37.191.15/32", "103.170.54.87/32", "49.37.33.223/32"]
  }
  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_lb_sg"
  }
}
