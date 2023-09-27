resource "azurerm_public_ip" "lb_pubip" {
  name                = "example-lb-pubip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
    domain_name_label   = "antoinechanelterraformdns"

}


# Create Balancer
resource "azurerm_lb" "example_lb" {
  name                = "example-lb"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pubip.id
  }
}

# Load Balancer rule
resource "azurerm_lb_rule" "lb_rule_5000" {
  loadbalancer_id               = azurerm_lb.example_lb.id
  name                          = "Port5000Access"
  protocol                      = "Tcp"
  frontend_port                 = 5000
  backend_port                  = 5000
  frontend_ip_configuration_name = "publicIPAddress"
  backend_address_pool_ids      = [azurerm_lb_backend_address_pool.backend_pool.id]
}


# Load Balancer Backend
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.example_lb.id
  name            = "backendAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_to_backendpool" {
  network_interface_id    = azurerm_network_interface.nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}