#!/bin/bash

SERVICE_NAME="xrayr"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
SOURCE_SERVICE="$(cd "$(dirname "$0")" && pwd)/xrayr.service"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_service() {
    if [ ! -f "$SOURCE_SERVICE" ]; then
        error "服务文件不存在: $SOURCE_SERVICE"
        exit 1
    fi
    cp "$SOURCE_SERVICE" "$SERVICE_FILE"
    systemctl daemon-reload
    systemctl enable "$SERVICE_NAME"
    systemctl start "$SERVICE_NAME"
    info "XrayR 服务已安装、启用开机启动并已启动"
}

uninstall_service() {
    systemctl stop "$SERVICE_NAME" 2>/dev/null
    systemctl disable "$SERVICE_NAME" 2>/dev/null
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload
    info "XrayR 服务已停止、取消开机启动并已卸载"
}

start_service() {
    systemctl start "$SERVICE_NAME"
    info "XrayR 服务已启动"
}

stop_service() {
    systemctl stop "$SERVICE_NAME"
    info "XrayR 服务已停止"
}

restart_service() {
    systemctl restart "$SERVICE_NAME"
    info "XrayR 服务已重启"
}

status_service() {
    systemctl status "$SERVICE_NAME" --no-pager
}

enable_service() {
    systemctl enable "$SERVICE_NAME"
    info "XrayR 已设置开机启动"
}

disable_service() {
    systemctl disable "$SERVICE_NAME"
    info "XrayR 已取消开机启动"
}

show_log() {
    journalctl -u "$SERVICE_NAME" -f --no-pager
}

show_usage() {
    echo ""
    echo "XrayR 服务管理脚本"
    echo ""
    echo "用法: $0 {install|uninstall|start|stop|restart|status|enable|disable|log}"
    echo ""
    echo "  install    - 安装服务、启用开机启动并启动"
    echo "  uninstall  - 停止服务、取消开机启动并卸载"
    echo "  start      - 启动服务"
    echo "  stop       - 停止服务"
    echo "  restart    - 重启服务"
    echo "  status     - 查看服务状态"
    echo "  enable     - 启用开机启动"
    echo "  disable    - 取消开机启动"
    echo "  log        - 实时查看日志"
    echo ""
}

case "$1" in
    install)    install_service ;;
    uninstall)  uninstall_service ;;
    start)      start_service ;;
    stop)       stop_service ;;
    restart)    restart_service ;;
    status)     status_service ;;
    enable)     enable_service ;;
    disable)    disable_service ;;
    log)        show_log ;;
    *)          show_usage ;;
esac