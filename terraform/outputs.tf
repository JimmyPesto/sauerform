output "braten_game_server_ip_addr" {
  value = hcloud_server.game.ipv4_address
  description = "The public IP address of the game server instance."
}
