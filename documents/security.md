# 🔐 Mini Linux Server — Security Documentation

## 1. Security Overview

Security is a critical component of the **Mini Linux Server Setup** project.

The RHEL server uses multiple security controls to protect system resources, network services, user accounts, application data, and administrative access.

The security architecture follows a **defense-in-depth** approach using:

* User and group management
* File ownership and permissions
* Sudo access control
* SSH
* firewalld
* SELinux
* Service management
* Port management
* System logging
* Backup protection
* Monitoring and health checks

---

# 2. Security Architecture

```text
                    ┌─────────────────────┐
                    │      Client/User    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      firewalld      │
                    │                     │
                    │  SSH  → Port 22    │
                    │  HTTP → Port 80    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │       SELinux       │
                    │                     │
                    │ Mandatory Access    │
                    │ Control             │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    Linux Users      │
                    │    & Permissions    │
                    └──────────┬──────────┘
                               │
                ┌──────────────┼──────────────┐
                ▼              ▼              ▼
             SSHD           HTTPD        Server Data
                │              │              │
                ▼              ▼              ▼
             Admin          Website       Application
                                             │
                                             ▼
                                         Backups
```

---

# 3. Security Principles

The project follows several fundamental Linux security principles.

### Least Privilege

Users should receive only the permissions required for their assigned responsibilities.

### Defense in Depth

Multiple security mechanisms are used rather than relying on a single security control.

### Role Separation

Administrative, development, and backup activities are separated between different users.

### Minimize Attack Surface

Only required network services and ports are exposed.

### Secure Administration

Administrative operations are performed using controlled sudo access rather than routine root usage.

### Monitoring and Logging

System activity and service events are logged for troubleshooting and security investigation.

---

# 4. User Security

The server contains separate accounts for different responsibilities.

| User          | Role          | Purpose               |
| ------------- | ------------- | --------------------- |
| `serveradmin` | Administrator | Server administration |
| `developer`   | Developer     | Application data      |
| `backupuser`  | Backup User   | Backup management     |

Check users:

```bash
getent passwd serveradmin
getent passwd developer
getent passwd backupuser
```

Check user groups:

```bash
id serveradmin
id developer
id backupuser
```

---

# 5. Group-Based Access Control

Groups are used to organize access.

Configured groups:

```text
administrators
developers
backup
wheel
```

Group verification:

```bash
getent group administrators
getent group developers
getent group backup
getent group wheel
```

The administrator account is added to `wheel` for sudo access:

```bash
sudo usermod -aG wheel serveradmin
```

This allows administrative commands to be executed through sudo.

---

# 6. Password Security

Each local user should have a strong password.

Set or change a password:

```bash
sudo passwd serveradmin
```

Check password/account aging information:

```bash
sudo chage -l serveradmin
```

For production environments, password policies should enforce appropriate:

* Minimum password length
* Password complexity
* Password expiration
* Account expiration
* Failed-login controls

Passwords must **never** be stored inside this GitHub repository.

---

# 7. Sudo Security

The `serveradmin` account receives administrative access through the `wheel` group.

Check sudo access:

```bash
sudo -l -U serveradmin
```

Test administrative access:

```bash
sudo whoami
```

Expected result:

```text
root
```

Using sudo provides better accountability than performing normal operations directly as root.

---

# 8. Root Account Security

The root account has unrestricted administrative privileges.

Normal server operations should be performed using a dedicated administrative account with sudo.

Recommended practice:

```text
Normal Work
    │
    ▼
serveradmin
    │
    ▼
sudo
    │
    ▼
Administrative Operation
```

Avoid unnecessary direct root sessions.

Never share the root password.

---

# 9. SSH Security

SSH provides remote server administration.

Check SSH:

```bash
sudo systemctl status sshd
```

Check listening port:

```bash
sudo ss -tlnp | grep :22
```

SSH uses:

```text
TCP Port: 22
Service : sshd
```

---

# 10. SSH Security Recommendations

For a production deployment, SSH should be hardened further.

Recommended controls include:

* Use SSH keys instead of passwords where appropriate.
* Disable direct root login.
* Restrict SSH access to authorized users.
* Use strong authentication.
* Keep OpenSSH updated.
* Monitor failed login attempts.
* Consider changing the default SSH exposure only as part of a broader security configuration.
* Restrict SSH access through firewall rules where appropriate.

Check SSH configuration:

```bash
sudo sshd -T
```

Check the SSH configuration file:

```bash
sudo nano /etc/ssh/sshd_config
```

After modifying SSH configuration, validate it:

```bash
sudo sshd -t
```

Restart or reload SSH only after successful validation:

```bash
sudo systemctl reload sshd
```

---

# 11. Firewall Security

`firewalld` controls network access to the server.

Check firewall status:

```bash
sudo firewall-cmd --state
```

Check active configuration:

```bash
sudo firewall-cmd --list-all
```

The project requires:

```text
SSH  → TCP 22
HTTP → TCP 80
```

Allow SSH:

```bash
sudo firewall-cmd --permanent --add-service=ssh
```

Allow HTTP:

```bash
sudo firewall-cmd --permanent --add-service=http
```

Apply changes:

```bash
sudo firewall-cmd --reload
```

Verify:

```bash
sudo firewall-cmd --list-services
```

---

# 12. Firewall Principle

Only required services should be exposed.

The project follows:

```text
Internet / Network
       │
       ▼
   firewalld
       │
       ├── SSH 22  → ALLOWED
       │
       ├── HTTP 80 → ALLOWED
       │
       └── Other   → NOT REQUIRED
```

Avoid opening unnecessary ports.

Check listening ports:

```bash
sudo ss -tulpn
```

Compare the listening services with the firewall configuration regularly.

---

# 13. SELinux Security

SELinux provides **Mandatory Access Control (MAC)** for the RHEL system.

Check SELinux:

```bash
getenforce
```

Detailed status:

```bash
sestatus
```

The project target configuration is:

```text
Enforcing
```

---

# 14. SELinux and Apache

Apache operates under SELinux security controls.

Check the security context:

```bash
ls -Z /var/www/html
```

SELinux contexts help determine whether a process is permitted to access a particular resource.

If Apache cannot access a file, do not immediately disable SELinux.

Investigate:

```bash
sudo ausearch -m AVC -ts recent
```

Also check:

```bash
sudo journalctl -t setroubleshoot
```

---

# 15. File Permission Security

Linux file permissions protect application and system data.

Check permissions:

```bash
ls -ld /server-data/*
```

Expected ownership:

```text
/server-data/application
developer:developers

/server-data/backups
backupuser:backup

/server-data/logs
root:root
```

Configure application ownership:

```bash
sudo chown -R developer:developers /server-data/application
```

Configure backup ownership:

```bash
sudo chown -R backupuser:backup /server-data/backups
```

Configure log ownership:

```bash
sudo chown root:root /server-data/logs
```

---

# 16. Application Data Security

The application directory is:

```text
/server-data/application
```

The developer account is responsible for application data.

Check:

```bash
ls -ld /server-data/application
```

The developer should not automatically receive administrative privileges.

This separation helps prevent application-level access from becoming unrestricted system access.

---

# 17. Backup Security

Backup files may contain important application information.

Backup location:

```text
/server-data/backups
```

Check backup permissions:

```bash
ls -ld /server-data/backups
```

Check backup files:

```bash
ls -lh /server-data/backups
```

Backup archives should not be publicly accessible through the Apache document root.

The project keeps backups separate from:

```text
/var/www/html
```

This prevents accidental web exposure.

---

# 18. Backup Integrity

The backup script verifies the generated archive.

Example:

```bash
sudo tar -tzf /server-data/backups/application_backup_*.tar.gz
```

A successful archive listing indicates that the compressed archive can be read.

The backup process also maintains a retention policy of the latest five backup files.

---

# 19. Log Security

Logs provide important information for troubleshooting and security monitoring.

System logs:

```text
/var/log/
```

Apache logs:

```text
/var/log/httpd/
```

Project logs:

```text
/server-data/logs/
```

Important files include:

```text
/var/log/httpd/access_log
/var/log/httpd/error_log
/server-data/logs/backup.log
/server-data/logs/health-report.txt
```

Access logs:

```bash
sudo tail /var/log/httpd/access_log
```

Error logs:

```bash
sudo tail /var/log/httpd/error_log
```

---

# 20. SSH Login Monitoring

Failed SSH login attempts can be investigated through the system journal.

Run:

```bash
sudo journalctl -u sshd
```

Search for failed authentication:

```bash
sudo journalctl -u sshd | grep -i failed
```

For a production environment, centralized log monitoring and alerting should be considered.

---

# 21. Service Security

Only required services should be enabled.

Check running services:

```bash
systemctl --type=service --state=running
```

Check individual services:

```bash
sudo systemctl status sshd
sudo systemctl status httpd
sudo systemctl status firewalld
sudo systemctl status crond
```

Unnecessary services should be reviewed and disabled according to the server's actual requirements.

---

# 22. Port Security

Check all listening ports:

```bash
sudo ss -tulpn
```

Project-required network services:

```text
22/tcp → SSH
80/tcp → HTTP
```

Port exposure should be minimized.

A port should be opened only when a legitimate service requires it.

---

# 23. System Update Security

Keeping packages updated is an important security practice.

Check available updates:

```bash
sudo dnf check-update
```

Update packages:

```bash
sudo dnf update -y
```

Check enabled repositories:

```bash
sudo dnf repolist
```

Updates should be tested appropriately before deployment in production environments.

---

# 24. Process Security

Running processes should be monitored regularly.

View processes:

```bash
ps aux
```

Monitor interactively:

```bash
top
```

Or:

```bash
htop
```

Find Apache processes:

```bash
ps aux | grep httpd
```

Unexpected processes should be investigated.

---

# 25. Resource Security

Disk, memory, and CPU exhaustion can affect service availability.

Check disk:

```bash
df -h
```

Check directory usage:

```bash
sudo du -sh /server-data/*
```

Check memory:

```bash
free -h
```

Check CPU/load:

```bash
uptime
```

The health monitoring script provides an automated overview of these resources.

---

# 26. Network Security Checks

Check IP configuration:

```bash
ip addr
```

Check routes:

```bash
ip route
```

Check listening services:

```bash
sudo ss -tulpn
```

Check firewall:

```bash
sudo firewall-cmd --list-all
```

Check network connectivity:

```bash
ping -c 4 8.8.8.8
```

These checks help identify network configuration and exposure issues.

---

# 27. Security Monitoring Through Health Check

The `health-check.sh` script checks several security-related components.

```text
health-check.sh
       │
       ├── SSH Status
       ├── Apache Status
       ├── Firewall Status
       ├── SELinux Status
       ├── Listening Ports
       ├── Network Connectivity
       └── Server Data
```

Run:

```bash
sudo ./scripts/health-check.sh
```

View the report:

```bash
sudo cat /server-data/logs/health-report.txt
```

---

# 28. Security Verification Checklist

Run the following checks regularly:

```bash
# SELinux
getenforce
```

```bash
# Firewall
sudo firewall-cmd --state
sudo firewall-cmd --list-all
```

```bash
# Listening ports
sudo ss -tulpn
```

```bash
# SSH
sudo systemctl status sshd
```

```bash
# Apache
sudo systemctl status httpd
```

```bash
# Users
id serveradmin
id developer
id backupuser
```

```bash
# File permissions
ls -ld /server-data/*
```

```bash
# Disk
df -h
```

```bash
# Logs
sudo journalctl --since today
```

---

# 29. Security Incident Investigation Flow

If suspicious activity or unexpected behavior is detected:

```text
              Security Issue
                    │
                    ▼
             Identify Service
                    │
                    ▼
             Check Processes
                    │
                    ▼
             Check Open Ports
                    │
                    ▼
             Check Firewall
                    │
                    ▼
             Check SELinux
                    │
                    ▼
             Check System Logs
                    │
                    ▼
             Check SSH Logs
                    │
                    ▼
          Review File Permissions
                    │
                    ▼
            Take Corrective Action
                    │
                    ▼
             Verify Server State
```

Useful commands:

```bash
ps aux
sudo ss -tulpn
sudo firewall-cmd --list-all
getenforce
sudo journalctl
sudo journalctl -u sshd
sudo journalctl -u httpd
```

---

# 30. Security Best Practices

The following practices should be followed when extending this project toward production:

* Use strong passwords.
* Prefer SSH keys for administrative access.
* Avoid direct root login.
* Keep SELinux enabled.
* Keep firewalld enabled.
* Expose only required ports.
* Keep RHEL packages updated.
* Use least-privilege permissions.
* Separate application and backup data.
* Protect backup files.
* Monitor authentication logs.
* Monitor system resources.
* Review running services regularly.
* Keep backups separate from the web root.
* Never commit passwords, private keys, tokens, or secrets to GitHub.
* Use `.gitignore` to prevent accidental secret uploads.
* Test configuration changes before applying them to production systems.

---

# 31. Sensitive Information Policy

The GitHub repository must **not** contain:

```text
Passwords
Private SSH Keys
API Keys
Access Tokens
Database Passwords
Cloud Credentials
Personal Authentication Data
```

Before pushing the project:

```bash
git status
```

Review files carefully:

```bash
git diff
```

Do not commit sensitive configuration files.

---

# 32. Security Files and Locations

| Security Component   | Location / Command         |
| -------------------- | -------------------------- |
| SSH Configuration    | `/etc/ssh/sshd_config`     |
| Firewall             | `firewall-cmd`             |
| SELinux              | `getenforce`, `sestatus`   |
| Apache Configuration | `/etc/httpd/`              |
| Apache Logs          | `/var/log/httpd/`          |
| System Logs          | `/var/log/`, `journalctl`  |
| Application Data     | `/server-data/application` |
| Backups              | `/server-data/backups`     |
| Project Logs         | `/server-data/logs`        |
| Health Script        | `scripts/health-check.sh`  |
| Backup Script        | `scripts/backup.sh`        |

---

# 33. Security Architecture Summary

The Mini Linux Server uses multiple layers of protection:

```text
┌─────────────────────────────────────────┐
│              USER SECURITY              │
│        Users + Groups + Sudo            │
├─────────────────────────────────────────┤
│             FILE SECURITY               │
│       Ownership + Permissions           │
├─────────────────────────────────────────┤
│             SSH SECURITY                │
│       Controlled Remote Access           │
├─────────────────────────────────────────┤
│            NETWORK SECURITY             │
│              firewalld                  │
├─────────────────────────────────────────┤
│            ACCESS CONTROL               │
│               SELinux                   │
├─────────────────────────────────────────┤
│          SERVICE SECURITY               │
│       SSH + Apache + Cron               │
├─────────────────────────────────────────┤
│          MONITORING & LOGGING           │
│       Journal + Apache + Health         │
├─────────────────────────────────────────┤
│             BACKUP SECURITY             │
│       Protected Backup Storage          │
└─────────────────────────────────────────┘
```

---

# 34. Final Security State

The intended security configuration for the project is:

```text
==========================================================
                 MINI RHEL SERVER SECURITY
==========================================================

User Management       : CONFIGURED
Group Management      : CONFIGURED
Sudo Access            : CONFIGURED
SSH                    : ENABLED
Firewall               : ENABLED
Allowed SSH Port       : 22/tcp
Allowed HTTP Port      : 80/tcp
SELinux                : ENFORCING
File Permissions       : CONFIGURED
Application Isolation  : CONFIGURED
Backup Protection     : CONFIGURED
Logging                : ENABLED
Monitoring             : CONFIGURED
Health Checks          : CONFIGURED
Secrets in Repository  : NONE
==========================================================
```

## Security Objective

The objective of this security configuration is to create a Linux server environment where access is controlled, network exposure is minimized, system resources are protected, security events can be investigated, and routine administrative tasks can be monitored and automated.

This project provides a practical foundation for applying Linux security concepts in **system administration, Cloud, DevOps, and infrastructure environments**.
