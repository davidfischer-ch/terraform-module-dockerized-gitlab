# Changelog

## Release v2.1.0 (2026-11-10)

Diff: https://github.com/davidfischer-ch/terraform-module-dockerized-gitlab/compare/2.0.0...2.1.0

### Minor compatibility breaks

Networking:

* Publish the HTTPS, HTTP and SSH ports on `listener_address`, `127.0.0.1` by default instead of `0.0.0.0`
    * Set `listener_address = "0.0.0.0"` to keep them reachable from every network

### Features

Networking:

* Allow `https_port`, `http_port` and `ssh_port` to be `null`, to publish no port
* Add the `host` output, the container's hostname for containers on its network

## Release v2.0.0 (2026-10-01)

### Compatibility breaks

* Require GitLab 19.2 or later
    * Bundled nginx settings move to `gitlab_rails['nginx']` and `gitlab_pages['nginx']`
    * The `nginx[...]` and `pages_nginx[...]` keys they replace are deprecated since 19.2

### Fix and enhancements

* Drop the Spamcheck log level, GitLab 19.0 aborts reconfigure on any Spamcheck setting

## Release v1.1.0 (2026-09-14)

### Minor compatibility breaks

* Bound the container restart policy at five attempts instead of retrying forever
    * A GitLab that cannot boot now stays down instead of looping
    * An endless loop hides the fault and pays for a full reconfigure on every attempt

### Fix and enhancements

* Extend `trusted_proxies` to the bundled nginx `real_ip` module
    * The inner nginx overwrote `X-Forwarded-For` before Rails ever saw it

## Release v1.0.5 (2026-04-27)

### Fix and enhancements

* Add `trusted_proxies` variable so the real client IP is preserved when GitLab sits behind a reverse proxy (otherwise Rack::Attack rate-limits the proxy IP and locks out everyone)

## Release v1.0.4 (2026-03-14)

### Fix and enhancements

* Reorder variables to be consistent

## Release v1.0.3 (2026-03-13)

### Fix and enhancements

* Set `enabled` default to `true`
* Refine variable descriptions, validators, and attribute ordering
* Add `examples/default/` Terraform example
* Remove redundant default values from examples and README

## Release v1.0.2 (2025-05-15)

### Fix and enhancements

* Pages: Toggle namespace in path
* Module: Declare network_mode bridge to prevent infinite recreate

## Release v1.0.1 (2025-03-03)

### Fix and enhancements

* Enable Pages access control

## Release v1.0.0 (2025-01-20)

Initial release
