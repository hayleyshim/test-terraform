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
      #  ASG 추가
      user_data = <<-EOF
              #!/bin/bash
              wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
              mv busybox-x86_64 busybox
              chmod +x busybox
              RZAZ=\$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
              IID=\$(curl 169.254.169.254/latest/meta-data/instance-id)
              LIP=\$(curl 169.254.169.254/latest/meta-data/local-ipv4)
              echo "<h1>RegionAz(\$RZAZ) : Instance ID(\$IID) : Private IP(\$LIP) : Web Server</h1>" > index.html
              nohup ./busybox httpd -f -p 80 &
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



output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}