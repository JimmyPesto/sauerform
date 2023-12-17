# setup your SSH keys
resource "hcloud_ssh_key" "admin_key" {
  name       = "AdminHCloudKey"
  public_key = file(var.hcloud_admin_pub_key_file)
}

resource "hcloud_firewall" "ssh_firewall" {
  name       = "ssh"
  # never forget SSH
  rule {
    protocol = "tcp"
    direction = "in"
    port     = 22
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "sauerbraten_firewall" {
  name       = "sauerbraten"
  rule {
    protocol = "tcp"
    direction = "in"
    port     = 28785
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    protocol = "udp"
    direction = "in"
    port     = 28785
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    protocol = "tcp"
    direction = "in"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    port     = 28786
  }

  rule {
    protocol = "udp"
    direction = "in"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    port     = 28786
  }
}


# Create a server
resource "hcloud_server" "game" {
  name        = "braten"
  image       = "docker-ce"
  location    = "fsn1"
  server_type = "cx11"
  ssh_keys    = [hcloud_ssh_key.admin_key.name]
  firewall_ids = [
    hcloud_firewall.sauerbraten_firewall.id,
    hcloud_firewall.ssh_firewall.id
  ]
  depends_on = [
    hcloud_ssh_key.admin_key,
  ]
}


# trigger server configuration
resource "null_resource" "ansible_provisioner" {
  depends_on = [
    local_file.ansible_inventory,
    hcloud_ssh_key.admin_key,
    hcloud_server.game
  ]
  provisioner "local-exec" {
    working_dir = format("%s/%s", abspath("${path.root}/.."), "ansible/")
    command     = "ansible-playbook -i inventory.yml playbook.yml"
  }
}