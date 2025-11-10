# Ansible Role: install-terraform

This Ansible role automatically installs the latest available version of Terraform.

## Features

- Automatic detection of the latest version via HashiCorp API
- Multi-architecture support (amd64, arm64)
- Version check to avoid unnecessary reinstallations
- Clean installation with temporary file cleanup
- Idempotent: only reinstalls when necessary

## Prerequisites

- Linux system (Debian/Ubuntu recommended)
- sudo/root access
- Internet connection

## Variables

The following variables can be overridden:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `terraform_api_url` | HashiCorp API URL | `https://api.releases.hashicorp.com/v1/releases/terraform/latest` |
| `terraform_install_dir` | Installation directory | `/usr/local/bin` |
| `terraform_arch` | Target architecture | Auto-detected |
| `terraform_os` | Operating system | `linux` |

## Usage

### In a playbook

```yaml
---
- hosts: all
  roles:
    - install-terraform
```

### With custom variables

```yaml
---
- hosts: all
  roles:
    - role: install-terraform
      vars:
        terraform_install_dir: "/opt/terraform"
```

## Example output

```
TASK [install-terraform : Display version information] 
ok: [localhost] => {
    "msg": "Current version: 1.6.5 | Latest version: 1.6.6"
}

TASK [install-terraform : Install Terraform to /usr/local/bin] 
changed: [localhost]

HANDLER [install-terraform : Verify Terraform installation] 
ok: [localhost]

HANDLER [install-terraform : Display installed Terraform version] 
ok: [localhost] => {
    "msg": "Terraform v1.6.6"
}
```

## Role Structure

```
install-terraform/
├── defaults/
│   └── main.yml          # Default variables
├── handlers/
│   └── main.yml          # Handlers to verify installation
├── tasks/
│   └── main.yml          # Main tasks
└── README.md             # This documentation
```

## Author

JonathanDS30
