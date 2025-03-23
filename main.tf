terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "=1.11.2"
}

provider "yandex" {
  cloud_id                 = "b1g2rlcme57nmrfvfker"
  folder_id                = "b1glatp639he3a6n054t"
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = var.zone

}
resource "yandex_vpc_network" "netology-net" {
  name = var.vpc_network
}