output "IP Adress" {
  value = "${digitalocean_droplet.dockerhost.ipv4_address}"
}
