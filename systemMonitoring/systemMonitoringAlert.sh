#!/bin/bash
CPU_THRESHOLD=4
RAM_THRESHOLD=30
DISK_THRESHOLD=50

WEBHOOK_URL="https://discord.com/api/webhooks/1422666495384752260/asuz1clROIKFlW5P4P14xWCYmP9Il7WKRRQjpDNK2M3Wlg1U02c0FTk5G2mm091Yh4mb"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
 sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
 awk '{print 100 - $1}')
echo "CPU: ${CPU_USAGE}%"

CPU_USAGE_INT=$(printf "%.0f" "$CPU_USAGE")

if ((CPU_USAGE_INT > CPU_THRESHOLD )); then
    MESSAGE="⚠️ CPU Alert! CPU usage is at ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)"
    curl -H "Content-Type: application/json" \
    -X POST \
    -d "{\"content\": \"$MESSAGE\"}" \
    "$WEBHOOK_URL"
fi

RAM_USAGE=$(free | grep Mem | \
 awk '{printf("%.0f", ($3/$2) * 100.0)}')
echo "RAM: ${RAM_USAGE}%"

if ((RAM_USAGE > RAM_THRESHOLD )); then
    MESSAGE="⚠️ CPU Alert! CPU usage is at ${RAM_USAGE}% (threshold: ${RAM_THRESHOLD}%)"
    curl -H "Content-Type: application/json" \
    -X POST \
    -d "{\"content\": \"$MESSAGE\"}" \
    "$WEBHOOK_URL"
fi


DISK_USAGE=$(
df -h | awk '$6 == "/" { gsub(/%/, "", $5); print $5 }'
)
echo "DISK: ${DISK_USAGE}%"

if ((DISK_USAGE > DISK_THRESHOLD )); then
    MESSAGE="⚠️ DISK Alert! Root partition '/' usage is at ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)"
    curl -H "Content-Type: application/json" \
    -X POST \
    -d "{\"content\": \"$MESSAGE\"}" \
    "$WEBHOOK_URL"
fi
