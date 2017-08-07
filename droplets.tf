provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "tf"
  public_key = "${file("${var.public_key_path}")}"
}

resource "digitalocean_droplet" "dockerhost" {
  image    = "ubuntu-17-04-x64"
  name     = "dh-test"
  region   = "lon1"
  size     = "512mb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
    }

    inline = [
      "wget -qO- https://get.docker.com/ | sh",
    ]
  }
}


resource "digitalocean_droplet" "vpn"{
  image    = "ubuntu-17-04-x64"
  name     = "vpn-ams"
  region   = "ams3"
  size     = "512mb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
    }

    inline = [
      "wget https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh"
    ]
  }

}
