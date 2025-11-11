# HomeLabs - DevSecOps Learning Environment

Welcome to my HomeLabs repository! This is my personal learning environment where I practice and master DevSecOps philosophy, tools, and best practices.

## 🎯 Purpose

This repository serves as a comprehensive training ground for:

- **DevOps**: Automation, CI/CD, Infrastructure as Code
- **Security**: Security best practices integrated into the development lifecycle
- **Operations**: Configuration management, monitoring, and deployment strategies

### Learning Goals

My main objectives with this HomeLabs environment are to master:

- **Terraform**: Infrastructure as Code and cloud resource provisioning
- **Ansible**: Configuration management and automation
- **Docker**: Containerization and application packaging
- **Kubernetes**: Container orchestration and microservices deployment
- **CI/CD**: Continuous Integration and Continuous Deployment pipelines

## 🏗️ Repository Structure

```
homelabs/
├── packer/              # Image building with HashiCorp Packer
│   ├── linux/          # Linux-based images (Debian 12)
│   └── windows/        # Windows-based images (Windows 11, Windows Server 2022)
├── playbooks/          # Ansible playbooks for automation
├── roles/              # Ansible roles for reusable components
│   ├── install-bash_it/     # Bash-it installation and configuration
│   └── install-terraform/   # Terraform installation
└── README.md           # This file
```

## 🛠️ Technologies & Tools

### Infrastructure as Code
- **Packer**: Automated machine image creation
- **Terraform**: Infrastructure provisioning (role available)

### Configuration Management
- **Ansible**: Automation and configuration management
  - Playbooks for orchestration
  - Roles for modular, reusable configurations

### Operating Systems
- **Linux**: Debian 12 with preseed configuration
- **Windows**: Windows 11 and Windows Server 2022 with unattended installation

### Development Tools
- **Bash-it**: Enhanced Bash environment with custom themes and completions

## 📚 Available Components

### Packer Templates

#### Linux Images
- **Debian 12**: Automated Debian installation with preseed configuration
  - Located in: `packer/linux/debian12/`
  - Includes HTTP preseed configuration

#### Windows Images
- **Windows 11 (x64 FR)**: French Windows 11 desktop image
  - Located in: `packer/windows/win11-x64-fr/`
  - Features: WinRM, Cloud-init, automated sysprep
  
- **Windows Server 2022 (x64 FR)**: French Windows Server 2022
  - Located in: `packer/windows/win2022-x64-fr/`
  - Features: WinRM, Cloud-init, remote desktop configuration

### Ansible Roles

#### install-bash_it
Installs and configures Bash-it framework with:
- Custom Bobby theme with enhanced prompt
- SSH completion enabled
- Automatic version detection
- See: `roles/install-bash_it/README.md`

#### install-terraform
Installs the latest version of Terraform with:
- Automatic version detection via HashiCorp API
- Multi-architecture support (amd64, arm64)
- Idempotent installation
- See: `roles/install-terraform/README.md`

## � Hardware & Infrastructure

This HomeLabs runs on:

- **Hardware**: MINISFORUM NAB9 mini-PC
- **Hypervisor**: Proxmox VE

The MINISFORUM NAB9 provides a powerful and energy-efficient platform for running multiple virtual machines and containers, making it ideal for experimenting with various DevSecOps tools and workflows.

## �🚀 Getting Started

### Prerequisites

- **Packer**: For building machine images
- **Ansible**: For running playbooks and roles
- **Git**: For cloning this repository
- **Virtualization Platform**: Proxmox VE (recommended) or VMware, VirtualBox

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/JonathanDS30/homelabs.git
   cd homelabs
   ```

2. **Run Ansible playbooks**
   ```bash
   cd ansible/playbooks
   ansible-playbook install.yml
   ```

3. **Build Packer images**
   ```bash
   cd packer/linux/debian12
   packer build -var-file=template.debian-12.pkrvars.hcl build.pkr.hcl
   ```

## 📖 Documentation

Each component has its own detailed documentation:

- **Packer configurations**: See individual `README.MD` in `packer/` directory
- **Ansible roles**: Check `README.md` in each role directory
- **Windows provisioning scripts**: Located in `provision/scripts/` directories

## 🎓 Learning Objectives

Through this HomeLabs environment, I'm developing expertise in:

- ✅ **Automation**: Reducing manual tasks through code
- ✅ **Reproducibility**: Creating consistent, repeatable environments
- ✅ **Security**: Implementing security best practices from the start
- ✅ **Infrastructure as Code**: Managing infrastructure through version control
- ✅ **Configuration Management**: Maintaining system consistency at scale
- ✅ **Continuous Learning**: Staying current with DevSecOps tools and practices

## 🔒 Security Considerations

This is a learning environment. Security practices implemented include:

- Automated patching and updates
- Secure configuration baselines
- Credential management best practices
- Network security configurations
- Cloud-init for secure instance initialization

## 🤝 Contributing

This is a personal learning repository, but feedback and suggestions are welcome! Feel free to open issues or submit pull requests.

## 📝 License

This project is for educational purposes.

## 👤 Author

**JonathanDS30**

- GitHub: [@JonathanDS30](https://github.com/JonathanDS30)