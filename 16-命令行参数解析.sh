#!/bin/bash
# ============================================
# 序号: 16
# 主题: 命令行参数解析（getopts）
# 难度: ★★★
# 前置知识: 02 位置参数与特殊变量、05 case 分支
# 学习目标: 掌握 getopts 解析 -x 开关和 -x 值 两种选项的完整套路
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 命令行选项有两种形态：开关型（-v、-h，只要"有没有"），
#    带值型（-u alice、-p 8080，选项后面还要跟一个值）。
# 2. getopts 固定套路（背下来即可）：
#      while getopts ":u:p:vh" opt; do
#          case "$opt" in u) user="$OPTARG" ;; esac
#      done
# 3. 选项字符串的规则：字母后面带冒号 u: 表示要参数值；不带冒号 v
#    表示开关；字符串开头的冒号 : 是"静默模式"，错误不自动打印，
#    全部交给你在 :) 和 \?) 分支里处理。
# 4. 两个内置变量：OPTARG 是当前选项后面的参数值，
#    OPTIND 是下一个要处理的参数下标（从 1 开始）。
# 5. 解析完成后一定要写 shift $((OPTIND - 1))，把已经吃掉的选项
#    从参数列表里去掉，剩下的才是"非选项参数"。
# 6. 【新手必踩的坑】每开始一轮新的 getopts 解析之前，都要先写 OPTIND=1
#    把它复位，否则 getopts 还记着上一轮停下的位置，会什么都不解析。
# 7. 错误分支：:) 表示缺参数值，\?) 表示不认识的选项；
#    拿到值后还要做校验（是不是数字、在不在范围内）。
# ------------------------------------------------------------

# 为了演示方便：没传参数时自动补一组示例参数
if [ $# -eq 0 ]; then
    set -- -u alice -p 8080 -v
fi

echo "===== 小节 1：为什么要用 getopts ====="
echo "本脚本收到的原始参数是：$*"
echo "如果手工解析，要自己数 \$1 是不是 -u、\$2 是不是值，选项一多就乱"
echo "getopts 是 bash 内置工具，专门干这件事，还自带错误处理"

echo
echo "===== 小节 2：getopts 基本用法 ====="
user="默认用户"                        # 给每个选项准备默认值
port=80
verbose=0
OPTIND=1                               # 每轮解析前先复位，否则可能一个都不解析
while getopts ":u:p:vh" opt; do        # 开头的 : 是静默模式，错误自己处理
    case "$opt" in
        u) user="$OPTARG" ;;           # u 后面有冒号，所以会有 OPTARG
        p) port="$OPTARG" ;;           # 同上，端口值
        v) verbose=1 ;;                # 开关型选项，没有 OPTARG
        h) echo "用法: $0 [-u 用户名] [-p 端口] [-v]"; exit 0 ;;
        :) echo "错误：选项 -$OPTARG 后面缺少参数值" ;;
        \?) echo "错误：不认识的选项 -$OPTARG" ;;
    esac
done
echo "解析结果：用户=$user  端口=$port  详细模式=$verbose"

echo
echo "===== 小节 3：OPTIND 与 shift ====="
echo "getopts 停下来的位置 OPTIND = $OPTIND"
shift $((OPTIND - 1))                  # 丢掉已经解析过的选项
echo "剩下的位置参数（非选项参数）：[$*]"
echo "现在 \$# = $#"

echo
echo "===== 小节 4：选项混合位置参数 ====="
set -- -u bob file1.txt file2.txt      # 选项在前，位置参数在后
user=""
OPTIND=1                               # 关键：新一轮解析前必须复位 OPTIND
while getopts ":u:" opt; do
    case "$opt" in
        u) user="$OPTARG" ;;
    esac
done
shift $((OPTIND - 1))                  # 分离之后剩下的就是文件名
echo "解析出的用户：$user"
echo "剩下的文件：$*"
echo "遍历它们："
for f in "$@"; do
    echo "  待处理文件：$f"
done

echo
echo "===== 小节 5：错误处理演示 ====="
set -- -x -u                           # 故意给一个错误选项和一个缺值的选项
OPTIND=1                               # 复位
while getopts ":u:p:vh" opt; do
    case "$opt" in
        u) echo "收到 -u，值为 $OPTARG" ;;
        :) echo "缺少参数值：-$OPTARG 后面没给东西" ;;
        \?) echo "未知选项：-$OPTARG" ;;
    esac
done

echo
echo "===== 小节 6：解析完之后做校验 ====="
set -- -p abc                          # 端口给了个非数字
port=""
OPTIND=1                               # 复位
while getopts ":p:" opt; do
    case "$opt" in
        p) port="$OPTARG" ;;
    esac
done
if [[ ! "$port" =~ ^[0-9]+$ ]]; then   # 用正则确认全是数字
    echo "校验失败：端口必须是数字，收到的却是 [$port]"
elif (( port < 1 || port > 65535 )); then
    echo "校验失败：端口 $port 超出 1-65535 范围"
else
    echo "校验通过：端口 $port 合法"
fi

# ------------------------------------------------------------
# 运行结果：
# ===== 小节 1：为什么要用 getopts =====
# 本脚本收到的原始参数是：-u alice -p 8080 -v
# 如果手工解析，要自己数 $1 是不是 -u、$2 是不是值，选项一多就乱
# getopts 是 bash 内置工具，专门干这件事，还自带错误处理
#
# ===== 小节 2：getopts 基本用法 =====
# 解析结果：用户=alice  端口=8080  详细模式=1
#
# ===== 小节 3：OPTIND 与 shift =====
# getopts 停下来的位置 OPTIND = 6
# 剩下的位置参数（非选项参数）：[]
# 现在 $# = 0
#
# ===== 小节 4：选项混合位置参数 =====
# 解析出的用户：bob
# 剩下的文件：file1.txt file2.txt
# 遍历它们：
#   待处理文件：file1.txt
#   待处理文件：file2.txt
#
# ===== 小节 5：错误处理演示 =====
# 未知选项：-x
# 缺少参数值：-u 后面没给东西
#
# ===== 小节 6：解析完之后做校验 =====
# 校验失败：端口必须是数字，收到的却是 [abc]
# ------------------------------------------------------------
