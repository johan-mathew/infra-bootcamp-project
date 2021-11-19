resource "aws_elb" "team_3_elb" {
  name               = "team-3-${terraform.workspace}-elb"
  subnets = [aws_subnet.team_3_subnet_public_1.id, aws_subnet.team_3_subnet_public_2.id]


  listener {
    instance_port     = 30007
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  security_groups = [aws_security_group.team_3_elb_sg.id]

  tags = {
    Name = "${var.TAG_PREFIX}_${terraform.workspace}_elb"
  }
}

resource "aws_autoscaling_attachment" "team_3_eks_asg_attachment" {
  autoscaling_group_name = aws_eks_node_group.team_3_eks_node_group.resources[0].autoscaling_groups[0].name
  elb                    = aws_elb.team_3_elb.id
}
