resource "azurerm_resource_group" "aks" {
    name        = "${var.rg["aks"]}"
    location    = "${var.region}"
    tags        = "${var.tags}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name			= "aksCluster"
  location		= "${azurerm_resource_group.aks.location}"
  resource_group_name	= "${azurerm_resource_group.aks.name}"
  tags			= "${var.tags}"

  kubernetes_version	= "1.8.2"
  dns_prefix		= "tfaksagent"

  linux_profile {
    admin_username	= "aksadmin"

    ssh_key {
      key_data		= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN90ltVHrYyg97SWMYwKnX6QeOYUk4qhmNS3/dUDf/VEvoSOpwRsMehRCq+hgPwtLBw/pc664djdsERRd6SmGXuivq1vqLMSH4FQVW1hrizPT8jX4iCddm2KGyguDtmObvUGgi0YqMiRMXiiZ7AX6IMyHWFIO5slM369yMkK1MzLgwCVuu+VzxbrVyWsLon/iUdyqgLDq7pxSL5kCxk1YoySGCkwygOKxGTh77bd/y1/t+5uJmKtAxDMD6M7Azsh+NoMSPTQtxoJNq+exIQKz9D+cnGmIifjoKPe+Lh7mUm2CLcNH2TLM9y9S46ybWyO1urr8oIz6WgcyKzAlcP6IX"
    }
  }

  agent_pool_profile {
    name		= "default"
    count		= 1
    vm_size		= "Standard_A1"
    os_type		= "Linux"
    os_disk_size_gb	= 30
    vnet_subnet_id	= "${azurerm_subnet.aks.id}"
  }

  service_principal {
    client_id     = "8a4a31a4-4e92-4806-bae9-b5c60fafc2d3"
    client_secret = "aafc871d-d38f-4b64-9202-1612e38a26c2"
  }
}
