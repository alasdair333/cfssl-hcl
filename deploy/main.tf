
# Create a container
resource "docker_container" "cffsl_service" {
  image = docker_image.cfssl.latest
  name  = "cfssl"

  ports {
    internal = 8888
    external = 8888
  }
}

resource "docker_image" "cfssl" {
  name          = var.docker_image_name
}
