output "availability_zones" {
  description = "List of Availability Zones"
  value       = data.aws_availability_zones.available.names
}

output "public_subnet_az" {
  description = "Availability Zone of the public subnet"
  value       = aws_subnet.ts_public_subnet.availability_zone
}

output "backend_subnet_az" {
  description = "Availability Zone of the backend subnet"
  value       = aws_subnet.ts_private_subnet.availability_zone
}

output "database_subnet_az" {
  description = "Availability Zone of the database subnet"
  value       = aws_subnet.ts_database_subnet.availability_zone
}
