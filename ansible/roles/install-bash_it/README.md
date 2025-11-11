# Ansible Role: install-bash_it

This Ansible role automatically installs and configures Bash-it, a community Bash framework with helpful commands, aliases, and plugins.

## Features

- Automatic cloning and installation of Bash-it from GitHub
- Custom Bobby theme with enhanced prompt display
- SSH completion enabled by default
- Idempotent: safe to run multiple times
- Non-intrusive installation with custom theme template

## Prerequisites

- Linux system (Debian/Ubuntu recommended)
- Git installed
- Bash shell
- Internet connection

## Variables

The following variables can be overridden:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `bash_it_repo` | Git repository URL for Bash-it | `https://github.com/Bash-it/bash-it.git` |
| `bash_it_dir` | Installation directory | `{{ ansible_env.HOME }}/.bash_it` |
| `bash_it_theme` | Theme to activate | `bobby` |
| `bash_it_completions` | List of completions to enable | `['ssh']` |

## Usage

### In a playbook

```yaml
---
- hosts: all
  roles:
    - install-bash_it
```

### With custom variables

```yaml
---
- hosts: all
  roles:
    - role: install-bash_it
      vars:
        bash_it_theme: "powerline"
        bash_it_completions:
          - ssh
          - git
          - docker
```

## Custom Bobby Theme

This role includes a customized Bobby theme that displays:

- **Timestamp**: Current date and time in `YYYY-MM-DD HH:MM:SS` format
- **Ruby version**: If using RVM or rbenv
- **Hostname**: Current machine hostname
- **Working directory**: Full path of current directory
- **Git status**: Branch name with clean (✓) or dirty (✗) indicator
- **Prompt character**: Green arrow (→)

### Theme Configuration

You can customize the theme by setting these environment variables in your `.bashrc`:

```bash
export THEME_SHOW_CLOCK_CHAR="true"           # Show clock character
export THEME_CLOCK_CHAR_COLOR="${red}"        # Clock character color
export THEME_CLOCK_COLOR="${bold_cyan}"       # Clock color
export THEME_CLOCK_FORMAT="%Y-%m-%d %H:%M:%S" # Clock format
```

## Post-Installation

After the role completes, you need to reload your Bash configuration:

```bash
source ~/.bashrc
```

Or simply restart your terminal session.

## Example Output

```
TASK [install-bash_it : Clone Bash-it repository if not exists] 
changed: [localhost]

TASK [install-bash_it : Install Bash-it] 
changed: [localhost]

TASK [install-bash_it : Copy custom bobby theme] 
changed: [localhost]

TASK [install-bash_it : Enable Bash-it theme] 
changed: [localhost]

TASK [install-bash_it : Enable SSH completion] 
changed: [localhost] => (item=ssh)

HANDLER [install-bash_it : Reload bash] 
ok: [localhost] => {
    "msg": "Bash configuration updated. Please run 'source ~/.bashrc' or restart your shell."
}
```

## Prompt Example

After installation, your prompt will look like:

```
2025-11-10 23:15:42 vm-bastion in ~/homelabs
± |main ✓| →
```

Where:
- `2025-11-10 23:15:42` = Current timestamp
- `vm-bastion` = Hostname
- `~/homelabs` = Current directory
- `|main ✓|` = Git branch with clean status

## Role Structure

```
install-bash_it/
├── defaults/
│   └── main.yml                    # Default variables
├── handlers/
│   └── main.yml                    # Handlers for reloading bash
├── tasks/
│   └── main.yml                    # Main installation tasks
├── templates/
│   └── bobby.theme.bash.j2         # Custom Bobby theme template
└── README.md                       # This documentation
```

## Troubleshooting

### Bash-it not loading

Make sure your `.bashrc` contains the Bash-it initialization:

```bash
# Load Bash-it
if [ -f "$HOME/.bash_it/bash_it.sh" ]; then
  source "$HOME/.bash_it/bash_it.sh"
fi
```

### Theme not applying

Verify the theme is set in your `.bashrc`:

```bash
export BASH_IT_THEME='bobby'
```

Then reload your configuration:

```bash
source ~/.bashrc
```

## Additional Completions

To enable more completions after installation, use the Bash-it command:

```bash
bash-it enable completion git
bash-it enable completion docker
bash-it enable completion npm
```

Or add them to the `bash_it_completions` variable in your playbook.

## Author

JonathanDS30

## References

- [Bash-it Official Repository](https://github.com/Bash-it/bash-it)
- [Bash-it Documentation](https://bash-it.readthedocs.io/)
