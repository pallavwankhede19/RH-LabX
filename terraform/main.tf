terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create Docker Network
resource "docker_network" "ansible_net" {
  name = "ansible-net"
}

# Use your prebuilt image (sandbox:latest must exist locally)
resource "docker_image" "rocky" {
  name = "sandbox:latest"
}

# Create 4 server containers and attach them to the network
resource "docker_container" "servers" {
  count       = 4
  name        = "server${count.index + 1}"
  image       = docker_image.rocky.name
  privileged  = true
  restart     = "always"

  ports {
    internal = 22
    external = 3331 + count.index
  }

  networks_advanced {
    name = docker_network.ansible_net.name
  }

  command = ["/usr/sbin/init"]
}

# Attach existing controlnode to the network
resource "null_resource" "attach_controlnode_to_network" {
  provisioner "local-exec" {
    command = "docker network connect ${docker_network.ansible_net.name} controlnode"
  }

  depends_on = [docker_network.ansible_net]
}

