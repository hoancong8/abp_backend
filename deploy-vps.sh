#!/bin/bash
# ==============================================================================
# Script Tự Động Tối Ưu & Triển Khai Cho VPS 1 CPU / 1GB RAM / 16GB SSD
# Target IP: 163.227.231.23
# ==============================================================================

set -e

echo "=== 1. Kiểm tra vài tạo SWAP 2GB ==="
if [ $(free -m | awk '/^Swap:/{print $2}') -eq 0 ]; then
    echo "Tạo file swap 2GB tại /swapfile..."
    fallocate -l 2G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=2048
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    echo "Đã tạo Swap 2GB thành công!"
else
    echo "Swap đã được kích hoạt trên hệ thống."
fi

# Tối ưu sysctl swappiness
sysctl vm.swappiness=10
echo "vm.swappiness=10" >> /etc/sysctl.conf || true

echo "=== 2. Cấu hình Docker Log Rotation (Tránh đầy 16GB ổ cứng) ==="
mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
systemctl restart docker || true

echo "=== 3. Mở Cổng Firewall (UFW) ==="
if command -v ufw > /dev/null; then
    ufw allow 8080/tcp || true
    ufw allow 4200/tcp || true
    ufw allow 80/tcp || true
fi

echo "=== 4. Khởi động Docker Compose ==="
docker compose down || true
docker compose up -d --build

echo "=== 5. Dọn dẹp Docker Image rác để tiết kiệm dung lượng ổ cứng ==="
docker image prune -f
docker builder prune -f --filter "until=24h"

echo "=== Hoàn thành triển khai! ==="
echo "Backend API:  http://163.227.231.23:8080/swagger"
echo "Frontend Web: http://163.227.231.23:4200"
echo "Kiểm tra RAM sử dụng bằng lệnh: docker stats"
