terraform {
  backend "s3" {
    bucket = "hayley-t101study-tfstate-week3-files"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region  = "ap-northeast-2"
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "hayley-t101study-tfstate-week3-files"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

resource "aws_subnet" "hayleysubnet1" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "t101-subnet1"
  }
}

resource "aws_subnet" "hayleysubnet2" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "t101-subnet2"
  }
}

resource "aws_internet_gateway" "hayleyigw" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "t101-igw"
  }
}

resource "aws_route_table" "hayleyrt" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "t101-rt"
  }
}

resource "aws_route_table_association" "hayleyrtassociation1" {
  subnet_id      = aws_subnet.hayleysubnet1.id
  route_table_id = aws_route_table.hayleyrt.id
}

resource "aws_route_table_association" "hayleyrtassociation2" {
  subnet_id      = aws_subnet.hayleysubnet2.id
  route_table_id = aws_route_table.hayleyrt.id
}

resource "aws_route" "hayleydefaultroute" {
  route_table_id         = aws_route_table.hayleyrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hayleyigw.id
}

resource "aws_security_group" "hayleysg" {
  vpc_id      = data.terraform_remote_state.db.outputs.vpcid
  name        = "T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "hayleysginbound" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.hayleysg.id
}

resource "aws_security_group_rule" "hayleysgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.hayleysg.id
}


data "template_file" "user_data" {
  template = file("user-data.sh")

  vars = {
    server_port = 8080
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }
}

data "aws_ami" "my_amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "hayleylauchconfig" {
  name_prefix     = "t101-lauchconfig-"
  image_id        = data.aws_ami.my_amazonlinux2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.hayleysg.id]
  associate_public_ip_address = true

  # Render the User Data script as a template
  user_data = templatefile("user-data.sh", {
    server_port = 8080
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  })

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "hayleyasg" {
  name                 = "hayleyasg"
  launch_configuration = aws_launch_configuration.hayleylauchconfig.name
  vpc_zone_identifier  = [aws_subnet.hayleysubnet1.id, aws_subnet.hayleysubnet2.id]
  min_size = 2
  max_size = 10

  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.hayleyalbtg.arn]

  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}


resource "aws_lb" "hayleyalb" {
  name               = "t101-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.hayleysubnet1.id, aws_subnet.hayleysubnet2.id]
  security_groups = [aws_security_group.hayleysg.id]

  tags = {
    Name = "t101-alb"
  }
}

resource "aws_lb_listener" "hayleyhttp" {
  load_balancer_arn = aws_lb.hayleyalb.arn
  port              = 8080
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "hayleyalbtg" {
  name = "t101-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.db.outputs.vpcid

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "hayleyalbrule" {
  listener_arn = aws_lb_listener.hayleyhttp.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hayleyalbtg.arn
  }
}

output "hayleyalb_dns" {
  value       = aws_lb.hayleyalb.dns_name
  description = "The DNS Address of the ALB"
}