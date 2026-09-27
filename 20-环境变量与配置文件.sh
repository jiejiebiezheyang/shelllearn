#!/bin/bash
# ============================================
# 序号: 20
# 主题: 环境变量与配置文件（.bashrc、source）
# 难度: ★★☆
# 前置知识: 01 变量定义与使用、11 输入输出重定向
# 学习目标: 掌握 export、env、source 与 .bashrc/PATH 的配置方法
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 环境变量是"会传给子进程的变量"，用 export 声明；
#    普通变量只在当前 shell 有效，子进程看不到。
# 2. 查看环境变量：
#      env / printenv      列出全部环境变量
#      echo "$HOME"        取某一个
#      env | grep '^APP_'  过滤出自己关心的
# 3. 常见内置环境变量：HOME 家目录、USER 用户名、PATH 命令搜索路径、
#    SHELL 当前 shell、PWD 当前目录、LANG 语言编码。
# 4. source 文件（等价写法 . 文件）：在当前 shell 里执行文件内容，
#    所以文件里定义的变量、函数会留在当前 shell。
#    而 bash 文件 是另起一个子进程执行，变量出不来。
#    这正是"配置文件"的实现原理。
# 5. ~/.bashrc：每次打开新的交互式终端都会自动 source 它。
#    想永久添加 PATH、别名、提示符，就写在这里。
#    改完要立刻生效，执行 source ~/.bashrc。
# 6. 临时改 PATH：export PATH="/新目录:$PATH"（放前面优先查找）。
#    只对当前 shell 有效，关掉终端就没了。
# 7. 配置文件里建议只放"赋值"，不要放会打印内容或需要交互的命令，
#    否则每次开终端都会刷一堆信息。
# ------------------------------------------------------------

echo "===== 小节 1：查看已有的环境变量 ====="
echo "家目录 HOME   = $HOME"                       # 最常用的环境变量之一
echo "当前用户 USER = $USER"                       # 当前登录名
echo "当前 shell    = $SHELL   （是你登录时的默认 shell，不一定是 bash）"
echo "当前目录 PWD  = $PWD"                        # 等价于 pwd 命令
echo "PATH 的前 3 段（命令就是从这里按顺序找的）："
echo "$PATH" | tr ':' '\n' | head -3 | sed 's/^/  /'   # 按冒号拆行后取前 3 行
echo "环境变量总个数：$(env | wc -l)"

echo
echo "===== 小节 2：export 让变量传给子进程 ====="
export APP_MODE="production"           # export 之后子进程也能读到
LOCAL_ONLY="只在当前 shell 里"          # 没有 export，子进程读不到
echo "父 shell：APP_MODE=$APP_MODE，LOCAL_ONLY=$LOCAL_ONLY"
bash -c 'echo "子 shell：APP_MODE=${APP_MODE:-读不到}，LOCAL_ONLY=${LOCAL_ONLY:-读不到}"'
echo "用 env 也能过滤出来：$(env | grep '^APP_MODE=')"
echo "注意：子进程修改环境变量，不会影响父 shell"

echo
echo "===== 小节 3：自制一个配置文件并用 source 载入 ====="
configfile=$(mktemp)                   # 自建配置文件，不依赖外部文件
cat > "$configfile" <<'EOF'
# 应用配置文件：只放赋值，不放会打印的命令
APP_NAME="我的应用"
APP_PORT=8080
APP_DEBUG="true"
EOF
echo "配置文件内容如下："
sed 's/^/  /' "$configfile"
source "$configfile"                   # source = 在当前 shell 里执行
echo "载入后：APP_NAME=$APP_NAME  APP_PORT=$APP_PORT  APP_DEBUG=$APP_DEBUG"
echo "因为用的是 source，这些变量现在就在当前 shell 里"

echo
echo "===== 小节 4：source 与 bash 执行的区别 ====="
subfile=$(mktemp)                      # 造一个"会定义变量"的小文件
echo 'SUB_VAR="我是子文件里定义的"' > "$subfile"
echo "文件内容：$(cat "$subfile")"
bash "$subfile"                        # 新开进程执行，变量留在子进程
echo "用 bash 执行后：SUB_VAR=[${SUB_VAR:-父 shell 读不到}]"
source "$subfile"                      # 在当前 shell 里执行
echo "用 source 执行后：SUB_VAR=[$SUB_VAR]"
echo "结论：source 相当于把文件内容原样粘贴到当前 shell 里执行"

echo
echo "===== 小节 5：把变量导出成环境变量再取消 ====="
export TEMP_TOKEN="abc123"             # 临时导出一个环境变量
echo "导出后子进程能看到：$(bash -c 'echo $TEMP_TOKEN')"
unset TEMP_TOKEN                       # 取消掉
echo "unset 之后子进程看到：[$(bash -c 'echo ${TEMP_TOKEN:-空}')]"

echo
echo "===== 小节 6：.bashrc 与临时修改 PATH ====="
echo "~/.bashrc 是每次开新终端都会自动 source 的配置文件"
echo "想永久把 /opt/mytools 加进 PATH，就在 ~/.bashrc 里加一行："
echo '  export PATH="$PATH:/opt/mytools"'
old_path="$PATH"                       # 先备份原来的 PATH
export PATH="/tmp:$PATH"               # 临时把 /tmp 插到最前面
echo "临时修改后，PATH 第一段 = $(echo "$PATH" | cut -d: -f1)"
export PATH="$old_path"                # 还原，避免影响后面
echo "还原后，PATH 第一段 = $(echo "$PATH" | cut -d: -f1)"
echo "这种 export 只在当前 shell 有效，关掉终端就恢复原样"

rm -f "$configfile" "$subfile"         # 清理临时文件
echo
echo "临时文件已清理"

# ------------------------------------------------------------
# 运行结果（部分内容随你的机器变化）：
# ===== 小节 1：查看已有的环境变量 =====
# 家目录 HOME   = /home/你的用户名
# 当前用户 USER = 你的用户名
# 当前 shell    = /usr/bin/zsh（随你的登录环境不同）
# 当前目录 PWD  = /home/你的用户名/code/sh
# PATH 的前 3 段（命令就是从这里按顺序找的）：
#   /usr/local/sbin
#   /usr/local/bin
#   /usr/sbin
# 环境变量总个数：40（随机器和终端环境不同）
#
# ===== 小节 2：export 让变量传给子进程 =====
# 父 shell：APP_MODE=production，LOCAL_ONLY=只在当前 shell 里
# 子 shell：APP_MODE=production，LOCAL_ONLY=读不到
# 用 env 也能过滤出来：APP_MODE=production
# 注意：子进程修改环境变量，不会影响父 shell
#
# ===== 小节 3：自制一个配置文件并用 source 载入 =====
# 配置文件内容如下：
#   # 应用配置文件：只放赋值，不放会打印的命令
#   APP_NAME="我的应用"
#   APP_PORT=8080
#   APP_DEBUG="true"
# 载入后：APP_NAME=我的应用  APP_PORT=8080  APP_DEBUG=true
# 因为用的是 source，这些变量现在就在当前 shell 里
#
# ===== 小节 4：source 与 bash 执行的区别 =====
# 文件内容：SUB_VAR="我是子文件里定义的"
# 用 bash 执行后：SUB_VAR=[父 shell 读不到]
# 用 source 执行后：SUB_VAR=[我是子文件里定义的]
# 结论：source 相当于把文件内容原样粘贴到当前 shell 里执行
#
# ===== 小节 5：把变量导出成环境变量再取消 =====
# 导出后子进程能看到：abc123
# unset 之后子进程看到：[空]
#
# ===== 小节 6：.bashrc 与临时修改 PATH =====
# ~/.bashrc 是每次开新终端都会自动 source 的配置文件
# 想永久把 /opt/mytools 加进 PATH，就在 ~/.bashrc 里加一行：
#   export PATH="$PATH:/opt/mytools"
# 临时修改后，PATH 第一段 = /tmp
# 还原后，PATH 第一段 = 你原来的第一段（每台机器都不一样）
# 这种 export 只在当前 shell 有效，关掉终端就恢复原样
#
# 临时文件已清理
# ------------------------------------------------------------
