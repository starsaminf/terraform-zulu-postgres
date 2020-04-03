# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {}

# Token https://www.hetzner.com/cloud
provider "hcloud" {
  token = var.hcloud_token
}

# Adding ssh_key
resource "hcloud_ssh_key" "default" {
  name = "pubkey"
  public_key = file("../../my_ssh_key.pub")
}

#create private network
resource "hcloud_network" "gestar-net" {
  name = "gestar-net"
  ip_range = "10.0.0.0/8"
}

#create subnet
resource "hcloud_network_subnet" "gestar-subnet" {
  network_id = hcloud_network.gestar-net.id
  type = "server"
  network_zone = "eu-central"
  ip_range   = "10.0.1.0/24"
}

# Create a server
resource "hcloud_server" "gestar-db" {
  name = "gestar-db"
  image = "centos-8"
  server_type = "cx11"
  backups = false
  ssh_keys = [hcloud_ssh_key.default.id]
}

# Attach private network to server
resource "hcloud_server_network" "srvnetwork" {
  server_id = hcloud_server.gestar-db.id
  network_id = hcloud_network.gestar-net.id
  ip = "10.0.1.5"
}

# Provisioning Server

resource "null_resource" "deploy" {

  connection {
      host          = hcloud_server.gestar-db.ipv4_address
      user          = "root"
      private_key   = file("../../my_ssh_key")
      type         = "ssh"
  }

  provisioner "file" {
    source      = "postgres.sh"
    destination = "/tmp/postgres.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/postgres.sh",
      "/tmp/./postgres.sh",
    ]
  }
}


