resource "azurerm_resource_group" "rg" {
  name     = "acr-aksrg"
  location = "West Europe"
}

resource "azurerm_container_registry" "ACR" {
  name                = "containerRegistry1gfdgdf"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
}

resource "azurerm_kubernetes_cluster" "AKS" {
  name                = "azurecluster234253"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "examplagsag123w"

  default_node_pool {
    name       = "default34"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.AKS.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.ACR.id
  skip_service_principal_aad_check = true
}
