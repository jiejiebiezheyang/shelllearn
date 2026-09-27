#!/bin/bash
# ============================================
# 序号: 28
# 主题: 文件备份与压缩脚本
# 难度: ★★★
# 前置知识: 14 条件组合与文件测试、18 退出码与错误处理
# 学习目标: 掌握 tar 打包压缩、备份命名、轮转保留与恢复校验
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. tar 三件套（记住 c / x / t 三个字母）：
#      tar -czf 包.tar.gz 要打包的东西     c = create 打包
#      tar -tzf 包.tar.gz                  t = list   只看内容
#      tar -xzf 包.tar.gz -C 目标目录       x = extract 解压
#    参数含义：z 用 gzip 压缩、f 指定文件名（f 必须紧挨着包名）、
#             v 显示过程、C 切换目录。
# 2. 【最容易踩的坑】打包时用 -C 切换目录，别写绝对路径：
#      tar -czf backup.tar.gz -C /home/user/data .     ✅ 干净
#      tar -czf backup.tar.gz /home/user/data          ⚠️ 包里带一长串路径
#    恢复时就没法解到任意位置了。
# 3. 备份文件命名惯例：名字 + 日期时间 + 后缀，
#    例：backup_$(date +%Y%m%d_%H%M%S).tar.gz。
#    带时间戳的好处是永远不会互相覆盖，方便追溯。
# 4. 备份轮转（只保留最近 N 份）的经典写法：
#      ls -1t 目录/backup_*.tar.gz | tail -n +$((N+1)) | xargs -r rm -f
#    ls -1t 按修改时间从新到旧，tail -n +3 就是从第 3 个开始（即最旧的）。
#    注意用 xargs -r，这样列表为空时不会误执行 rm。
# 5. 备份完一定要校验：tar -tzf 能列出内容，说明包没坏；
#    解压到临时目录再用 diff -r 和源目录比对，最保险。
# 6. 生产脚本里别忘了 set -euo pipefail 和 trap 清理（第 18 课）。
# ------------------------------------------------------------

set -uo pipefail                       # 严格模式：未定义变量报错、管道错误也报错

work=$(mktemp -d)                      # 自建实验场地
srcdir="$work/src"                     # 要备份的源目录
backupdir="$work/backups"              # 备份存放目录
mkdir -p "$srcdir/docs" "$srcdir/data" "$backupdir"

echo "===== 小节 1：准备源数据 ====="
echo "这是项目的说明文档。" > "$srcdir/docs/readme.txt"
printf 'host=127.0.0.1\nport=8080\n' > "$srcdir/data/config.conf"
head -c 1024 /dev/zero | tr '\0' 'A' > "$srcdir/data/blob.bin"   # 造一个 1KB 文件
echo "源目录结构："
find "$srcdir" -type f | sed "s|$work/||" | sort | sed 's/^/  /'
echo "源目录总大小：$(du -sh "$srcdir" | cut -f1)"

echo
echo "===== 小节 2：打包压缩 ====="
timestamp=$(date +%Y%m%d_%H%M%S)                          # 时间戳
pkg="$backupdir/backup_${timestamp}.tar.gz"               # 备份包完整路径
tar -czf "$pkg" -C "$work" src                            # -C 切到 work 再打包 src
echo "已生成备份包：$(basename "$pkg")"
echo "包大小：$(du -h "$pkg" | cut -f1)"
echo "（-C $work 让包里的路径是 src/... 而不是一长串 /tmp/tmp.xxx/src/...）"

echo
echo "===== 小节 3：校验备份包 ====="
if tar -tzf "$pkg" > /dev/null 2>&1; then                 # -t 能列出内容说明包完好
    echo "校验通过：压缩包可以正常读取"
else
    echo "校验失败：压缩包已损坏"
    exit 1
fi
echo "包内文件清单："
tar -tzf "$pkg" | sed 's/^/  /'

echo
echo "===== 小节 4：备份轮转（只保留最近 2 份） ====="
rotdir="$work/rot"                                        # 单独建个目录演示轮转
mkdir -p "$rotdir"
for i in 1 2 3 4 5; do                                    # 造 5 个"历史备份"
    touch "$rotdir/backup_2024050${i}_120000.tar.gz"
done
echo "-- 轮转前 --"
ls -1 "$rotdir" | sed 's/^/  /'
echo "-- 执行轮转：保留最近 2 份，其余删除 --"
ls -1t "$rotdir"/backup_*.tar.gz | tail -n +3 | xargs -r rm -f
echo "-- 轮转后 --"
ls -1 "$rotdir" | sed 's/^/  /'

echo
echo "===== 小节 5：恢复并校验 ====="
restoredir="$work/restore"
mkdir -p "$restoredir"
tar -xzf "$pkg" -C "$restoredir"                          # 解压到恢复目录
echo "恢复出来的文件："
find "$restoredir" -type f | sed "s|$work/||" | sort | sed 's/^/  /'
if diff -r "$srcdir" "$restoredir/src" > /dev/null; then   # 逐字节比对
    echo "校验结果：恢复出来的内容和源目录完全一致 ✅"
else
    echo "校验结果：内容不一致，备份可能有问题 ❌"
fi

echo
echo "===== 小节 6：清理策略对比 ====="
echo "本次保留了：$(ls -1 "$backupdir" | wc -l) 份正式备份"
echo "如果要保留 7 天，可以在脚本里加一行："
echo '  find "$backupdir" -name "backup_*.tar.gz" -mtime +7 -delete'
echo "（按修改时间删除 7 天前的备份，比按名字轮转更适合长期运行）"

rm -rf "$work"                                            # 清理实验目录
echo
echo "实验目录已清理"

# ------------------------------------------------------------
# 运行结果（时间戳和临时目录名随运行变化）：
# ===== 小节 1：准备源数据 =====
# 源目录结构：
#   src/data/blob.bin
#   src/data/config.conf
#   src/docs/readme.txt
# 源目录总大小：12K（随文件系统的块大小不同）
#
# ===== 小节 2：打包压缩 =====
# 已生成备份包：backup_20250101_120000.tar.gz
# 包大小：4.0K
# （-C /tmp/tmp.xxxxxxxx 让包里的路径是 src/... 而不是一长串 /tmp/tmp.xxx/src/...）
#
# ===== 小节 3：校验备份包 =====
# 校验通过：压缩包可以正常读取
# 包内文件清单：
#   src/
#   src/data/
#   src/data/blob.bin
#   src/data/config.conf
#   src/docs/
#   src/docs/readme.txt
#
# ===== 小节 4：备份轮转（只保留最近 2 份） =====
# -- 轮转前 --
#   backup_20240501_120000.tar.gz
#   backup_20240502_120000.tar.gz
#   backup_20240503_120000.tar.gz
#   backup_20240504_120000.tar.gz
#   backup_20240505_120000.tar.gz
# -- 执行轮转：保留最近 2 份，其余删除 --
# -- 轮转后 --
#   backup_20240504_120000.tar.gz
#   backup_20240505_120000.tar.gz
#
# ===== 小节 5：恢复并校验 =====
# 恢复出来的文件：
#   restore/src/data/blob.bin
#   restore/src/data/config.conf
#   restore/src/docs/readme.txt
# 校验结果：恢复出来的内容和源目录完全一致 ✅
#
# ===== 小节 6：清理策略对比 =====
# 本次保留了：1 份正式备份
# 如果要保留 7 天，可以在脚本里加一行：
#   find "$backupdir" -name "backup_*.tar.gz" -mtime +7 -delete
# （按修改时间删除 7 天前的备份，比按名字轮转更适合长期运行）
#
# 实验目录已清理
# ------------------------------------------------------------
