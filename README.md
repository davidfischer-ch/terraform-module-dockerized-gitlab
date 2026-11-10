# GitLab Terraform Module (Dockerized)

Manage GitLab EE server.

* Runs in bridge networking mode
* Publishes its HTTPS, HTTP and SSH ports on loopback by default, or on the address given, or none
* Persists config, data, and logs directories
* Built-in support for GitLab Pages, Container Registry, and GeoIP
* Configuration via `gitlab.rb` directives (Omnibus)

Requires GitLab 19.2 or later, which moved the bundled nginx settings under `gitlab_rails['nginx']`
and `gitlab_pages['nginx']`.

## Usage

See [examples/default](examples/default) for a complete working configuration.

```hcl
module "gitlab" {
  source = "git::https://github.com/davidfischer-ch/terraform-module-dockerized-gitlab.git?ref=2.0.0"

  identifier = "gitlab"

  # Process

  image_tag = "19.2.7-ee.0"

  # Networking

  hosts      = { "myserver" = "10.0.0.1" }
  network_id = docker_network.gitlab.id

  # Storage

  data_directory = "/data/gitlab"

  # Application

  gitlab_domain   = "gitlab.example.com"
  pages_domain    = "pages.example.com"
  registry_domain = "registry.example.com"

  timezone = "Europe/Zurich"
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
| `identifier` | `string` | required | Unique name for resources (must match `^[a-z]+(-[a-z0-9]+)*$`). |
| `enabled` | `bool` | `true` | Start or stop the container. |
| `image_tag` | `string` | required | [GitLab EE](https://hub.docker.com/r/gitlab/gitlab-ee/tags) Docker image tag. |
| `hosts` | `map(string)` | `{}` | Extra `/etc/hosts` entries for the container. |
| `network_id` | `string` | required | Docker network to attach to. |
| `listener_address` | `string` | `"127.0.0.1"` | Address the published ports bind to. |
| `https_port` | `number` | `443` | HTTPS bind port, `null` for none. |
| `http_port` | `number` | `80` | HTTP bind port, `null` for none. |
| `ssh_port` | `number` | `22` | SSH bind port, `null` for none. |
| `data_directory` | `string` | required | Host path for persistent volumes. |
| `gitlab_domain` | `string` | required | Main GitLab domain. |
| `pages_domain` | `string` | required | GitLab Pages domain. |
| `registry_domain` | `string` | required | Container Registry domain. |
| `timezone` | `string` | `"UTC"` | Timezone. |
| `log_level` | `string` | `"warn"` | Log level (`debug`, `info`, `warn`, `error`, `fatal`, `unknown`). |
| `trusted_proxies` | `list(string)` | `[]` | IPs/CIDRs to trust as reverse proxies (preserves real client IP in `X-Forwarded-For` for Rack::Attack and audit logs). |
| `extra_config` | `list(string)` | `[]` | Additional `gitlab.rb` configuration directives. |
| `extra_env` | `list(string)` | `[]` | Additional environment variables. |

## Outputs

| Name | Description |
|------|-------------|
| `host` | Container hostname, for containers on its network. |
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
