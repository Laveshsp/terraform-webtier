variable "nsg_location" {

}
variable "nsg_name" {

}
variable "nsg_rg_name" {

}
variable "nsg_tags" {

}
variable "nsg_rules" {
  description = "List of security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}