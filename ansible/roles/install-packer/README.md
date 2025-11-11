# Ansible Role: install-packer

This Ansible role automatically installs the latest available version of HashiCorp Packer.

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
| `packer_api_url` | HashiCorp API URL | `https://api.releases.hashicorp.com/v1/releases/packer/latest` |
| `packer_install_dir` | Installation directory | `/usr/local/bin` |
| `packer_arch` | Target architecture | Auto-detected |
| `packer_os` | Operating system | `linux` |

## Usage

### In a playbook

```yaml
---
- hosts: all
  roles:
    - install-packer
```

### With custom variables

```yaml
---
- hosts: all
  roles:
    - role: install-packer
      vars:
        packer_install_dir: "/opt/packer"
```

## Example Output

```
TASK [install-packer : Display version information] 
ok: [localhost] => {
    "msg": "Current version: 1.9.4 | Latest version: 1.10.0"
}

TASK [install-packer : Install Packer to /usr/local/bin] 
changed: [localhost]

HANDLER [install-packer : Verify Packer installation] 
ok: [localhost]

HANDLER [install-packer : Display installed Packer version] 
ok: [localhost] => {
    "msg": "Packer v1.10.0"
}
```

## Role Structure

```
install-packer/
├── defaults/
│   └── main.yml          # Default variables
├── handlers/
│   └── main.yml          # Handlers to verify installation
├── tasks/
│   └── main.yml          # Main tasks
└── README.md             # This documentation
```

## Verification

After installation, verify Packer is working:

```bash
# Check version
packer version

# Validate a Packer template
packer validate your-template.pkr.hcl

# Initialize Packer plugins
packer init .
```

## Important Notes

- The role checks if Packer is already installed before downloading
- Only installs/updates if the current version differs from the latest
- Requires sudo/root privileges for installation to `/usr/local/bin`
- Dependencies (unzip, curl, gpg) are installed automatically

## Troubleshooting

### Packer command not found after installation

Ensure `/usr/local/bin` is in your PATH:

```bash
echo $PATH | grep -q /usr/local/bin || export PATH=$PATH:/usr/local/bin
```

Add to your `~/.bashrc` to make it permanent:

```bash
export PATH=$PATH:/usr/local/bin
```

### Permission denied

If you get permission errors, ensure you have sudo access:

```bash
sudo -v
```

### Check current installation

```bash
# Show Packer location
which packer

# Show detailed version
packer version

# Show all Packer plugins
packer plugins installed
```

## Compatibility

- ✅ Debian 10+
- ✅ Ubuntu 18.04+
- ✅ CentOS 7+
- ✅ RHEL 7+
- ✅ Any Linux distribution with package manager support

## Integration with Other Tools

This role works well with:

- **install-terraform**: Infrastructure provisioning
- **install-bash_it**: Enhanced shell environment
- **Packer templates**: In the `packer/` directory of this repository

## Author

JonathanDS30

## References

- [Packer Official Documentation](https://www.packer.io/docs)
- [HashiCorp Releases API](https://api.releases.hashicorp.com/)
- [Packer Tutorials](https://learn.hashicorp.com/packer)
