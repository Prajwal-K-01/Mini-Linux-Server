# 🛠️ Mini Linux Server — Troubleshooting Guide

## 1. Overview

This document provides troubleshooting procedures for common issues encountered while configuring and operating the **Mini Linux Server Setup** project on Red Hat Enterprise Linux (RHEL).

The guide covers:

* System issues
* Network problems
* SSH connectivity
* Firewall configuration
* Apache web server
* SELinux
* Users and permissions
* Storage
* Services
* Logs
* Backup
* Health monitoring
* Cron automation
* Git and project files

The general troubleshooting approach is:

```text
Problem
   │
   ▼
Identify Component
   │
   ▼
Check Status
   │
   ▼
Check Logs
   │
   ▼
Identify Root Cause
   │
   ▼
Apply Fix
   │
   ▼
Verify
```

---

# 2. General Troubleshooting Method

When a problem occurs, avoid immediately changing multiple configurations.

Follow these steps:

### Step 1 — Identify the problem

Determine exactly what is not working.

Example:

```text
Apache website is not opening.
```

### Step 2 — Check service status

```bash
systemctl status SERVICE_NAME
```

### Step 3 — Check logs

```bash
journalctl -u SERVICE_NAME
```

### Step 4 — Check configuration

Verify the relevant configuration files and commands.

### Step 5 — Apply the smallest required fix

Avoid unnecessary changes.

### Step 6 — Restart/reload only when required

```bash
sudo systemctl restart SERVICE_NAME
```

### Step 7 — Verify

Test the service again.

---

# 3. Basic System Information

When investigating any problem, collect basic system information first.

```bash
hostnamectl
```

```bash
cat /etc/redhat-release
```

```bash
uname -r
```

```bash
uptime
```

```bash
free -h
```

```bash
df -h
```

```bash
ip addr
```

These commands provide the basic state of the server.

---

# 4. Hostname Problems

## Problem

The hostname is incorrect or has not changed.

Check:

```bash
hostname
```

```bash
hostnamectl
```

## Solution

Set the hostname:

```bash
sudo hostnamectl set-hostname mini-server
```

Verify:

```bash
hostnamectl
```

Expected:

```text
Static hostname: mini-server
```

---

# 5. Network Interface Not Available

## Problem

The network interface is not connected.

Check:

```bash
nmcli device status
```

Example:

```text
DEVICE    TYPE      STATE
ens160    ethernet  disconnected
```

## Solution

Check available connections:

```bash
nmcli connection show
```

Bring the connection up:

```bash
sudo nmcli connection up "CONNECTION_NAME"
```

Replace `CONNECTION_NAME` with the actual connection name.

Check again:

```bash
nmcli device status
```

---

# 6. No IP Address

## Problem

The server does not have an IP address.

Check:

```bash
ip addr
```

Also:

```bash
hostname -I
```

## Solution

Check NetworkManager:

```bash
sudo systemctl status NetworkManager
```

Restart if necessary:

```bash
sudo systemctl restart NetworkManager
```

Check:

```bash
nmcli device status
```

Then:

```bash
ip addr
```

---

# 7. No Internet Connectivity

## Problem

The server cannot access the Internet.

Test IP connectivity:

```bash
ping -c 4 8.8.8.8
```

If this works, test DNS:

```bash
ping -c 4 google.com
```

Check routing:

```bash
ip route
```

Check DNS:

```bash
cat /etc/resolv.conf
```

## Diagnosis

```text
8.8.8.8 works
google.com fails
        │
        ▼
Possible DNS problem
```

If both fail:

```text
8.8.8.8 fails
google.com fails
        │
        ▼
Check network interface
Check default route
Check VMware network mode
```

---

# 8. VMware Network Problems

If the RHEL VM has no network connectivity:

### Check VMware adapter

Verify that the virtual network adapter is connected.

Common VMware network modes:

```text
NAT
Bridged
Host-only
```

For Internet access, NAT or Bridged networking is normally used.

Inside RHEL:

```bash
nmcli device status
```

Then:

```bash
ip addr
```

Then:

```bash
ip route
```

Restart NetworkManager if necessary:

```bash
sudo systemctl restart NetworkManager
```

---

# 9. SSH Service Not Running

## Problem

SSH connection fails.

Check:

```bash
sudo systemctl status sshd
```

## Solution

Start SSH:

```bash
sudo systemctl start sshd
```

Enable at boot:

```bash
sudo systemctl enable sshd
```

Or:

```bash
sudo systemctl enable --now sshd
```

Verify:

```bash
sudo systemctl is-active sshd
```

---

# 10. SSH Port Not Listening

Check:

```bash
sudo ss -tlnp | grep :22
```

If nothing is returned, SSH may not be listening.

Check:

```bash
sudo systemctl status sshd
```

Validate SSH configuration:

```bash
sudo sshd -t
```

If the configuration is valid:

```bash
sudo systemctl restart sshd
```

Check again:

```bash
sudo ss -tlnp | grep :22
```

---

# 11. SSH Connection Refused

## Problem

Example:

```text
ssh: connect to host SERVER_IP port 22: Connection refused
```

Check:

```bash
sudo systemctl status sshd
```

Check port:

```bash
sudo ss -tlnp | grep :22
```

Check firewall:

```bash
sudo firewall-cmd --list-services
```

If SSH is missing:

```bash
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

Test again:

```bash
ssh serveradmin@SERVER_IP
```

---

# 12. SSH Connection Times Out

## Problem

The SSH command hangs or times out.

Possible causes:

* Incorrect IP address
* Network connectivity problem
* Firewall blocking port 22
* VMware network configuration
* SSH service not running

Check server IP:

```bash
hostname -I
```

Check connectivity from the client:

```bash
ping SERVER_IP
```

Check firewall:

```bash
sudo firewall-cmd --list-all
```

Check SSH:

```bash
sudo systemctl status sshd
```

---

# 13. SSH Authentication Failure

## Problem

The password is rejected.

Check that the user exists:

```bash
id serveradmin
```

Check account information:

```bash
sudo chage -l serveradmin
```

Reset password if required:

```bash
sudo passwd serveradmin
```

Check SSH logs:

```bash
sudo journalctl -u sshd
```

Search for authentication failures:

```bash
sudo journalctl -u sshd | grep -i failed
```

---

# 14. Apache Is Not Running

## Problem

The website does not load.

Check Apache:

```bash
sudo systemctl status httpd
```

Start Apache:

```bash
sudo systemctl start httpd
```

Enable it:

```bash
sudo systemctl enable httpd
```

Or:

```bash
sudo systemctl enable --now httpd
```

---

# 15. Apache Configuration Error

Before restarting Apache, test its configuration:

```bash
sudo apachectl configtest
```

Expected:

```text
Syntax OK
```

If there is an error, inspect the configuration files under:

```text
/etc/httpd/
```

Then test again:

```bash
sudo apachectl configtest
```

Only restart Apache after the configuration is valid:

```bash
sudo systemctl restart httpd
```

---

# 16. Website Not Loading

First test Apache locally:

```bash
curl http://localhost
```

If this works:

```text
curl localhost → works
Browser        → fails
```

Check:

* Server IP
* Firewall
* VMware networking
* Client connectivity

Check firewall:

```bash
sudo firewall-cmd --list-all
```

Ensure HTTP is allowed:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

---

# 17. Apache Returns Connection Refused

Check:

```bash
sudo ss -tlnp | grep :80
```

If no result:

```bash
sudo systemctl status httpd
```

Start Apache:

```bash
sudo systemctl start httpd
```

Then verify:

```bash
sudo ss -tlnp | grep :80
```

---

# 18. Apache Returns 403 Forbidden

A `403 Forbidden` response can result from:

* File permissions
* Directory permissions
* SELinux
* Apache configuration

Check:

```bash
ls -ld /var/www/html
```

Check files:

```bash
ls -l /var/www/html
```

Check SELinux contexts:

```bash
ls -Z /var/www/html
```

Check Apache logs:

```bash
sudo tail /var/log/httpd/error_log
```

Check SELinux events:

```bash
sudo ausearch -m AVC -ts recent
```

Do not disable SELinux as the first troubleshooting step.

---

# 19. Apache Returns 404 Not Found

Check whether the webpage exists:

```bash
ls -l /var/www/html/index.html
```

If missing:

```bash
sudo nano /var/www/html/index.html
```

Check Apache document root configuration if required:

```bash
grep -R "DocumentRoot" /etc/httpd/
```

Test locally:

```bash
curl -I http://localhost
```

---

# 20. Apache Website Shows Incorrect Page

Check the webpage:

```bash
sudo cat /var/www/html/index.html
```

Check the document root:

```bash
grep -R "DocumentRoot" /etc/httpd/
```

Clear browser cache or use a private browser window.

Test directly:

```bash
curl http://localhost
```

---

# 21. Firewall Blocking HTTP

Check firewall:

```bash
sudo firewall-cmd --list-all
```

If `http` is missing:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

Verify:

```bash
sudo firewall-cmd --list-services
```

Expected:

```text
ssh http
```

---

# 22. SELinux Problems

## Problem

A service works when SELinux is permissive but fails when enforcing.

First check:

```bash
getenforce
```

Then:

```bash
sestatus
```

Check recent SELinux denials:

```bash
sudo ausearch -m AVC -ts recent
```

Check security contexts:

```bash
ls -Z /var/www/html
```

Check logs:

```bash
sudo journalctl
```

The correct approach is to identify the denied operation and correct the security context or policy-related configuration.

Avoid using:

```bash
setenforce 0
```

as a permanent solution.

---

# 23. User Cannot Access Application Directory

## Problem

`developer` cannot access:

```text
/server-data/application
```

Check ownership:

```bash
ls -ld /server-data/application
```

Expected owner/group:

```text
developer developers
```

Fix ownership:

```bash
sudo chown -R developer:developers /server-data/application
```

Check permissions:

```bash
ls -ld /server-data/application
```

Test as developer:

```bash
sudo -u developer ls -la /server-data/application
```

---

# 24. Backup User Cannot Access Backup Directory

Check:

```bash
ls -ld /server-data/backups
```

Fix ownership:

```bash
sudo chown -R backupuser:backup /server-data/backups
```

Verify:

```bash
id backupuser
```

Test:

```bash
sudo -u backupuser ls -la /server-data/backups
```

---

# 25. Permission Denied

## Problem

Example:

```text
Permission denied
```

Check:

```bash
ls -l FILE
```

Check directory permissions:

```bash
ls -ld DIRECTORY
```

Check user:

```bash
whoami
```

Check groups:

```bash
id
```

For ownership problems:

```bash
sudo chown USER:GROUP FILE
```

For permission problems:

```bash
sudo chmod MODE FILE
```

Avoid using:

```bash
chmod -R 777
```

as a general solution. It grants excessive permissions and can create security problems.

---

# 26. User Does Not Have Sudo Access

Check group membership:

```bash
id serveradmin
```

The administrator should be a member of:

```text
wheel
```

Add:

```bash
sudo usermod -aG wheel serveradmin
```

Log out and log back in so the new group membership is applied.

Verify:

```bash
id serveradmin
```

Test:

```bash
sudo whoami
```

Expected:

```text
root
```

---

# 27. User Cannot Log In

Check whether the user exists:

```bash
id USERNAME
```

Check account information:

```bash
sudo chage -l USERNAME
```

Check the user's shell:

```bash
getent passwd USERNAME
```

Check authentication logs:

```bash
sudo journalctl -u sshd
```

Reset password if appropriate:

```bash
sudo passwd USERNAME
```

---

# 28. Disk Space Is Full

Check filesystem usage:

```bash
df -h
```

Find large directories:

```bash
sudo du -xh / | sort -h | tail
```

Check project data:

```bash
sudo du -sh /server-data/*
```

Check logs:

```bash
sudo du -sh /var/log/*
```

Large files should be identified before deleting anything.

Do not delete system files blindly.

---

# 29. Inode Exhaustion

Sometimes disk space appears available but files cannot be created.

Check inode usage:

```bash
df -i
```

If inode usage is high, identify directories containing large numbers of small files.

For example:

```bash
sudo find /server-data -xdev -type f | wc -l
```

Investigate unnecessary files before removing them.

---

# 30. Backup Script Fails

Run the script manually:

```bash
sudo ./scripts/backup.sh
```

Check whether the source exists:

```bash
ls -ld /server-data/application
```

Check backup directory:

```bash
ls -ld /server-data/backups
```

Check logs:

```bash
sudo cat /server-data/logs/backup.log
```

Check disk space:

```bash
df -h
```

Check whether `tar` is available:

```bash
command -v tar
```

---

# 31. Backup Archive Cannot Be Verified

Check generated backup:

```bash
ls -lh /server-data/backups/
```

Test archive:

```bash
sudo tar -tzf /server-data/backups/application_backup_*.tar.gz
```

If verification fails, check:

```bash
df -h
```

and:

```bash
sudo cat /server-data/logs/backup.log
```

Create a fresh backup after identifying the cause.

---

# 32. Backup Directory Contains Too Many Files

The backup script is configured to retain the latest five backups.

Check:

```bash
ls -lh /server-data/backups/
```

Count backups:

```bash
find /server-data/backups -type f -name "application_backup_*.tar.gz" | wc -l
```

If the retention script is not working, run the backup manually:

```bash
sudo ./scripts/backup.sh
```

Then check again.

---

# 33. Health Check Script Fails

Run:

```bash
sudo ./scripts/health-check.sh
```

Check whether it is executable:

```bash
ls -l scripts/health-check.sh
```

If necessary:

```bash
chmod +x scripts/health-check.sh
```

Check the script syntax:

```bash
bash -n scripts/health-check.sh
```

If no output is returned, the shell syntax is valid.

---

# 34. Health Report Is Not Created

Check the report directory:

```bash
sudo ls -ld /server-data/logs
```

Create it if necessary:

```bash
sudo mkdir -p /server-data/logs
```

Run:

```bash
sudo ./scripts/health-check.sh
```

Check:

```bash
sudo ls -lh /server-data/logs/
```

Expected:

```text
health-report.txt
```

---

# 35. Health Check Shows "CHECK REQUIRED"

Run:

```bash
sudo ./scripts/health-check.sh
```

Look for:

```text
[FAIL]
```

or:

```text
[WARNING]
```

Check each component individually:

```bash
systemctl status sshd
systemctl status httpd
systemctl status firewalld
getenforce
```

Check network:

```bash
ping -c 2 8.8.8.8
```

Check ports:

```bash
sudo ss -tulpn
```

After correcting the issue, run the health check again.

---

# 36. Cron Job Is Not Running

Check cron service:

```bash
sudo systemctl status crond
```

Enable it:

```bash
sudo systemctl enable --now crond
```

Check scheduled jobs:

```bash
crontab -l
```

Check cron logs:

```bash
sudo journalctl -u crond
```

Make sure the script has execute permission:

```bash
ls -l scripts/backup.sh
```

---

# 37. Cron Path Problem

Cron runs with a different environment from an interactive shell.

Use absolute paths in cron entries.

Example:

```text
0 23 * * * /home/YOUR_USERNAME/mini-linux-server/scripts/backup.sh
```

Avoid relying on relative paths such as:

```text
scripts/backup.sh
```

Use:

```bash
bash -n scripts/backup.sh
```

to verify script syntax.

---

# 38. Service Is Not Starting

Check service:

```bash
sudo systemctl status SERVICE_NAME
```

Check logs:

```bash
sudo journalctl -u SERVICE_NAME
```

Check recent logs:

```bash
sudo journalctl -u SERVICE_NAME --since "30 minutes ago"
```

Check configuration if the service has a configuration test command.

Example for Apache:

```bash
sudo apachectl configtest
```

---

# 39. Systemd Service Failed

Check failed services:

```bash
systemctl --failed
```

Inspect a specific service:

```bash
sudo systemctl status SERVICE_NAME
```

View logs:

```bash
sudo journalctl -u SERVICE_NAME -b
```

The `-b` option shows logs from the current boot.

---

# 40. Package Installation Fails

Check repository configuration:

```bash
sudo dnf repolist
```

Check Internet connectivity:

```bash
ping -c 4 8.8.8.8
```

Try refreshing metadata:

```bash
sudo dnf clean all
sudo dnf makecache
```

Then retry the installation:

```bash
sudo dnf install PACKAGE_NAME
```

---

# 41. Git Repository Problems

Check Git installation:

```bash
git --version
```

Check repository status:

```bash
git status
```

Check configured remote:

```bash
git remote -v
```

Check current branch:

```bash
git branch
```

---

# 42. Files Not Appearing in Git

Check:

```bash
git status
```

If a file is ignored:

```bash
git check-ignore -v FILE
```

Review `.gitignore`:

```bash
cat .gitignore
```

Add the required file:

```bash
git add FILE
```

Then:

```bash
git status
```

---

# 43. Accidentally Added Sensitive Data to Git

If a password, private key, token, or other secret is accidentally added:

1. Do not push it to GitHub.
2. Remove it from the repository.
3. Rotate/revoke the exposed secret.
4. Check Git history if it was already committed.
5. Rewrite history when necessary.
6. Add the secret pattern to `.gitignore`.

Never assume that deleting a secret from the latest working tree removes it from Git history.

---

# 44. Apache Logs for Troubleshooting

Access log:

```bash
sudo tail -f /var/log/httpd/access_log
```

Error log:

```bash
sudo tail -f /var/log/httpd/error_log
```

View recent errors:

```bash
sudo tail -n 50 /var/log/httpd/error_log
```

These logs are especially useful for:

* 403 errors
* 404 errors
* Configuration problems
* Permission problems
* Application requests

---

# 45. System Journal Troubleshooting

View all recent logs:

```bash
sudo journalctl
```

View today's logs:

```bash
sudo journalctl --since today
```

View SSH logs:

```bash
sudo journalctl -u sshd
```

View Apache logs:

```bash
sudo journalctl -u httpd
```

View firewall logs if available through the system journal:

```bash
sudo journalctl -u firewalld
```

View logs from the current boot:

```bash
sudo journalctl -b
```

---

# 46. Network Port Troubleshooting

Check all listening sockets:

```bash
sudo ss -tulpn
```

Check SSH:

```bash
sudo ss -tlnp | grep :22
```

Check HTTP:

```bash
sudo ss -tlnp | grep :80
```

Test HTTP locally:

```bash
curl -I http://localhost
```

This helps determine whether the issue is with the application, service, firewall, or network.

---

# 47. Quick Diagnostic Commands

Use these commands for a rapid server check:

```bash
hostnamectl
```

```bash
ip addr
```

```bash
ip route
```

```bash
free -h
```

```bash
df -h
```

```bash
systemctl --failed
```

```bash
sudo ss -tulpn
```

```bash
sudo firewall-cmd --list-all
```

```bash
getenforce
```

```bash
sudo journalctl --since today
```

---

# 48. Troubleshooting Decision Tree

```text
                  SERVER PROBLEM
                        │
                        ▼
                Is the server running?
                   /           \
                 YES            NO
                  │              │
                  ▼              ▼
            Check service     Check VM/System
                  │
                  ▼
          Is service active?
             /          \
           YES           NO
            │             │
            ▼             ▼
       Check network    systemctl status
            │             │
            ▼             ▼
       Check firewall   Check journalctl
            │             │
            ▼             ▼
       Check SELinux    Fix configuration
            │             │
            └──────┬──────┘
                   ▼
                 TEST
                   │
                   ▼
               VERIFIED
```

---

# 49. Troubleshooting Checklist

Use this checklist when diagnosing a problem:

```text
[ ] Identify the exact problem
[ ] Check hostname
[ ] Check network interface
[ ] Check IP address
[ ] Check routing
[ ] Check service status
[ ] Check listening ports
[ ] Check firewall
[ ] Check SELinux
[ ] Check file permissions
[ ] Check system logs
[ ] Check service logs
[ ] Check disk space
[ ] Check memory
[ ] Check process status
[ ] Apply corrective action
[ ] Restart/reload if required
[ ] Test the service
[ ] Run health-check.sh
[ ] Document the resolution
```

---

# 50. Common Problems Summary

| Problem              | First Command              | Main Area           |
| -------------------- | -------------------------- | ------------------- |
| No IP address        | `ip addr`                  | Network             |
| No Internet          | `ping -c 4 8.8.8.8`        | Network             |
| SSH unavailable      | `systemctl status sshd`    | SSH                 |
| SSH timeout          | `firewall-cmd --list-all`  | Firewall            |
| Website unavailable  | `systemctl status httpd`   | Apache              |
| HTTP blocked         | `firewall-cmd --list-all`  | Firewall            |
| Apache 403           | `ls -Z /var/www/html`      | SELinux/Permissions |
| Apache 404           | `ls /var/www/html`         | Web content         |
| Permission denied    | `ls -ld DIRECTORY`         | Permissions         |
| Sudo unavailable     | `id USERNAME`              | Users/Groups        |
| Disk full            | `df -h`                    | Storage             |
| Backup failure       | `backup.sh` + `backup.log` | Backup              |
| Health check failure | `health-check.sh`          | Monitoring          |
| Cron not running     | `systemctl status crond`   | Automation          |
| Service failure      | `systemctl status SERVICE` | systemd             |
| Package failure      | `dnf repolist`             | Package management  |

---

# 51. Final Troubleshooting Procedure

For any issue in this project, use the following sequence:

```text
1. Identify the affected component
          ↓
2. Check its current status
          ↓
3. Check configuration
          ↓
4. Check logs
          ↓
5. Check network/firewall/SELinux
          ↓
6. Check permissions
          ↓
7. Apply corrective action
          ↓
8. Verify service status
          ↓
9. Test functionality
          ↓
10. Run health-check.sh
```

Final verification:

```bash
sudo ./scripts/health-check.sh
```

Then review:

```bash
sudo cat /server-data/logs/health-report.txt
```

---

# 52. Conclusion

The troubleshooting process for the Mini Linux Server follows a structured diagnostic approach rather than relying on random configuration changes.

The key tools used throughout the project are:

```text
systemctl
journalctl
firewall-cmd
ss
ip
nmcli
getenforce
sestatus
ls
chmod
chown
df
du
curl
dnf
```

Understanding these tools provides a strong foundation for diagnosing Linux server problems in **system administration, Cloud, DevOps, and production infrastructure environments**.
