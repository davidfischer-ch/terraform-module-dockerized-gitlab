resource "docker_network" "gitlab" {
  name   = "gitlab"
  driver = "bridge"
}

module "gitlab" {
  source = "git::https://github.com/davidfischer-ch/terraform-module-dockerized-gitlab.git?ref=1.0.2"

  identifier     = "gitlab"
  enabled        = true
  image_tag      = "17.8.3-ee.0"
  data_directory = "/data/gitlab"

  gitlab_domain   = "gitlab.example.com"
  pages_domain    = "pages.example.com"
  registry_domain = "registry.example.com"

  timezone  = "Europe/Zurich"
  log_level = "warn"

  network_id = docker_network.gitlab.id
  https_port = 443
  http_port  = 80
  ssh_port   = 22
}
