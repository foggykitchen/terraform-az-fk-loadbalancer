# main.tf

locals {
  public_ip_name_effective = coalesce(var.public_ip_name, "${var.name}-public-ip")
  create_public_ip         = var.public_lb && var.create_public_ip
  frontend_public_ip_id    = var.public_lb ? (var.create_public_ip ? try(azurerm_public_ip.this[0].id, null) : var.public_ip_id) : null

  # Ensure stable / explicit defaults
  rule_idle_timeout_in_minutes = try(var.rule.idle_timeout_in_minutes, null)
  rule_enable_floating_ip      = try(var.rule.enable_floating_ip, null)
  rule_disable_outbound_snat   = try(var.rule.disable_outbound_snat, null)

  probe_request_path = try(var.probe.request_path, null)
}

resource "azurerm_public_ip" "this" {
  count = local.create_public_ip ? 1 : 0

  name                = local.public_ip_name_effective
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = var.public_ip_allocation_method
  sku               = var.public_ip_sku

  tags = var.tags

  lifecycle {
    precondition {
      condition     = !var.public_lb || var.create_public_ip || var.public_ip_id != null
      error_message = "public_ip_id must be provided when public_lb is true and create_public_ip is false."
    }
  }
}

resource "azurerm_lb" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                 = var.frontend_name
    public_ip_address_id = local.frontend_public_ip_id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "this" {
  name            = var.backend_pool_name
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  name            = var.probe.name
  loadbalancer_id = azurerm_lb.this.id
  protocol        = var.probe.protocol
  port            = var.probe.port

  interval_in_seconds = var.probe.interval_in_seconds
  number_of_probes    = var.probe.number_of_probes

  # Only valid for Http probes; AzureRM will ignore/validate accordingly.
  request_path = var.probe.protocol == "Http" ? local.probe_request_path : null
}

resource "azurerm_lb_rule" "this" {
  name            = var.rule.name
  loadbalancer_id = azurerm_lb.this.id
  protocol        = var.rule.protocol

  frontend_ip_configuration_name = var.frontend_name

  frontend_port = var.rule.frontend_port
  backend_port  = var.rule.backend_port

  backend_address_pool_ids = [azurerm_lb_backend_address_pool.this.id]
  probe_id                 = azurerm_lb_probe.this.id

  idle_timeout_in_minutes = local.rule_idle_timeout_in_minutes
  enable_floating_ip      = local.rule_enable_floating_ip
  disable_outbound_snat   = local.rule_disable_outbound_snat
}

# VM/NIC-based backend associations (optional)
resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each = toset(var.backend_nic_ids)

  network_interface_id    = each.value
  ip_configuration_name   = var.backend_nic_ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.this.id
}
