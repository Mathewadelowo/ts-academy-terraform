output "availability_zones" {
  description = "List of Availability Zones"
  value       = data.aws_availability_zones.available.names
}

output "public_subnet_1_az" {
  description = "Availability Zone of public subnet 1"
  value       = aws_subnet.ts_public_subnet_1.availability_zone
}

output "public_subnet_2_az" {
  description = "Availability Zone of public subnet 2"
  value       = aws_subnet.ts_public_subnet_2.availability_zone
}

output "backend_subnet_1_az" {
  description = "Availability Zone of backend subnet 1"
  value       = aws_subnet.ts_backend_subnet_1.availability_zone
}

output "backend_subnet_2_az" {
  description = "Availability Zone of backend subnet 2"
  value       = aws_subnet.ts_backend_subnet_2.availability_zone
}

output "database_subnet_1_az" {
  description = "Availability Zone of database subnet 1"
  value       = aws_subnet.ts_database_subnet_1.availability_zone
}

output "database_subnet_2_az" {
  description = "Availability Zone of database subnet 2"
  value       = aws_subnet.ts_database_subnet_2.availability_zone
}
