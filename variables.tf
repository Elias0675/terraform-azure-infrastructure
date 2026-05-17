variable "resource_group_name" {
  default = "terraform-infra-RG"
}

variable "location" {
  default = "westus2"
}

variable "admin_username" {
  default = "azureuser"
}

variable "trusted_ip" {
  description = "Your trusted IP for SSH"
  default     = "0.0.0.0/0"
}
