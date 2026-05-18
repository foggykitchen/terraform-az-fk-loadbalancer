# inputs.tf

variable "name" {
  description = "Base name used for Azure Load Balancer resources."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "var.name must not be empty."
  }
}

variable "location" {
  description = "Azure region (e.g., westeurope)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name where resources will be created."
  type        = string
}

variable "tags" {
  description = "Tags applied to all supported resources."
  type        = map(string)
  default     = {}
}

variable "public_lb" {
  description = "Backward-compatible switch. When true, the module behaves as a public Load Balancer unless frontend_type is explicitly set. When false, the module behaves as a private Load Balancer unless frontend_type is explicitly set."
  type        = bool
  default     = true
}

variable "frontend_type" {
  description = "Optional explicit frontend type. Supported values: public, private. When null, the module preserves backward compatibility by inferring the type from public_lb."
  type        = string
  default     = null

  validation {
    condition     = var.frontend_type == null || contains(["public", "private"], var.frontend_type)
    error_message = "var.frontend_type must be null, public, or private."
  }
}

variable "create_public_ip" {
  description = "When true and public_lb=true, the module creates its own Public IP. Set to false when supplying an existing public_ip_id."
  type        = bool
  default     = true
}

variable "public_ip_id" {
  description = "Existing Public IP resource ID to attach to the frontend. When null and public_lb=true, the module creates its own Public IP."
  type        = string
  default     = null
}

variable "private_frontend_subnet_id" {
  description = "Subnet ID for a private frontend. Required when the effective frontend type is private."
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Private frontend IP allocation method. Valid values: Dynamic, Static."
  type        = string
  default     = "Dynamic"

  validation {
    condition     = contains(["Dynamic", "Static"], var.private_ip_address_allocation)
    error_message = "var.private_ip_address_allocation must be Dynamic or Static."
  }
}

variable "private_ip_address" {
  description = "Optional private frontend IP address. Use with private_ip_address_allocation = Static."
  type        = string
  default     = null
}

variable "sku" {
  description = "Load Balancer SKU. Standard recommended."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Gateway"], var.sku)
    error_message = "var.sku must be one of: Standard, Gateway."
  }
}

variable "public_ip_name" {
  description = "Optional override for Public IP resource name. If null, derived from var.name."
  type        = string
  default     = null
}

variable "public_ip_sku" {
  description = "Public IP SKU."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard"], var.public_ip_sku)
    error_message = "var.public_ip_sku must be Standard for production-style public LBs."
  }
}

variable "public_ip_allocation_method" {
  description = "Public IP allocation method."
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Static"], var.public_ip_allocation_method)
    error_message = "var.public_ip_allocation_method must be Static for Standard Public IP."
  }
}

variable "frontend_name" {
  description = "Frontend IP configuration name."
  type        = string
  default     = "PublicLBIP"
}

variable "backend_pool_name" {
  description = "Backend address pool name."
  type        = string
  default     = "fk-backend-pool"
}

variable "probe" {
  description = "Health probe configuration."
  type = object({
    name                = string
    protocol            = string # Tcp or Http
    port                = number
    interval_in_seconds = number
    number_of_probes    = number
    request_path        = optional(string) # only for Http (optional v1)
  })

  default = {
    name                = "http-health-probe"
    protocol            = "Tcp"
    port                = 80
    interval_in_seconds = 5
    number_of_probes    = 2
  }

  validation {
    condition     = contains(["Tcp", "Http"], var.probe.protocol)
    error_message = "probe.protocol must be Tcp or Http."
  }
}

variable "rule" {
  description = "Load Balancer rule configuration."
  type = object({
    name                    = string
    protocol                = string # Tcp or Udp
    frontend_port           = number
    backend_port            = number
    idle_timeout_in_minutes = optional(number)
    enable_floating_ip      = optional(bool)
    disable_outbound_snat   = optional(bool)
  })

  default = {
    name          = "http-rule"
    protocol      = "Tcp"
    frontend_port = 80
    backend_port  = 80
  }

  validation {
    condition     = contains(["Tcp", "Udp"], var.rule.protocol)
    error_message = "rule.protocol must be Tcp or Udp."
  }
}

variable "backend_nic_ids" {
  description = "Optional list of NIC IDs to attach to the backend pool (VM-based backend). Leave empty for VMSS-based backend."
  type        = list(string)
  default     = []
}

variable "backend_nic_ip_configuration_name" {
  description = "NIC IP configuration name used for backend pool associations."
  type        = string
  default     = "ipconfig1"
}
