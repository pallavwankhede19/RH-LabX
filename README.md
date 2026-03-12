# 🐧 RH-LabX - RHCE Ansible Lab Environment

A comprehensive Docker-based lab environment designed for RHCE (Red Hat Certified Engineer) certification training and hands-on Linux administration practice.

## 🎯 Overview

**RH-LabX** provides a complete containerized lab environment for RHCE certification preparation. It creates a multi-server setup with 4 Rocky Linux servers and 1 control node, pre-configured with all necessary tools for hands-on Linux administration practice.

## ✨ Features

### **Lab Environment**
- **4 Rocky Linux Server Containers** (server1-4)
- **1 Control Node** for Ansible management
- **Dedicated Docker Network** for container communication
- **SSH Access** on ports 3331-3334

### **Pre-installed Tools**
- **Ansible** for configuration management
- **Terraform** for infrastructure as code
- **Complete Web Stack** (Apache, MariaDB, PHP)
- **Network Services** (SSH, NFS, Samba)
- **System Tools** (LVM, firewalld, chrony)
- **Development Tools** (git, vim, curl, wget)

### **RHCE Curriculum Coverage**
- ✅ LVM Storage Management
- ✅ Network Service Configuration
- ✅ Web Server Administration
- ✅ Database Management
- ✅ Security Configuration
- ✅ System Automation
- ✅ Container Orchestration



## 📋 Prerequisites

- **Docker** (version 20.10 or higher)
- **Docker Compose** (version 1.29 or higher) (optional)
- **Terraform** (version 1.0 or higher)
- **Git** (for cloning the repository)
- **SSH client** (for connecting to containers)

### **System Requirements**
- **OS**: Linux, macOS, or Windows with WSL2
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 5GB free space
- **Network**: Internet connection for initial setup

## 🚀 Quick Start
## 🔧 Installation

### **Step 1: Clone Repository**
```bash
git clone https://github.com/your_username/RH-LabX.git
cd RH-LabX
ls (It will show you all files required for this environment)
```
### **step 2: create Docker image and main Docker container named controlnode**
```bash
sudo docker build -t sandbox:latest .
sudo docker images
sudo docker run -d --privileged --name controlnode --hostname controlnode -p 2222:22 --tmpfs /run --tmpfs /run/lock -v /var/run/docker.sock:/var/run/docker.sock -v /sys/fs/cgroup:/sys/fs/cgroup:ro sandbox /usr/sbin/init
# Check running containers
sudo docker ps
``` 
### **Step 3: Using Terraform build servers **
```bash
If terrform is not installed then install it by following steps
1. Add HashiCorp GPG key
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
2. Add the official Terraform repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
3. Install Terraform
sudo apt-get update
sudo apt-get install terraform
4. Verify Installation
terraform -version
cd terraform
sudo terraform init
sudo terraform plan
sudo terraform apply
# Check running containers
sudo docker ps
```
### **step 4: check if main controlnode and servers are connected to same Docker Network
```bash
# check Docker network inspect
sudo docker network inspect ansible-net
sudo docker network connect ansible-net controlnode
```
### **step 5: switch inside in controlnode 
```bash
sudo docker exec -it controlnode bash
# After switching inside in controlnode
it will show like this
[root@machineID /]
# change directory
[root@machineID /] cd /
# After changing directory it should show like this
[root@machineID ~] 
# Run "setup_all.sh" script to connect ssh with all containers and create lvm environment 
[root@machineID ~] chmod +x /setup_all.sh
[root@machineID ~] ./setup_all.sh
it will connect all servers to main controlnode with ssh also give full environment to practice LVM
```
### ***step 6: Test ssh with all servers with Inventory and ansible.cgf
```bash
# Make directories
1. [root@machineID ~] mkdir roles
2. [root@machineID ~] mkdir mycollections
# Inside a controlnode make ansible.cfg
3. [root@machineID ~] vim ansible.cfg
it should open vim editor, then write following commands to configure servers to controlnode
[defaults]
inventory = ./inventory
roles_path = ./roles
collections_path = ./mycollection
remote_user = root
ask_pass = false

[priviliege_escalation]
become = true
become_method = sudo
become_remote_user = root
become_ask_pass = false

:wq (save it with like this and exit vim editor)
# Make Inventory
4. [root@machineID ~] vim inventory
[servers]
server1
server2
server3
server4

:wq (save it with like this and exit vim editor)
# Now ping all servers with main controlnode
5. [root@machineID ~] ansible -m ping all
it should show all severs has been ping pong
# (optional if ansible.cfg is not present)
6. [root@machineID ~] ansible -i inventory -m ping all
it should show all severs has been ping pong


### **Practice Scenarios**
- **LVM Management**: Create, resize, and manage logical volumes
- **Web Server Setup**: Configure Apache with virtual hosts
- **Database Administration**: Set up MariaDB with user management
- **Network Services**: Configure NFS shares and Samba server
- **Security**: Implement firewalld rules and SELinux policies
```

## 📁 Project Structure
```
RH-LabX/
├── 📄 README.md                    # This file
├── 📄 Dockerfile                   # Container configuration
├── 📄 entrypoint.sh               # Container startup script
├── 📄 setup_all.sh                # Main setup automation
├── 📄 rescue.sh                   # LVM recovery script
├── 📄 terraform.tfstate           # Infrastructure state
├── 📁 terraform/                  # Infrastructure as code
│   ├── 📄 main.tf                 # Docker container definitions
│   ├── 📄 variables.tf            # Configuration variables
│   ├── 📄 terraform.tfstate       # Current state
│   └── 📄 terraform.tfstate.backup # Previous state backup
└── 📁 docs/                       # Documentation (future)
```



## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### **Ways to Contribute**
- 🐛 Report bugs via GitHub Issues
- 💡 Suggest new features or scenarios
- 📖 Improve documentation
- 🔧 Submit pull requests for enhancements

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Red Hat** for the RHCE certification curriculum
- **Rocky Linux** community for the base container image
- **Docker** for containerization technology
- **Terraform** for infrastructure automation

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/RH-LabX/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/RH-LabX/discussions)
- **Wiki**: [Project Wiki](https://github.com/yourusername/RH-LabX/wiki)

---

**Happy Learning!** 🎓 **RH-LabX** is designed to provide hands-on experience with real-world Linux administration scenarios. Start with the quick start guide and work through the practice scenarios to build your RHCE skills.
</result>
</attempt_completion>



