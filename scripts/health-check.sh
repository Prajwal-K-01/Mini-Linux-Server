#!/bin/bash

# ==========================================================
# Mini Linux Server - Health Check Script
# Author: Prajwal K
# Description: Monitors the health and status of RHEL server
# ==========================================================

# -------------------- CONFIGURATION -----------------------

REPORT_DIR="/server-data/logs"
REPORT_FILE="$REPORT_DIR/health-report.txt"

# -------------------- COLORS ------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# -------------------- SETUP -------------------------------

mkdir -p "$REPORT_DIR"

# Start report
{
    echo "=========================================================="
    echo "             MINI RHEL SERVER HEALTH REPORT"
    echo "=========================================================="
    echo "Generated: $(date)"
    echo
} > "$REPORT_FILE"

# -------------------- FUNCTIONS ---------------------------

check_service() {

    SERVICE=$1

    if systemctl is-active --quiet "$SERVICE"; then
        echo -e "${GREEN}[OK]${NC} $SERVICE is running"
        echo "[OK] $SERVICE is running" >> "$REPORT_FILE"
    else
        echo -e "${RED}[FAIL]${NC} $SERVICE is not running"
        echo "[FAIL] $SERVICE is not running" >> "$REPORT_FILE"
    fi
}

# -------------------- SYSTEM INFORMATION -----------------

echo
echo -e "${BLUE}========== SYSTEM INFORMATION ==========${NC}"

HOSTNAME=$(hostname)
OS=$(cat /etc/redhat-release)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)

echo "Hostname : $HOSTNAME"
echo "OS       : $OS"
echo "Kernel   : $KERNEL"
echo "Uptime   : $UPTIME"

{
    echo
    echo "SYSTEM INFORMATION"
    echo "------------------"
    echo "Hostname : $HOSTNAME"
    echo "OS       : $OS"
    echo "Kernel   : $KERNEL"
    echo "Uptime   : $UPTIME"
} >> "$REPORT_FILE"

# -------------------- CPU INFORMATION --------------------

echo
echo -e "${BLUE}========== CPU INFORMATION ==========${NC}"

CPU_CORES=$(nproc)
LOAD_AVG=$(awk '{print $1}' /proc/loadavg)

echo "CPU Cores : $CPU_CORES"
echo "Load Avg  : $LOAD_AVG"

{
    echo
    echo "CPU INFORMATION"
    echo "---------------"
    echo "CPU Cores : $CPU_CORES"
    echo "Load Avg  : $LOAD_AVG"
} >> "$REPORT_FILE"

# -------------------- MEMORY INFORMATION -----------------

echo
echo -e "${BLUE}========== MEMORY INFORMATION ==========${NC}"

free -h

{
    echo
    echo "MEMORY INFORMATION"
    echo "------------------"
    free -h
} >> "$REPORT_FILE"

# -------------------- DISK INFORMATION ------------------

echo
echo -e "${BLUE}========== DISK USAGE ==========${NC}"

df -h /

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Root Disk Usage: $DISK_USAGE%"

{
    echo
    echo "DISK INFORMATION"
    echo "----------------"
    df -h /
    echo "Root Disk Usage: $DISK_USAGE%"
} >> "$REPORT_FILE"

# -------------------- NETWORK INFORMATION ---------------

echo
echo -e "${BLUE}========== NETWORK INFORMATION ==========${NC}"

IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "IP Address : $IP_ADDRESS"

if ping -c 2 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} Internet connectivity"
    NETWORK_STATUS="ONLINE"
else
    echo -e "${RED}[FAIL]${NC} Internet connectivity"
    NETWORK_STATUS="OFFLINE"
fi

{
    echo
    echo "NETWORK INFORMATION"
    echo "-------------------"
    echo "IP Address : $IP_ADDRESS"
    echo "Network    : $NETWORK_STATUS"
} >> "$REPORT_FILE"

# -------------------- SERVICE CHECK ----------------------

echo
echo -e "${BLUE}========== SERVICE STATUS ==========${NC}"

check_service sshd
check_service httpd
check_service firewalld

# -------------------- SELINUX ----------------------------

echo
echo -e "${BLUE}========== SECURITY / SELINUX ==========${NC}"

SELINUX_STATUS=$(getenforce)

echo "SELinux Status: $SELINUX_STATUS"

if [ "$SELINUX_STATUS" = "Enforcing" ]; then
    echo -e "${GREEN}[OK]${NC} SELinux is enforcing"
else
    echo -e "${YELLOW}[WARNING]${NC} SELinux is not enforcing"
fi

{
    echo
    echo "SECURITY"
    echo "--------"
    echo "SELinux Status: $SELINUX_STATUS"
} >> "$REPORT_FILE"

# -------------------- FIREWALL ---------------------------

echo
echo -e "${BLUE}========== FIREWALL ==========${NC}"

FIREWALL_STATUS=$(sudo firewall-cmd --state 2>/dev/null)

echo "Firewall Status: $FIREWALL_STATUS"

{
    echo
    echo "FIREWALL"
    echo "--------"
    echo "Firewall Status: $FIREWALL_STATUS"
} >> "$REPORT_FILE"

# -------------------- LISTENING PORTS --------------------

echo
echo -e "${BLUE}========== LISTENING PORTS ==========${NC}"

sudo ss -tulpn

{
    echo
    echo "LISTENING PORTS"
    echo "---------------"
    sudo ss -tulpn
} >> "$REPORT_FILE"

# -------------------- STORAGE ----------------------------

echo
echo -e "${BLUE}========== SERVER DATA ==========${NC}"

if [ -d "/server-data" ]; then

    SERVER_DATA_SIZE=$(sudo du -sh /server-data 2>/dev/null | awk '{print $1}')

    echo "Server Data Size: $SERVER_DATA_SIZE"

    {
        echo
        echo "SERVER DATA"
        echo "-----------"
        echo "Directory: /server-data"
        echo "Size     : $SERVER_DATA_SIZE"
    } >> "$REPORT_FILE"

else

    echo -e "${YELLOW}[WARNING]${NC} /server-data does not exist"

    echo "WARNING: /server-data does not exist" >> "$REPORT_FILE"

fi

# -------------------- FINAL HEALTH STATUS ----------------

echo
echo -e "${BLUE}========== FINAL STATUS ==========${NC}"

if [ "$NETWORK_STATUS" = "ONLINE" ] && \
   systemctl is-active --quiet sshd && \
   systemctl is-active --quiet httpd && \
   systemctl is-active --quiet firewalld && \
   [ "$SELINUX_STATUS" = "Enforcing" ]; then

    FINAL_STATUS="HEALTHY"

    echo -e "${GREEN}SERVER STATUS: HEALTHY${NC}"

else

    FINAL_STATUS="CHECK REQUIRED"

    echo -e "${YELLOW}SERVER STATUS: CHECK REQUIRED${NC}"

fi

{
    echo
    echo "=========================================================="
    echo "FINAL SERVER STATUS: $FINAL_STATUS"
    echo "=========================================================="
} >> "$REPORT_FILE"

# -------------------- REPORT LOCATION --------------------

echo
echo "Health report saved to:"
echo "$REPORT_FILE"

echo
echo "=========================================================="
echo "             HEALTH CHECK COMPLETED"
echo "=========================================================="

exit 0
