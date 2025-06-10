terraform {
   backend "azurerm" {
      resource_group_name = "demo-rg"
      storage_account_name = "storage52087608"
      container_name = "sclab06"
      key = "demo-rg.terraform.tfstate"
   }
}