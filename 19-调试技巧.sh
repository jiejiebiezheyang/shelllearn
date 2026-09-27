#!/bin/bash
# ============================================
# 序号: 19
# 主题: 调试技巧
# 难度: ★★☆
# 前置知识: 18 退出码与错误处理
# 学习目标: 掌握 echo 调试、bash -n、set -x、PS4、shellcheck 五种手段
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 最简单的调试法就是打印：在可疑位置 echo 出变量值，
#    统一加个前缀（如 [调试]）方便定位，调完再删掉。
# 2. bash -n 脚本.sh：只做语法检查，不执行。
#    写完脚本第一件事就是它，能挡掉大部分括号、fi、esac 写错的问题。
# 3. bash -x 脚本.sh：把每条命令"展开后"打印出来再执行，
#    行首的 + 号数量表示调用层级（子 shell、函数会多一个 +）。
#    只想跟踪某一段，可以在脚本里写 set -x 开启、set +x 关闭。
# 4. PS4 是跟踪信息的前缀，默认是 "+ "。
#    改成 PS4='+ [第${LINENO}行] ' 就能直接看到出错的行号，非常实用。
# 5. shellcheck 是专门检查 shell 脚本的静态分析工具，
#    能发现变量没加引号、误用 [ ]、未定义变量等问题，强烈推荐安装。
# 6. 常用组合拳：bash -n 查语法 → shellcheck 查隐患 →
#    bash -x 查运行逻辑 → 最后删掉调试输出。
# 7. 别忘了第 18 课的 set -euo pipefail，让错误早点暴露也是一种调试。
# ------------------------------------------------------------

echo "===== 小节 1：最朴素的调试法 —— 打印变量 ====="
name="小明"                            # 想确认它到底存了什么
echo "[调试] name = [$name]"           # 加统一前缀，调完 grep 一下就能删干净
count=0
for i in 1 2 3; do
    count=$((count + i))
    echo "[调试] 第 $i 轮，count = $count"   # 循环里打印每轮状态
done
echo "[调试] 循环结束，count = $count"

echo
echo "===== 小节 2：bash -n 只查语法不执行 ====="
demofile=$(mktemp)                     # 造一个用来演示的小脚本
cat > "$demofile" <<'EOF'
#!/bin/bash
name="小明"
echo "你好，$name"
EOF
if bash -n "$demofile"; then           # -n 只检查语法
    echo "bash -n 检查通过：这个脚本没有语法错误"
fi
cat > "$demofile.bad" <<'EOF'
#!/bin/bash
if [ 1 -eq 1 ]; then
    echo "少了一个 fi"
EOF
bash -n "$demofile.bad" 2>&1 | head -2 | sed 's/^/  /'   # 故意写错，看报错
echo "上面就是语法检查抓出来的问题"
rm -f "$demofile.bad"

echo
echo "===== 小节 3：bash -x 打印执行过程 ====="
echo "-- 下面这 3 行是 bash -x 的真实输出 --"
bash -x "$demofile" 2>&1 | sed 's/^/    /'   # 2>&1 把跟踪信息一起接住
echo "-- 行首的 + 表示这是 bash 展开后真正执行的命令 --"

echo
echo "===== 小节 4：脚本内部 set -x / set +x ====="
x=1                                    # 这行不会被跟踪
y=2                                    # 这行也不会
set -x                                 # 从这里开始跟踪
sum=$((x + y))                         # 你会看到它被展开的样子
echo "sum = $sum"
set +x                                 # 关掉跟踪，避免刷屏
echo "set +x 之后输出又干净了"

echo
echo "===== 小节 5：自定义 PS4 显示行号 ====="
PS4='+ [第 ${LINENO} 行] '             # 重新定义跟踪前缀
set -x
a=10
b=20
echo "a + b = $((a + b))"
set +x
PS4='+ '                               # 用完恢复默认，养成好习惯
echo "现在 PS4 已经恢复成默认的 '+ '"

echo
echo "===== 小节 6：shellcheck 静态检查 ====="
if command -v shellcheck > /dev/null 2>&1; then
    echo "本机已安装 shellcheck，用法：shellcheck 你的脚本.sh"
else
    echo "本机没有安装 shellcheck，可以先了解它的作用："
    echo "  它会指出 '变量没加引号'、'[ ] 里用了 > '、'变量名拼错' 等问题"
    echo "  安装方式：sudo apt install shellcheck   或   brew install shellcheck"
fi
echo "推荐流程：bash -n 查语法 -> shellcheck 查隐患 -> bash -x 查逻辑 -> 真正运行"

rm -f "$demofile"                      # 清理演示文件
echo
echo "演示用的临时脚本已删除"

# ------------------------------------------------------------
# 运行结果（临时文件名随机）：
# ===== 小节 1：最朴素的调试法 —— 打印变量 =====
# [调试] name = [小明]
# [调试] 第 1 轮，count = 1
# [调试] 第 2 轮，count = 3
# [调试] 第 3 轮，count = 6
# [调试] 循环结束，count = 6
#
# ===== 小节 2：bash -n 只查语法不执行 =====
# bash -n 检查通过：这个脚本没有语法错误
#   /tmp/tmp.xxxxxxxx.bad: line 4: syntax error: unexpected end of file from `if' command on line 2
# 上面就是语法检查抓出来的问题
#
# ===== 小节 3：bash -x 打印执行过程 =====
# -- 下面这 3 行是 bash -x 的真实输出 --
#     + name=小明
#     + echo 你好，小明
#     你好，小明
# -- 行首的 + 表示这是 bash 展开后真正执行的命令 --
#
# ===== 小节 4：脚本内部 set -x / set +x =====
# + sum=3
# + echo 'sum = 3'
# sum = 3
# + set +x
# set +x 之后输出又干净了
# （注意：set +x 这条命令自己也会被跟踪打印出来，那是它最后一次生效）
#
# ===== 小节 5：自定义 PS4 显示行号 =====
# + [第 78 行] a=10
# + [第 79 行] b=20
# + [第 80 行] echo 'a + b = 30'
# a + b = 30
# + [第 81 行] set +x
# 现在 PS4 已经恢复成默认的 '+ '
# （行号以你实际文件中的位置为准）
#
# ===== 小节 6：shellcheck 静态检查 =====
# 本机没有安装 shellcheck，可以先了解它的作用：
#   它会指出 '变量没加引号'、'[ ] 里用了 > '、'变量名拼错' 等问题
#   安装方式：sudo apt install shellcheck   或   brew install shellcheck
# 推荐流程：bash -n 查语法 -> shellcheck 查隐患 -> bash -x 查逻辑 -> 真正运行
#
# 演示用的临时脚本已删除
# ------------------------------------------------------------
