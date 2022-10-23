resource "aws_security_group" "stg_hayley-sg" {
  vpc_id      = aws_vpc.stg_hayley-vpc.id
  name        = "T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "stg_hayley-sginbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.stg_hayley-sg.id
}

resource "aws_security_group_rule" "stg_hayley-sgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.stg_hayley-sg.id
}