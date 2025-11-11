# Ansible Role: disable-ipv6

This Ansible role disables IPv6 on Linux systems using either sysctl configuration or GRUB kernel parameters.

## Features

- Two methods for disabling IPv6: `sysctl` or `grub`
- Automatic verification of IPv6 status
- Support for Debian/Ubuntu and RedHat/CentOS systems
- Optional immediate application of changes
- Safe configuration with backup files
- Idempotent: safe to run multiple times

## Prerequisites

- Linux system (Debian/Ubuntu or RedHat/CentOS)
- sudo/root access
- For GRUB method: GRUB bootloader installed

## Variables

The following variables can be overridden:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `ipv6_disable_method` | Method to disable IPv6: `sysctl` or `grub` | `sysctl` |
| `ipv6_sysctl_file` | Path to sysctl configuration file | `/etc/sysctl.d/99-disable-ipv6.conf` |
| `ipv6_grub_file` | Path to GRUB configuration file | `/etc/default/grub` |
| `ipv6_apply_immediately` | Apply sysctl changes immediately | `true` |

## Methods

### Sysctl Method (Default)

Disables IPv6 at runtime by configuring kernel parameters via sysctl:

- Creates a persistent configuration file in `/etc/sysctl.d/`
- Applies changes immediately (if `ipv6_apply_immediately` is true)
- No reboot required if applied immediately
- Changes persist across reboots

### GRUB Method

Disables IPv6 at boot time via kernel parameters:

- Modifies GRUB configuration
- Requires running `update-grub` (done automatically)
- **Requires a system reboot** to take effect
- More permanent solution

## Usage

### In a playbook

```yaml
---
- hosts: all
  roles:
    - disable-ipv6
```

### With custom variables (sysctl method)

```yaml
---
- hosts: all
  roles:
    - role: disable-ipv6
      vars:
        ipv6_disable_method: "sysctl"
        ipv6_apply_immediately: true
```

### With GRUB method

```yaml
---
- hosts: all
  roles:
    - role: disable-ipv6
      vars:
        ipv6_disable_method: "grub"
```

**Note**: When using the GRUB method, you must reboot the system after running the playbook.

## Example Output

### Sysctl Method

```
TASK [disable-ipv6 : Create sysctl configuration to disable IPv6] 
changed: [localhost]

TASK [disable-ipv6 : Apply sysctl settings immediately] 
changed: [localhost]

TASK [disable-ipv6 : Verify IPv6 status] 
ok: [localhost]

TASK [disable-ipv6 : Display IPv6 status] 
ok: [localhost] => {
    "msg": "IPv6 is disabled (value: 1)"
}
```

### GRUB Method

```
TASK [disable-ipv6 : Add IPv6 disable parameter to GRUB] 
changed: [localhost]

TASK [disable-ipv6 : Warning message for GRUB method] 
ok: [localhost] => {
    "msg": "GRUB configuration updated. A reboot is required to apply changes."
}

HANDLER [disable-ipv6 : Update GRUB] 
changed: [localhost]
```

## Verification

After running the role, you can verify IPv6 is disabled:

```bash
# Check sysctl values
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
# Should output: 1 (disabled)

# Check network interfaces (should not show inet6 addresses)
ip addr show

# Test IPv6 connectivity (should fail)
ping6 google.com
```

## Re-enabling IPv6

### If using sysctl method

Remove the configuration file and reload:

```bash
sudo rm /etc/sysctl.d/99-disable-ipv6.conf
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
```

### If using GRUB method

Edit `/etc/default/grub`, remove `ipv6.disable=1`, run `update-grub`, and reboot.

## Role Structure

```
disable-ipv6/
├── defaults/
│   └── main.yml          # Default variables
├── handlers/
│   └── main.yml          # Handlers for applying changes
├── tasks/
│   └── main.yml          # Main tasks
└── README.md             # This documentation
```

## Important Notes

- **Sysctl method**: Changes can be applied immediately without reboot
- **GRUB method**: Requires a system reboot to take effect
- Some applications may not work properly without IPv6
- Ensure your network infrastructure supports IPv4-only operation
- Always test in a non-production environment first

## Troubleshooting

### IPv6 still enabled after running the role

If using sysctl method:
```bash
# Manually reload sysctl
sudo sysctl -p /etc/sysctl.d/99-disable-ipv6.conf
```

If using GRUB method:
```bash
# Verify GRUB configuration
cat /etc/default/grub | grep ipv6

# Reboot the system
sudo reboot
```

### Check current IPv6 status

```bash
# Method 1: Check kernel parameter
cat /proc/sys/net/ipv6/conf/all/disable_ipv6

# Method 2: Check network interfaces
ip -6 addr show
```

## Compatibility

- ✅ Debian 10+
- ✅ Ubuntu 18.04+
- ✅ CentOS 7+
- ✅ RHEL 7+
- ✅ Any Linux distribution with sysctl or GRUB

## Author

JonathanDS30

## References

- [Linux IPv6 Documentation](https://www.kernel.org/doc/Documentation/networking/ipv6.txt)
- [sysctl Documentation](https://man7.org/linux/man-pages/man8/sysctl.8.html)
- [GRUB Documentation](https://www.gnu.org/software/grub/manual/grub/grub.html)
