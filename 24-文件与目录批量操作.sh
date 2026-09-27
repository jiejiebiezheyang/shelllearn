#!/bin/bash
# ============================================
# 序号: 24
# 主题: 文件与目录批量操作（find + xargs）
# 难度: ★★★
# 前置知识: 11 输入输出重定向、12 管道与文本处理
# 学习目标: 掌握 find 的常用筛选条件与安全的 xargs 批量处理
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. find 的基本句式：find 从哪找 条件 动作
#      find . -type f -name "*.log"      按类型和名字找
#      find . -type d                    只找目录
#      find . -iname "*.TMP"             忽略大小写
#      find . -empty                     空文件或空目录
#      find . -mtime -1                  最近 1 天内修改过（-1 表示 1 天以内）
#      find . -size +1k                  大于 1KB
# 2. 找到之后怎么做？两种主流方式：
#      · -exec 命令 {} \;    对每个结果执行一次（每行末尾的 \; 不能少）
#      · | xargs 命令         把结果拼成一行参数一次性/分批执行，效率更高
# 3. 【重点】文件名里带空格时，find | xargs 会被空格切开，导致处理错文件。
#    安全写法是两头配对：
#      find . -name "*.txt" -print0 | xargs -0 命令
#      -print0 用 \0 分隔，xargs -0 按 \0 解析，空格和换行都不会出错。
# 4. xargs 常用选项：
#      -n1 每次只传 1 个参数      -I{} 用 {} 占位并逐个替换
#      -r  没有输入时不执行命令   -t  执行前先打印命令
# 5. find 自带删除动作：find . -name "*.tmp" -delete，比 xargs rm 更安全。
# 6. 危险提醒：find / -delete 这类命令一定要先加 -print 预览，
#    确认结果无误后再把 -print 换成 -delete。
# ------------------------------------------------------------

echo "===== 小节 0：准备实验目录 ====="
work=$(mktemp -d)                      # 自建实验场地
mkdir -p "$work"/{logs,cache,tmp}      # 花括号展开，一次建 3 个目录
touch "$work/logs/app.log" "$work/logs/error.log" "$work/cache/data.tmp" "$work/tmp/a.tmp"
cd "$work" || exit 1                   # 进到实验目录里，后面都用相对路径
echo "实验目录已建好，结构如下（. 就代表实验目录本身）："
find . | sort                          # 列出全部内容

echo
echo "===== 小节 1：按名字和类型查找 ====="
echo "-- 所有 .log 文件 --"
find . -type f -name "*.log" | sort
echo "-- 所有目录 --"
find . -type d | sort
echo "-- 所有 .tmp 文件（忽略大小写） --"
find . -type f -iname "*.tmp" | sort

echo
echo "===== 小节 2：用 -exec 对每个结果执行命令 ====="
find . -type f -name "*.log" -exec echo "  处理文件: {}" \; | sort   # 每个结果执行一次
echo "（{} 会被替换成找到的文件名，末尾的 \\; 表示命令到此结束）"

echo
echo "===== 小节 3：用管道 + xargs 批量处理 ====="
echo "-- 一次性统计所有 .log 文件的行数 --"
find . -type f -name "*.log" | sort | xargs wc -l    # 结果拼成一行参数
echo "-- 每次只传一个参数（-n1） --"
find . -type f -name "*.log" | sort | xargs -n1 echo "  收到文件:"

echo
echo "===== 小节 4：文件名带空格时的经典陷阱 ====="
touch "my file.txt"                    # 造一个名字里带空格的文件
echo "-- 危险写法：不加 -print0，空格被当成参数分隔符 --"
find . -name "my*.txt" | xargs -n1 echo "  收到:"
echo "-- 安全写法：-print0 配 xargs -0 --"
find . -name "my*.txt" -print0 | xargs -0 -n1 echo "  收到:"
echo "  对比一下就能看出：危险写法把 1 个文件当成了 2 个"

echo
echo "===== 小节 5：按时间和大小筛选 ====="
echo "-- 最近 1 天内修改过的文件 --"
find . -type f -mtime -1 | sort
echo "-- 空文件（-empty） --"
find . -type f -empty | sort
echo "-- 大于 0 字节的文件（-size +0c） --"
find . -type f -size +0c | sort
echo "（实验目录里的文件都是刚建的空文件，所以第二个结果里有一堆，第三个为空）"

echo
echo "===== 小节 6：批量删除与清理 ====="
echo "-- 删除前先预览要删哪些 .tmp 文件 --"
find . -type f -name "*.tmp" | sort
echo "-- 确认无误，执行删除 --"
find . -type f -name "*.tmp" -delete   # 用自带的 -delete 更安全
echo "-- 删除后剩下的文件 --"
find . -type f | sort

cd / && rm -rf "$work"                 # 离开实验目录并清理
echo
echo "实验目录已清理"

# ------------------------------------------------------------
# 运行结果（实验目录名随机，但脚本里用相对路径，所以输出是固定的）：
# ===== 小节 0：准备实验目录 =====
# 实验目录已建好，结构如下（. 就代表实验目录本身）：
# .
# ./cache
# ./cache/data.tmp
# ./logs
# ./logs/app.log
# ./logs/error.log
# ./tmp
# ./tmp/a.tmp
#
# ===== 小节 1：按名字和类型查找 =====
# -- 所有 .log 文件 --
# ./logs/app.log
# ./logs/error.log
# -- 所有目录 --
# .
# ./cache
# ./logs
# ./tmp
# -- 所有 .tmp 文件（忽略大小写） --
# ./cache/data.tmp
# ./tmp/a.tmp
#
# ===== 小节 2：用 -exec 对每个结果执行命令 =====
#   处理文件: ./logs/app.log
#   处理文件: ./logs/error.log
# （{} 会被替换成找到的文件名，末尾的 \; 表示命令到此结束）
#
# ===== 小节 3：用管道 + xargs 批量处理 =====
# -- 一次性统计所有 .log 文件的行数 --
# 0 ./logs/app.log
# 0 ./logs/error.log
# 0 total
# -- 每次只传一个参数（-n1） --
#   收到文件: ./logs/app.log
#   收到文件: ./logs/error.log
#
# ===== 小节 4：文件名带空格时的经典陷阱 =====
# -- 危险写法：不加 -print0，空格被当成参数分隔符 --
#   收到: ./my
#   收到: file.txt
# -- 安全写法：-print0 配 xargs -0 --
#   收到: ./my file.txt
#   对比一下就能看出：危险写法把 1 个文件当成了 2 个
#
# ===== 小节 5：按时间和大小筛选 =====
# -- 最近 1 天内修改过的文件 --
# ./cache/data.tmp
# ./logs/app.log
# ./logs/error.log
# ./my file.txt
# ./tmp/a.tmp
# -- 空文件（-empty） --
# ./cache/data.tmp
# ./logs/app.log
# ./logs/error.log
# ./my file.txt
# ./tmp/a.tmp
# -- 大于 0 字节的文件（-size +0c） --
# （实验目录里的文件都是刚建的空文件，所以第二个结果里有一堆，第三个为空）
#
# ===== 小节 6：批量删除与清理 =====
# -- 删除前先预览要删哪些 .tmp 文件 --
# ./cache/data.tmp
# ./tmp/a.tmp
# -- 确认无误，执行删除 --
# -- 删除后剩下的文件 --
# ./logs/app.log
# ./logs/error.log
# ./my file.txt
#
# 实验目录已清理
# ------------------------------------------------------------
