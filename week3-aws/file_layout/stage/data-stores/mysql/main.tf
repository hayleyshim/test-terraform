/*resource "aws_db_subnet_group" "hayleydbsubnet" {
  name       = "hayleydbsubnetgroup"
  subnet_ids = [aws_subnet.hayleysubnet3.id, aws_subnet.hayleysubnet4.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "hayleyrds" {
  identifier_prefix      = "t101"
  engine                 = "hayleysql"
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.hayleydbsubnet.name
  vpc_security_group_ids = [aws_security_group.hayleysg2.id]
  skip_final_snapshot    = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
}*/