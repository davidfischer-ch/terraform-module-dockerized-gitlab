resource "docker_network" "gitlab" {
  name   = "gitlab"
  driver = "bridge"
}

module "gitlab" {
  source = "git::https://github.com/davidfischer-ch/terraform-module-dockerized-gitlab.git?ref=1.0.4"

  identifier = "gitlab"

  # Process

  image_tag = "17.8.3-ee.0"

  # Networking

  network_id = docker_network.gitlab.id

  # Storage

  data_directory = "/data/gitlab"

  # Application

  gitlab_domain   = "gitlab.example.com"
  pages_domain    = "pages.example.com"
  registry_domain = "registry.example.com"

  timezone = "Europe/Zurich"
}
