provider "azurerm" {
    version = "2.85.0"
    features{}


}

terraform {
        backend "azurerm" {
            resource_group_name          = "terraformstate"
            storage_account_name         = "tfstorageaccounttorpu"
            container_name               = "tfstate"
            key                          = "terraform.tfstate" 
          
        }
}

variable "imagebuild" {
  type        = string
  description =  "Latest Image Build"
  
}

resource "azurerm_resource_group" "tf_test" {
  name = "tfmainrg"
  location = "UKSOUTH" 
}

resource "azurerm_container_group" "tfcg_test" {
  name                          = "weatherapi"
  location                      = azurerm_resource_group.tf_test.location
  resource_group_name           = azurerm_resource_group.tf_test.name
  
  ip_address_type = "public"
  dns_name_label  =  "torpudocker"
  os_type         =  "Linux"

  container {
     name         = "weatherapi"
     image        = "torpu/weatherapi:${var.imagebuild}"
       cpu          = "1"
       memory       = "1"

       ports{
            port = 80
            protocol = "TCP"
        }
    }
   
}

