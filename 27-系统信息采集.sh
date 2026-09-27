#!/bin/bash
# ============================================
# 序号: 27
# 主题: 系统信息采集脚本
# 难度: ★★★
# 前置知识: 11 输入输出重定向、13 命令替换与算术运算
# 学习目标: 会从 /proc 和系统命令中采集 CPU、内存、磁盘等信息并生成报告
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 采集系统信息有两条路：用现成命令（uname、df、free 等），
#    或者直接读 /proc、/etc 下的文件，后者最原始也最通用。
# 2. 常用命令速查：
#      uname -r 内核版本 / uname -m 架构 / hostname 主机名 / whoami 用户
#      uptime -p 运行时长 / uptime -s 开机时间 / date 当前时间
#      df -h / 根分区磁盘 / free -h 内存概览 / nproc CPU 核心数
# 3. 常用文件速查：
#      /etc/os-release   发行版名称（PRETTY_NAME="Ubuntu 24.04"）
#      /proc/cpuinfo     CPU 信息（model name、processor 行）
#      /proc/meminfo     内存信息（MemTotal、MemAvailable，单位 KB）
#      /proc/loadavg     负载（1、5、15 分钟平均负载）
# 4. 采集脚本的三个注意点：
#    · 命令可能不存在（nproc、ip 等），要用 command -v 判断或给默认值；
#    · 输出字段可能随系统不同，尽量用 sed/awk 精确提取，别整行打印；
#    · 数字单位要换算，例如 /proc/meminfo 是 KB，除以 1024 才是 MB。
# 5. 用 { ... } > 报告文件 可以把整段输出存成文件，再搭配 date 给
#    文件命名，就是一份"每日巡检报告"。
# 6. 本脚本的输出会随你的机器变化，下面"运行结果"只是示例，
#    重点看每个项目的名字和格式，数值对不对不用纠结。
# ------------------------------------------------------------

echo "===== 小节 1：主机与系统 ====="
echo "主机名     : $(hostname)"                                   # 机器名
echo "当前用户   : $(whoami)"                                     # 当前登录用户
if [[ -r /etc/os-release ]]; then                                 # 发行版信息
    echo "操作系统   : $(sed -n 's/^PRETTY_NAME="\(.*\)"/\1/p' /etc/os-release)"
else
    echo "操作系统   : 无法识别（没有 /etc/os-release）"
fi
echo "内核版本   : $(uname -r)"                                   # 内核
echo "系统架构   : $(uname -m)"                                   # x86_64 / aarch64
echo "运行时长   : $(uptime -p 2>/dev/null || echo 未知)"          # 已运行多久
echo "开机时间   : $(uptime -s 2>/dev/null || echo 未知)"          # 上次启动时刻
echo "当前时间   : $(date '+%F %T')"

echo
echo "===== 小节 2：CPU 信息 ====="
# 数一数 /proc/cpuinfo 里有多少个 processor 行，就是逻辑核心数
cores=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo 0)
echo "逻辑核心数 : $cores"
echo "CPU 型号   : $(sed -n 's/^model name[[:space:]]*: //p' /proc/cpuinfo | head -1)"
echo "平均负载   : $(cut -d' ' -f1-3 /proc/loadavg)   <-- 1 分钟 / 5 分钟 / 15 分钟"
echo "（判断负载是否偏高：把 1 分钟负载和核心数比较，接近或超过就要留意了）"

echo
echo "===== 小节 3：内存信息 ====="
awk '/^MemTotal:|^MemAvailable:|^SwapTotal:/ {
        printf "%-14s %8.0f MB\n", $1, $2 / 1024
     }' /proc/meminfo
echo "（MemTotal 是总内存，MemAvailable 是还能用的内存，SwapTotal 是交换分区）"

echo
echo "===== 小节 4：磁盘使用情况 ====="
echo "-- 根分区 --"
df -h / | sed 's/^/  /'                # -h 以人类可读单位显示
echo "-- 所有已挂载的文件系统（只看前 5 行） --"
df -h | head -5 | sed 's/^/  /'
echo "（重点关注 Use% 这一列，超过 85% 就该清理了）"

echo
echo "===== 小节 5：网络信息 ====="
if command -v hostname > /dev/null 2>&1; then
    echo "本机 IP    : $(hostname -I 2>/dev/null | awk '{print $1}')"
fi
if command -v ip > /dev/null 2>&1; then
    echo "默认网关   : $(ip route 2>/dev/null | awk '/^default/ {print $3; exit}')"
else
    echo "默认网关   : 未安装 ip 命令，跳过"
fi
echo "DNS 服务器 : $(awk '/^nameserver/ {printf "%s ", $2}' /etc/resolv.conf 2>/dev/null)"

echo
echo "===== 小节 6：生成巡检报告文件 ====="
work=$(mktemp -d)                                          # 报告存放目录
report="$work/sysinfo.txt"
{
    echo "========== 系统巡检报告 =========="
    echo "主机名   : $(hostname)"
    echo "生成时间 : $(date '+%F %T')"
    echo "内核版本 : $(uname -r)"
    echo "逻辑核心 : $cores"
    echo "内存总量 : $(awk '/^MemTotal:/ {printf "%.0f MB", $2/1024}' /proc/meminfo)"
    echo "内存可用 : $(awk '/^MemAvailable:/ {printf "%.0f MB", $2/1024}' /proc/meminfo)"
    echo "根分区使用："
    df -h / | tail -1 | awk '{printf "  已用 %s / 共 %s（%s）\n", $3, $2, $5}'
    echo "=================================="
} > "$report"
cat "$report"
echo "报告已保存到：$report"
echo "报告行数：$(wc -l < "$report") 行（行数固定，数值随机器变化）"
rm -rf "$work"                                             # 清理临时报告
echo "临时报告已清理（实际使用时可以改成保存到固定目录）"

# ------------------------------------------------------------
# 运行结果（以下数值全部随机器变化，重点是格式和理解）：
# ===== 小节 1：主机与系统 =====
# 主机名     : my-pc
# 当前用户   : cyan
# 操作系统   : Ubuntu 24.04.1 LTS
# 内核版本   : 6.8.0-45-generic
# 系统架构   : x86_64
# 运行时长   : up 3 hours, 25 minutes
# 开机时间   : 2025-01-01 09:00:00
# 当前时间   : 2025-01-01 12:25:00
#
# ===== 小节 2：CPU 信息 =====
# 逻辑核心数 : 8
# CPU 型号   : Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz
# 平均负载   : 0.15 0.20 0.18   <-- 1 分钟 / 5 分钟 / 15 分钟
# （判断负载是否偏高：把 1 分钟负载和核心数比较，接近或超过就要留意了）
#
# ===== 小节 3：内存信息 =====
# MemTotal:         16384 MB
# MemAvailable:      9216 MB
# SwapTotal:         2048 MB
# （MemTotal 是总内存，MemAvailable 是还能用的内存，SwapTotal 是交换分区）
#
# ===== 小节 4：磁盘使用情况 =====
# -- 根分区 --
#   Filesystem      Size  Used Avail Use% Mounted on
#   /dev/nvme0n1p2  476G  120G  332G  27% /
# -- 所有已挂载的文件系统（只看前 5 行） --
#   Filesystem      Size  Used Avail Use% Mounted on
#   tmpfs           3.2G  2.1M  3.2G   1% /run
#   /dev/nvme0n1p2  476G  120G  332G  27% /
#   tmpfs            16G     0   16G   0% /dev/shm
#   tmpfs           5.0M     0  5.0M   0% /run/lock
# （重点关注 Use% 这一列，超过 85% 就该清理了）
#
# ===== 小节 5：网络信息 =====
# 本机 IP    : 192.168.1.20
# 默认网关   : 192.168.1.1
# DNS 服务器 : 192.168.1.1 8.8.8.8
#
# ===== 小节 6：生成巡检报告文件 =====
# ========== 系统巡检报告 ==========
# 主机名   : my-pc
# 生成时间 : 2025-01-01 12:25:00
# 内核版本 : 6.8.0-45-generic
# 逻辑核心 : 8
# 内存总量 : 16384 MB
# 内存可用 : 9216 MB
# 根分区使用：
#   已用 120G / 共 476G（27%）
# ==================================
# 报告已保存到：/tmp/tmp.xxxxxxxx/sysinfo.txt
# 报告行数：10 行（行数固定，数值随机器变化）
# 临时报告已清理（实际使用时可以改成保存到固定目录）
# ------------------------------------------------------------
