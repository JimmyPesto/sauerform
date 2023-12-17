resource "local_file" "ansible_inventory" {
  depends_on = [
    hcloud_ssh_key.admin_key,
    hcloud_server.game
  ]
  content = templatefile("templates/inventory.tmpl", {
      ip          = hcloud_server.game.ipv4_address,
      ssh_private_key_file = var.hcloud_admin_priv_key_file,
      ssh_public_key_file = var.hcloud_admin_pub_key_file,
  })
  filename = format("%s/ansible/%s", abspath("${path.root}/.."), "inventory.yml")
}
