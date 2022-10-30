output "address" {
  value       = aws_db_instance.hayleyrds.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.hayleyrds.port
  description = "The port the database is listening on"
}

output "vpcid" {
  value       = aws_vpc.hayleyvpc.id
  description = "hayley VPC Id"
}