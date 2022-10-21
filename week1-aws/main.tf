provider "aws" {
    region = "ap-northeast-1"
    
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}


resource "aws_instance" "example" {
    ami     = "ami-0ca3e2b4a8398fb39"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, T101 Study from Hayley" > index.html
                nohup busybox httpd -f -p \${var.server_port} &
                EOF

    tags = {
        Name = "terraform-Study-101"
    }
}

resource "aws_security_group" "instance" {
    name = var.security_group_name
    vpc_id      = aws_default_vpc.default.id

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}