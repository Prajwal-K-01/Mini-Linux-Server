# 🖥️ Mini Linux Server Setup on Red Hat Enterprise Linux

<p align="center">
  <img src="https://img.shields.io/badge/OS-Red%20Hat%20Enterprise%20Linux-red?style=for-the-badge&logo=redhat&logoColor=white" alt="RHEL">
  <img src="https://img.shields.io/badge/Linux-Server-black?style=for-the-badge&logo=linux&logoColor=white" alt="Linux">
  <img src="https://img.shields.io/badge/Shell-Bash-green?style=for-the-badge&logo=gnubash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/Web%20Server-Apache-orange?style=for-the-badge&logo=apache&logoColor=white" alt="Apache">
  <img src="https://img.shields.io/badge/Security-SELinux-blue?style=for-the-badge" alt="SELinux">
  <img src="https://img.shields.io/badge/Firewall-firewalld-purple?style=for-the-badge" alt="firewalld">
</p>

<p align="center">
  <b>A production-style Linux server administration project built on Red Hat Enterprise Linux.</b>
</p>

<p align="center">
  <i>From a fresh RHEL virtual machine to a secured, monitored and automated mini server.</i>
</p>

---

## 🚀 Project Overview

**Mini Linux Server Setup** is a hands-on Linux system administration project that transforms a Red Hat Enterprise Linux virtual machine into a **production-style mini server environment**.

The project demonstrates practical implementation of:

* 🐧 RHEL system administration
* 👥 User and group management
* 🔐 Sudo and access control
* 🌐 Network configuration
* 🔑 SSH remote administration
* 🔥 Firewall configuration
* 🌍 Apache web server deployment
* 🛡️ SELinux security
* 💾 Server storage organization
* 📊 System monitoring
* 📝 Log management
* 💿 Automated backups
* 🩺 Server health monitoring
* ⏰ Cron-based automation
* 🔎 Security verification
* 📚 Professional infrastructure documentation

The goal is not simply to install Linux services, but to understand **how different server components work together in a real administration environment**.

---

# 🎯 Project Objectives

The main objectives of this project are:

```text
┌───────────────────────────────────────────────────────────┐
│                  MINI LINUX SERVER                        │
├───────────────────────────────────────────────────────────┤
│                                                           │
│  ✓ Configure RHEL as a server                            │
│  ✓ Configure hostname and networking                     │
│  ✓ Create users and administrative groups                │
│  ✓ Configure sudo privileges                              │
│  ✓ Enable secure SSH administration                      │
│  ✓ Configure firewalld                                   │
│  ✓ Deploy Apache HTTP Server                              │
│  ✓ Configure SELinux                                     │
│  ✓ Organize application and backup storage               │
│  ✓ Monitor CPU, RAM, disk and processes                  │
│  ✓ Manage system and service logs                        │
│  ✓ Automate backups using Bash + Cron                    │
│  ✓ Generate server health reports                        │
│  ✓ Perform security verification                          │
│  ✓ Document the complete infrastructure                  │
│                                                           │
└───────────────────────────────────────────────────────────┘
```

---

# 🏗️ Architecture

```text
                         ┌──────────────────────┐
                         │      Administrator   │
                         │      / Developer     │
                         └──────────┬───────────┘
                                    │
                         SSH / HTTP │
                                    ▼
              ┌───────────────────────────────────────┐
              │       RHEL MINI LINUX SERVER          │
              │                                       │
              │  ┌─────────────────────────────────┐  │
              │  │       System Administration     │  │
              │  │                                 │  │
              │  │ Users │ Groups │ Sudo │ SSH    │  │
              │  └─────────────────────────────────┘  │
              │                    │                  │
              │  ┌─────────────────▼────────────────┐ │
              │  │          Security Layer          │ │
              │  │                                 │ │
              │  │ firewalld │ SELinux │ Permissions│ │
              │  └─────────────────────────────────┘ │
              │                    │                  │
              │  ┌─────────────────▼────────────────┐ │
              │  │          Application Layer       │ │
              │  │                                 │ │
              │  │          Apache HTTP Server      │ │
              │  └─────────────────────────────────┘ │
              │                    │                  │
              │  ┌─────────────────▼────────────────┐ │
              │  │       Storage & Monitoring       │ │
              │  │                                 │ │
              │  │ Logs │ Backups │ Health Checks  │ │
              │  └─────────────────────────────────┘ │
              │                    │                  │
              │  ┌─────────────────▼────────────────┐ │
              │  │           Automation             │ │
              │  │                                 │ │
              │  │       Bash Scripts + Cron        │ │
              │  └─────────────────────────────────┘ │
              └───────────────────────────────────────┘
```

---

# ⚙️ Technology Stack

| Technology                  | Purpose                               |
| --------------------------- | ------------------------------------- |
| 🐧 Red Hat Enterprise Linux | Server operating system               |
| 🖥️ VMware Workstation      | Virtualization environment            |
| 🐚 Bash                     | Automation and administration scripts |
| 🌐 Apache HTTP Server       | Web server                            |
| 🔐 OpenSSH                  | Secure remote administration          |
| 🔥 firewalld                | Network firewall                      |
| 🛡️ SELinux                 | Mandatory access control              |
| ⏰ Cron                      | Task scheduling                       |
| 📊 systemd                  | Service management                    |
| 📋 journalctl               | System/service logging                |
| 🔧 Git                      | Version control                       |
| 🐙 GitHub                   | Project hosting and documentation     |

---

# 🔧 Server Configuration

## 🖥️ System Configuration

The server is configured with:

* Custom hostname
* RHEL operating system
* Network interface
* IP address
* Default gateway
* DNS configuration
* Storage structure
* System resource monitoring

Example:

```bash
hostnamectl
cat /etc/redhat-release
uname -r
uptime
free -h
df -h
```

---

# 👥 User & Group Management

Dedicated users and groups are created according to their responsibilities.

### Users

| User          | Role                    |
| ------------- | ----------------------- |
| `serveradmin` | Server administration   |
| `developer`   | Application development |
| `backupuser`  | Backup management       |

### Groups

```text
administrators
developers
backup
wheel
```

Example:

```bash
sudo useradd -m -s /bin/bash serveradmin
sudo useradd -m -s /bin/bash developer
sudo useradd -m -s /bin/bash backupuser
```

Users are assigned only the privileges required for their responsibilities.

---

# 🔑 SSH Administration

OpenSSH is configured for remote server administration.

```bash
sudo systemctl enable --now sshd
sudo systemctl status sshd
```

SSH service:

```text
Port: 22
Service: sshd
```

Connection example:

```bash
ssh serveradmin@SERVER_IP
```

---

# 🔥 Firewall Configuration

`firewalld` is enabled to control incoming network connections.

Allowed services:

```text
SSH   → 22/tcp
HTTP  → 80/tcp
```

Configuration:

```bash
sudo systemctl enable --now firewalld

sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http

sudo firewall-cmd --reload
```

Verification:

```bash
sudo firewall-cmd --list-all
```

---

# 🌐 Apache Web Server

Apache HTTP Server is deployed as the web application layer.

Installation:

```bash
sudo dnf install httpd -y
```

Enable and start:

```bash
sudo systemctl enable --now httpd
```

Check service:

```bash
sudo systemctl status httpd
```

Default web root:

```text
/var/www/html
```

Test locally:

```bash
curl http://localhost
```

The server can also be accessed through:

```text
http://SERVER_IP
```

---

# 🛡️ SELinux Security

SELinux is configured in **Enforcing** mode.

Verification:

```bash
getenforce
```

Expected:

```text
Enforcing
```

Detailed status:

```bash
sestatus
```

SELinux provides an additional security layer beyond traditional Linux file permissions.

---

# 💾 Server Storage Architecture

Dedicated directories are created to separate application data, backups and logs.

```text
/server-data/
│
├── application/
│
├── backups/
│
└── logs/
```

Ownership:

```text
/server-data                  → root:root
/server-data/application      → developer:developers
/server-data/backups          → backupuser:backup
/server-data/logs             → root:root
```

This structure provides clear separation between different types of server data.

---

# 📊 Server Monitoring

The project includes monitoring of:

* CPU utilization
* Memory utilization
* Disk usage
* Running processes
* Network connections
* Listening ports
* Running services
* Application processes

Useful commands:

```bash
top
htop
free -h
df -h
du -sh /server-data/*
ps aux
sudo ss -tulpn
systemctl --type=service --state=running
```

---

# 📝 Log Management

Important server logs are monitored using:

```bash
journalctl
```

Apache logs:

```text
/var/log/httpd/
```

Examples:

```bash
sudo journalctl --since today
sudo journalctl -u sshd
sudo journalctl -u httpd
sudo ls -lh /var/log/httpd/
```

Logs help with:

* Troubleshooting
* Security analysis
* Service monitoring
* Failure investigation
* Operational auditing

---

# 💿 Automated Backup System

The project includes a Bash-based automated backup system.

### Backup Flow

```text
Application Data
       │
       ▼
 backup.sh
       │
       ▼
Timestamped TAR.GZ
       │
       ▼
/server-data/backups/
       │
       ▼
Archive Verification
       │
       ▼
Old Backups Cleanup
```

The backup script:

* Creates timestamped archives
* Compresses application data
* Verifies archive integrity
* Stores backup logs
* Retains the latest backups
* Removes older backup archives

Run manually:

```bash
sudo ./scripts/backup.sh
```

---

# 🩺 Server Health Monitoring

The project also contains a health monitoring script.

```text
health-check.sh
```

It checks:

```text
✓ Hostname
✓ Operating System
✓ Kernel
✓ Uptime
✓ CPU
✓ Memory
✓ Disk
✓ Network
✓ SSH
✓ Apache
✓ Firewall
✓ SELinux
✓ Listening Ports
✓ Server Storage
```

Run:

```bash
sudo ./scripts/health-check.sh
```

Generated report:

```text
/server-data/logs/health-report.txt
```

---

# ⏰ Automation with Cron

Cron is used to automate repetitive server administration tasks.

Check Cron:

```bash
systemctl status crond
```

Enable it:

```bash
sudo systemctl enable --now crond
```

Example scheduled backup:

```text
0 2 * * * /path/to/scripts/backup.sh
```

This demonstrates how routine server operations can be automated instead of performed manually.

---

# 🔐 Security Implementation

Security controls implemented in this project include:

```text
┌─────────────────────────────────────┐
│         SECURITY CONTROLS           │
├─────────────────────────────────────┤
│ ✓ User-based access control         │
│ ✓ Group-based permissions            │
│ ✓ Sudo administration                │
│ ✓ SSH remote access                  │
│ ✓ Firewall protection                │
│ ✓ SELinux Enforcing mode             │
│ ✓ Restricted directory ownership     │
│ ✓ Service verification               │
│ ✓ Listening-port inspection          │
│ ✓ Log monitoring                     │
│ ✓ Backup verification                │
│ ✓ System health checks               │
└─────────────────────────────────────┘
```

Security verification:

```bash
sudo ss -tulpn
sudo firewall-cmd --list-all
getenforce
sudo systemctl status sshd
sudo journalctl -u sshd
```

---

# 📁 Project Structure

```text
mini-linux-server/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── scripts/
│   ├── backup.sh
│   └── health-check.sh
│
├── config/
│   ├── users.txt
│   └── server-info.txt
│
├── docs/
│   ├── architecture.md
│   ├── installation.md
│   ├── security.md
│   └── troubleshooting.md
│
├── reports/
│   └── server-report.txt
│
└── screenshots/
    ├── system-info.png
    ├── network.png
    ├── users-groups.png
    ├── ssh.png
    ├── firewall.png
    ├── apache.png
    ├── website.png
    ├── selinux.png
    ├── monitoring.png
    └── health-report.png
```

---

# 📸 Project Screenshots

## 🖥️ System Information

![System Information](screenshots/system-info.png)

## 🌐 Network Configuration

![Network Configuration](screenshots/network.png)

## 👥 Users & Groups

![Users and Groups](screenshots/users-groups.png)

## 🔑 SSH Configuration

![SSH Configuration](screenshots/ssh.png)

## 🔥 Firewall Configuration

![Firewall Configuration](screenshots/firewall.png)

## 🌍 Apache Web Server

![Apache Web Server](screenshots/apache.png)

## 🌐 Hosted Website

![Hosted Website](screenshots/website.png)

## 🛡️ SELinux

![SELinux](screenshots/selinux.png)

## 📊 Server Monitoring

![Monitoring](screenshots/monitoring.png)

## 🩺 Health Report

![Health Report](screenshots/health-report.png)

---

# 📚 Documentation

Detailed project documentation is available in the `docs/` directory.

| Document             | Description                             |
| -------------------- | --------------------------------------- |
| `architecture.md`    | Complete server architecture            |
| `installation.md`    | Server installation and configuration   |
| `security.md`        | Security configuration and verification |
| `troubleshooting.md` | Common problems and solutions           |
| `server-report.txt`  | Final server configuration report       |

---

# 🧪 Verification Checklist

After completing the configuration, verify:

```text
[✓] RHEL installed
[✓] Hostname configured
[✓] Network configured
[✓] Users created
[✓] Groups configured
[✓] Sudo access configured
[✓] SSH enabled
[✓] Firewall enabled
[✓] HTTP allowed
[✓] Apache installed
[✓] Apache running
[✓] Website accessible
[✓] SELinux enforcing
[✓] Server storage configured
[✓] Monitoring tools configured
[✓] Logs verified
[✓] Backup script tested
[✓] Health-check script tested
[✓] Cron configured
[✓] Security checks completed
[✓] Documentation completed
```

---

# 💡 Key Linux Skills Demonstrated

This project demonstrates practical knowledge of:

### Linux Administration

* Filesystem management
* Users and groups
* Permissions
* Ownership
* Processes
* Services
* Package management
* Storage

### Networking

* IP configuration
* DNS
* Routing
* Network interfaces
* Ports
* SSH
* HTTP

### Security

* sudo
* firewalld
* SELinux
* File permissions
* Access control
* Service security
* Log analysis

### Automation

* Bash scripting
* Backup automation
* Health monitoring
* Cron scheduling
* Automated verification

### DevOps Foundation

* Infrastructure configuration
* Reproducible setup
* Monitoring
* Automation
* Documentation
* Git/GitHub workflow

---

# 🧠 What I Learned

Through this project, I gained practical experience in building and managing a Linux server environment rather than only learning commands individually.

Key learning outcomes:

* Understanding how Linux services operate together
* Managing users according to server roles
* Configuring SSH for remote administration
* Controlling network access with firewalld
* Understanding the role of SELinux
* Deploying and testing Apache
* Monitoring system resources
* Managing Linux logs
* Automating backups with Bash
* Scheduling tasks with Cron
* Creating automated server health reports
* Troubleshooting common server problems
* Documenting infrastructure professionally

---

# 🔄 Project Workflow

```text
RHEL Installation
       │
       ▼
System Configuration
       │
       ▼
Network Configuration
       │
       ▼
Users & Groups
       │
       ▼
Sudo + SSH
       │
       ▼
Firewall
       │
       ▼
Apache Web Server
       │
       ▼
SELinux
       │
       ▼
Storage Configuration
       │
       ▼
Monitoring & Logging
       │
       ▼
Backup Automation
       │
       ▼
Health Monitoring
       │
       ▼
Security Verification
       │
       ▼
Documentation
       │
       ▼
GitHub
```

---

# 🚀 Future Enhancements

Possible future improvements include:

* 🔐 SSH key-based authentication
* 🐳 Docker deployment
* ☸️ Kubernetes integration
* 🌐 Nginx reverse proxy
* 📊 Prometheus monitoring
* 📈 Grafana dashboards
* 🔒 Fail2ban integration
* 🏗️ Ansible automation
* ☁️ AWS EC2 deployment
* ☁️ Azure VM deployment
* ☁️ Google Cloud VM deployment
* 🔄 CI/CD integration
* 🧱 Terraform infrastructure provisioning

These extensions can evolve the project from a **Linux administration lab into a complete DevOps infrastructure project**.

---

# 👨‍💻 Author

**Prajwal K**

🎓 Information Science & Engineering
🐧 Linux & Red Hat Enthusiast
☁️ Aspiring Cloud & DevOps Engineer
🔧 Interested in Linux • Cloud • DevOps • Automation • Cybersecurity

---

# ⭐ Project Highlights

```text
Linux Server Administration
        +
Networking
        +
Security
        +
Apache
        +
Bash Automation
        +
Monitoring
        +
Backup
        +
Documentation
        =
Production-Style Mini Linux Server
```

---

# 📜 License

This project is licensed under the **MIT License**.

See the `LICENSE` file for details.

---

<p align="center">
  <b>Built with Linux • Automated with Bash • Secured with SELinux • Documented with Git</b>
</p>

<p align="center">
  ⭐ If you found this project useful, consider giving the repository a star!
</p>
