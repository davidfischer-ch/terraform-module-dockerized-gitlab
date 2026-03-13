# GitLab Terraform Module (Dockerized)

Manage GitLab EE server.

* Runs in bridge networking mode
* Exposes HTTPS, HTTP, and SSH ports
* Persists config, data, and logs directories
* Built-in support for GitLab Pages, Container Registry, and GeoIP
* Configuration via `gitlab.rb` directives (Omnibus)

## Usage

See [examples/default](examples/default) for a complete working configuration.

```hcl
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

  # Networking

  hosts      = { "myserver" = "10.0.0.1" }
  network_id = docker_network.gitlab.id
  https_port = 443
  http_port  = 80
  ssh_port   = 22
}
```

## Data layout

All persistent data lives under `data_directory`:

```
data_directory/
├── config/  # GitLab Omnibus configuration (/etc/gitlab)
├── data/    # GitLab application data (/var/opt/gitlab)
└── logs/    # GitLab log files (/var/log/gitlab)
```

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `identifier` | `string` | — | Unique name for resources (must match `^[a-z]+(-[a-z0-9]+)*$`). |
| `enabled` | `bool` | `true` | Start or stop the container. |
| `image_tag` | `string` | — | [GitLab EE](https://hub.docker.com/r/gitlab/gitlab-ee/tags) Docker image tag. |
| `data_directory` | `string` | — | Host path for persistent volumes. |
| `gitlab_domain` | `string` | — | Main GitLab domain. |
| `pages_domain` | `string` | — | GitLab Pages domain. |
| `registry_domain` | `string` | — | Container Registry domain. |
| `timezone` | `string` | `"UTC"` | Timezone. |
| `log_level` | `string` | `"warn"` | Log level (`debug`, `info`, `warn`, `error`, `fatal`, `unknown`). |
| `extra_config` | `list(string)` | `[]` | Additional `gitlab.rb` configuration directives. |
| `extra_env` | `list(string)` | `[]` | Additional environment variables. |
| `hosts` | `map(string)` | `{}` | Extra `/etc/hosts` entries for the container. |
| `network_id` | `string` | — | Docker network to attach to. |
| `https_port` | `number` | `443` | HTTPS bind port. |
| `http_port` | `number` | `80` | HTTP bind port. |
| `ssh_port` | `number` | `22` | SSH bind port. |

## Outputs

| Name | Description |
|------|-------------|
| `gitlab_domain` | Main GitLab domain. |
| `pages_domain` | GitLab Pages domain. |
| `registry_domain` | Container Registry domain. |
| `https_port` | HTTPS bind port. |
| `http_port` | HTTP bind port. |
| `ssh_port` | SSH bind port. |

## Requirements

* Terraform >= 1.6
* [kreuzwerker/docker](https://github.com/kreuzwerker/terraform-provider-docker) >= 3.0.2
* [hashicorp/local](https://github.com/hashicorp/terraform-provider-local) >= 2.4.1

## References

* https://hub.docker.com/r/gitlab/gitlab-ee/tags
* https://docs.gitlab.com/ee/install/docker.html
