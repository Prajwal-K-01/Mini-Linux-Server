# 🏗️ Mini Linux Server — System Architecture

## 1. Project Overview

The **Mini Linux Server Setup** project demonstrates how to configure and manage a production-style Linux server using **Red Hat Enterprise Linux (RHEL)**.

The project integrates system administration, networking, security, web hosting, storage management, monitoring, logging, and automated backup into a single server environment.

The server is deployed inside a **VMware Workstation virtual machine** and is designed to simulate the core responsibilities of a real Linux server administrator.

---

## 2. Architecture Diagram

```text
                         ┌─────────────────────────┐
                         │       Administrator     │
                         │     / Developer User    │
                         └────────────┬────────────┘
                                      │
                                      │ SSH / HTTP
                                      ▼
                    ┌──────────────────────────────────┐
                    │          RHEL MINI SERVER        │
                    │                                  │
                    │        Hostname: mini-server     │
                    │                                  │
                    │  ┌────────────────────────────┐  │
                    │  │      Security Layer        │  │
                    │  │                            │  │
                    │  │  SELinux + firewalld      │  │
                    │  └─────────────┬──────────────┘  │
                    │                │                 │
                    │  ┌─────────────▼──────────────┐  │
                    │  │      Service Layer         │  │
                    │  │                            │  │
                    │  │   SSH (22)                 │  │
                    │  │   Apache HTTP (80)         │  │
                    │  │   Cron / Crond             │  │
                    │  └─────────────┬──────────────┘  │
                    │                │                 │
                    │  ┌─────────────▼──────────────┐  │
                    │  │       Data Layer            │  │
                    │  │                            │  │
                    │  │ /server-data/application   │  │
                    │  │ /server-data/backups       │  │
                    │  │ /server-data/logs          │  │
                    │  └─────────────┬──────────────┘  │
                    │                │                 │
                    │  ┌─────────────▼──────────────┐  │
                    │  │     Monitoring Layer        │  │
                    │  │                            │  │
                    │  │ CPU / RAM / Disk / Network │  │
                    │  │ Services / Ports / Logs    │  │
                    │  └────────────────────────────┘  │
                    └────────────────┬─────────────────┘
                                     │
                                     ▼
                           ┌──────────────────┐
                           │   Backup System  │
                           │                  │
                           │ backup.sh        │
                           │ .tar.gz Backups  │
                           └──────────────────┘
```

---

## 3. Architecture Layers

The project follows a layered architecture consisting of the following major components:

### 3.1 Infrastructure Layer

The infrastructure layer provides the virtual machine environment where the RHEL server operates.

**Components:**

* VMware Workstation
* RHEL Virtual Machine
* Virtual CPU
* Virtual RAM
* Virtual Disk
* Virtual Network Adapter

The virtual machine acts as the server infrastructure for the entire project.

---

### 3.2 Operating System Layer

The operating system layer is provided by **Red Hat Enterprise Linux**.

It manages:

* CPU
* Memory
* Storage
* Processes
* Users
* Groups
* Filesystems
* Network interfaces
* System services
* System logs

Important commands include:

```bash
uname -r
hostnamectl
free -h
df -h
ps aux
systemctl
```

---

## 4. Network Architecture

The server uses the RHEL networking stack to communicate with clients and provide network services.

```text
Client
   │
   │
   ▼
Virtual Network
   │
   ▼
RHEL Network Interface
   │
   ├── IP Address
   ├── Subnet
   ├── Default Gateway
   └── DNS
   │
   ▼
RHEL Server
```

Network configuration is managed using **NetworkManager**.

Useful commands:

```bash
nmcli device status
nmcli connection show
ip addr
ip route
hostname -I
```

Connectivity can be tested using:

```bash
ping -c 4 8.8.8.8
ping -c 4 google.com
```

---

## 5. User and Group Architecture

The server uses role-based user and group management.

### Users

| User          | Role                  | Group                     |
| ------------- | --------------------- | ------------------------- |
| `serveradmin` | Server Administrator  | `administrators`, `wheel` |
| `developer`   | Application Developer | `developers`              |
| `backupuser`  | Backup Administrator  | `backup`                  |

### Groups

```text
administrators
       │
       └── serveradmin

developers
       │
       └── developer

backup
       │
       └── backupuser

wheel
       │
       └── serveradmin
```

This structure separates administrative, application, and backup responsibilities.

---

## 6. Remote Access Architecture

SSH provides secure remote administration.

```text
SSH Client
    │
    │ TCP 22
    ▼
firewalld
    │
    ▼
sshd
    │
    ▼
serveradmin
```

SSH service:

```bash
systemctl status sshd
```

Listening port:

```bash
ss -tlnp | grep :22
```

Remote connection:

```bash
ssh serveradmin@SERVER_IP
```

---

## 7. Web Server Architecture

Apache HTTP Server provides the web hosting functionality.

```text
Web Browser
     │
     │ HTTP
     │ TCP 80
     ▼
 firewalld
     │
     ▼
   httpd
     │
     ▼
/var/www/html
     │
     ▼
index.html
```

Apache service:

```bash
systemctl status httpd
```

Website directory:

```text
/var/www/html
```

Main webpage:

```text
/var/www/html/index.html
```

Local testing:

```bash
curl http://localhost
```

---

## 8. Security Architecture

Security is implemented using multiple layers.

```text
                ┌──────────────────┐
                │     Client       │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │    firewalld     │
                │                  │
                │ SSH : 22         │
                │ HTTP: 80         │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │      SELinux     │
                │                  │
                │ Access Control   │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │ RHEL Services    │
                └──────────────────┘
```

### Security Components

* `firewalld`
* SELinux
* SSH
* User/group permissions
* sudo
* File ownership
* Service management
* System logging

SELinux status:

```bash
getenforce
```

Expected configuration:

```text
Enforcing
```

Firewall status:

```bash
firewall-cmd --state
```

---

## 9. Storage Architecture

Application data, backups, and logs are separated into dedicated directories.

```text
/server-data
│
├── application/
│   └── Application Data
│
├── backups/
│   └── Compressed Backups
│
└── logs/
    ├── backup.log
    └── health-report.txt
```

### Directory Ownership

```text
/server-data/application
Owner: developer
Group: developers

/server-data/backups
Owner: backupuser
Group: backup

/server-data/logs
Owner: root
Group: root
```

This separation provides better access control and organization.

---

## 10. Monitoring Architecture

The monitoring layer checks the operational status of the server.

```text
              RHEL Server
                   │
       ┌───────────┼───────────┐
       │           │           │
       ▼           ▼           ▼
      CPU         RAM         Disk
       │           │           │
       └───────────┼───────────┘
                   │
                   ▼
              Monitoring
                   │
       ┌───────────┼───────────┐
       │           │           │
       ▼           ▼           ▼
    Network     Services      Ports
       │           │           │
       └───────────┼───────────┘
                   │
                   ▼
             Health Report
```

Monitoring commands:

```bash
top
htop
free -h
df -h
du -sh /server-data
ps aux
ss -tulpn
```

---

## 11. Health Monitoring Architecture

The `health-check.sh` script performs automated server health checks.

```text
health-check.sh
       │
       ├── System Information
       ├── CPU
       ├── Memory
       ├── Disk
       ├── Network
       ├── SSH
       ├── Apache
       ├── Firewall
       ├── SELinux
       ├── Listening Ports
       └── Server Data
               │
               ▼
       health-report.txt
```

Health report location:

```text
/server-data/logs/health-report.txt
```

The script generates a final status:

```text
HEALTHY
```

or:

```text
CHECK REQUIRED
```

---

## 12. Backup Architecture

The project implements automated application-data backup using `backup.sh`.

```text
/server-data/application
           │
           │ tar + gzip
           ▼
    backup.sh
           │
           ▼
/server-data/backups
           │
           ├── application_backup_DATE.tar.gz
           ├── application_backup_DATE.tar.gz
           └── ...
           │
           ▼
     Retention Policy
      Keep 5 backups
```

Backup process:

1. Validate source directory.
2. Create compressed archive.
3. Verify archive integrity.
4. Record backup information.
5. Remove older backups.
6. Keep the latest five backups.

Backup format:

```text
.tar.gz
```

Verification:

```bash
tar -tzf /server-data/backups/application_backup_*.tar.gz
```

---

## 13. Automation Architecture

Cron is used to automate recurring administrative tasks.

```text
             Cron / Crond
                  │
                  ▼
           Scheduled Job
                  │
          ┌───────┴───────┐
          ▼               ▼
      backup.sh      health-check.sh
          │               │
          ▼               ▼
       Backups        Health Report
```

Cron service:

```bash
systemctl status crond
```

Configured jobs can be viewed using:

```bash
crontab -l
```

---

## 14. Logging Architecture

The project uses both RHEL system logging and application-specific logs.

### System Logs

```text
/var/log/
```

### Apache Logs

```text
/var/log/httpd/access_log
/var/log/httpd/error_log
```

### Project Logs

```text
/server-data/logs/backup.log
/server-data/logs/health-report.txt
```

### Journal Logs

```bash
journalctl
journalctl -u sshd
journalctl -u httpd
```

Logging helps with troubleshooting, auditing, and monitoring.

---

## 15. Service Architecture

The primary services used in the project are:

| Service     | Purpose               | Port |
| ----------- | --------------------- | ---: |
| `sshd`      | Remote administration |   22 |
| `httpd`     | Web server            |   80 |
| `firewalld` | Network firewall      |    — |
| `crond`     | Task automation       |    — |

Service status can be checked using:

```bash
systemctl status sshd
systemctl status httpd
systemctl status firewalld
systemctl status crond
```

---

## 16. Complete Data Flow

The complete operational flow of the server is:

```text
                    USER / CLIENT
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
          SSH : 22               HTTP : 80
             │                       │
             └───────────┬───────────┘
                         ▼
                    firewalld
                         │
                         ▼
                      SELinux
                         │
                         ▼
                    RHEL Server
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
       sshd            httpd         System
                                      Services
          │              │              │
          ▼              ▼              ▼
     Admin User      Web Content    Monitoring
                                        │
                         ┌──────────────┼──────────────┐
                         │                             │
                         ▼                             ▼
                  health-check.sh                 backup.sh
                         │                             │
                         ▼                             ▼
                health-report.txt             .tar.gz Backup
```

---

## 17. Architecture Design Principles

The project follows these Linux administration principles:

### Separation of Responsibilities

Different users are assigned different roles.

### Least Privilege

Users receive only the access required for their responsibilities.

### Defense in Depth

Multiple security mechanisms are used instead of relying on a single control.

### Automation

Routine operations such as backup and health monitoring are automated.

### Monitoring

System resources, services, ports, and connectivity are continuously checkable.

### Logging

Important system and application activities are recorded for troubleshooting.

### Maintainability

Configuration, scripts, documentation, reports, and screenshots are separated into dedicated project directories.

---

## 18. Project Directory Architecture

The GitHub repository follows this structure:

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

## 19. Technologies Used

| Technology               | Purpose                  |
| ------------------------ | ------------------------ |
| Red Hat Enterprise Linux | Server operating system  |
| VMware Workstation       | Virtualization           |
| NetworkManager           | Network configuration    |
| OpenSSH                  | Remote administration    |
| Apache HTTP Server       | Web hosting              |
| firewalld                | Firewall management      |
| SELinux                  | Mandatory access control |
| systemd                  | Service management       |
| Cron                     | Task automation          |
| Bash                     | Automation scripting     |
| tar/gzip                 | Backup compression       |
| Git                      | Version control          |
| GitHub                   | Project repository       |

---

## 20. Final Architecture Summary

The Mini Linux Server project combines fundamental Linux administration concepts into a single working server environment.

The architecture provides:

* Virtualized RHEL infrastructure
* Network configuration
* Role-based users and groups
* SSH remote administration
* Apache web hosting
* Firewall protection
* SELinux security
* Organized server storage
* System monitoring
* Centralized logging
* Automated backups
* Health monitoring
* Cron-based automation
* Git/GitHub project management

The project therefore represents a practical foundation for understanding how Linux servers are configured, secured, monitored, maintained, and automated in real-world infrastructure environments.
