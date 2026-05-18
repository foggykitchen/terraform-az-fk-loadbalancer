# outputs.tf

output "lb_id" {
  description = "Load Balancer resource ID."
  value       = azurerm_lb.this.id
}

output "lb_name" {
  description = "Load Balancer name."
  value       = azurerm_lb.this.name
}

output "frontend_ip_configuration_name" {
  description = "Frontend IP configuration name."
  value       = var.frontend_name
}

output "frontend_type" {
  description = "Effective frontend type."
  value       = local.frontend_type
}

output "public_ip_id" {
  description = "Public IP resource ID when the effective frontend type is public, either created by the module or provided externally."
  value       = local.frontend_type == "public" ? (var.create_public_ip ? try(azurerm_public_ip.this[0].id, null) : var.public_ip_id) : null
}

output "public_ip_address" {
  description = "Public IP address when the module creates a public frontend IP. Null for existing public IPs or private frontends."
  value       = local.frontend_type == "public" && var.create_public_ip ? azurerm_public_ip.this[0].ip_address : null
}

output "private_ip_address" {
  description = "Private frontend IP address when the effective frontend type is private."
  value       = local.frontend_type == "private" ? azurerm_lb.this.frontend_ip_configuration[0].private_ip_address : null
}

output "backend_pool_id" {
  description = "Backend Address Pool ID. Use this to attach VMSS backends."
  value       = azurerm_lb_backend_address_pool.this.id
}

output "probe_id" {
  description = "Health probe ID."
  value       = azurerm_lb_probe.this.id
}

output "rule_id" {
  description = "LB rule ID."
  value       = azurerm_lb_rule.this.id
}
