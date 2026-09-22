output "availability_zones" {
  description = "List of Availability Zones"
  value       = data.aws_availability_zones.available.names
}
