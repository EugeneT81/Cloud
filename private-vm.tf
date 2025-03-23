resource "yandex_vpc_route_table" "privat-rt" {
  network_id = yandex_vpc_network.netology-net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = "192.168.10.254"
  }
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = var.subnet_name2
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.zone
  network_id     = yandex_vpc_network.netology-net.id
  route_table_id = yandex_vpc_route_table.privat-rt.id
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "private-host-instance" {
  name        = "host-instance"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }
}