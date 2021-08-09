provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "project2" {
  name     = "myproject3"
  location = "westus"
}

resource "azurerm_storage_account" "storage" {
  name                     = "pro2sto2"
  resource_group_name      = azurerm_resource_group.project2.name
  location                 = azurerm_resource_group.project2.location
  account_tier             = "Standard" 
  account_replication_type = "LRS"
  allow_blob_public_access = true
  
}

resource "azurerm_storage_container" "storage" {
  name                  = "proj2"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "blob"
}

resource "azurerm_app_service_plan" "appser" {
  name = "ajithapp1"
  location = azurerm_resource_group.project2.location
  resource_group_name = azurerm_resource_group.project2.name
  kind = "windows"
  reserved = false  
  sku {
    tier = "Standard"
    size = "S1"
  }  
  
}


resource "azurerm_app_service" "appser" {
  name                = "ajipto2012"
  resource_group_name      = azurerm_resource_group.project2.name
  location                 = azurerm_resource_group.project2.location
  app_service_plan_id = azurerm_app_service_plan.appser.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
}

resource "azurerm_mysql_server" "mysql" {
  name                = "ajithpro4"
  location            = azurerm_resource_group.project2.location
  resource_group_name = azurerm_resource_group.project2.name

  administrator_login          = "vmadmin"
  administrator_login_password = "Ajithkumar@1314"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}
resource "azurerm_kubernetes_cluster" "kub" {
  name                = "project2"
  location            = azurerm_resource_group.project2.location
  resource_group_name = azurerm_resource_group.project2.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
