#!/bin/bash
# ============================================
# 序号: 22
# 主题: 函数进阶（局部变量 local、递归、库文件）
# 难度: ★★★
# 前置知识: 10 函数定义与返回值
# 学习目标: 掌握 local 作用域、递归写法与用 source 复用函数库
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 函数里的变量默认是"全局"的：不加 local 就赋值，
#    会把外面同名的变量改掉，这是 bash 里最容易埋雷的地方。
# 2. local 关键字让变量只在函数内有效，函数一结束就消失：
#      my_func() { local tmp="值"; ... }
#    · local 只能在函数内使用，写在函数外会报错；
#    · 一行可以声明多个：local a=1 b=2；
#    · 同名 local 会"遮蔽"外层变量，函数返回后外层原值不变。
# 3. 好习惯：函数内部所有变量都加 local，
#    尤其是循环变量、临时文件名、累加器。
# 4. 递归 = 函数自己调用自己，必须有两个要素：
#    · 终止条件（也叫出口），否则无限递归直到栈溢出；
#    · 每次调用都让问题规模变小（比如 n 减 1）。
#    bash 的递归有性能开销，只适合小规模计算。
# 5. 用 echo 返回值 + $( ) 捕获，是递归函数最方便的"传值"方式
#    （因为 return 只能带 0-255 的退出码）。
# 6. 库文件：把一堆函数写进单独的文件（只定义、不执行），
#    用时 source 进来即可，避免每个脚本都复制粘贴。
#    库文件里最好不要有 echo、不要依赖位置参数。
# 7. 查看某个名字是不是函数：type -t 名字，返回 function 就是函数。
# ------------------------------------------------------------

echo "===== 小节 1：不加 local 会污染全局变量 ====="
count=100                              # 全局变量
bad_func() {                           # 反面教材
    count=0                            # 没加 local，改的是全局 count
}
bad_func
echo "调用 bad_func 之后 count = $count（全局变量被改坏了）"

count=100                              # 重新设回 100
good_func() {
    local count=0                      # 加了 local，只在函数内有效
    echo "  函数内部的 count = $count"
}
good_func
echo "调用 good_func 之后 count = $count（全局变量安然无恙）"

echo
echo "===== 小节 2：local 的作用范围 ====="
msg="我是全局 msg"                      # 外层变量
demo_local() {
    local msg="我是函数内的 msg"        # 遮蔽外层同名变量
    echo "  函数内看到的 msg：$msg"
    local a=1 b=2                      # 一行声明多个局部变量
    echo "  函数内 a=$a b=$b"
    a=99                               # 修改的是局部变量
    echo "  修改后 a=$a"
}
demo_local
echo "函数外看到的 msg：$msg"
echo "函数外看不到 a：a=[${a:-未定义}]"
echo "（对比一下）msg 在函数内被 local 保护，外面完全没被影响"

echo
echo "===== 小节 3：递归求阶乘 ====="
factorial() {                          # 计算 n!
    local n=$1                         # 参数先存进局部变量
    if (( n <= 1 )); then              # 终止条件：0! 和 1! 都是 1
        echo 1                         # 直接返回 1
        return
    fi
    local sub                          # 局部变量存下一层的结果
    sub=$(factorial $((n - 1)))        # 递归调用：n-1 的阶乘
    echo $(( n * sub ))                # 本层结果 = n * 下一层结果
}
for n in 1 3 5 7; do
    echo "  $n! = $(factorial "$n")"
done

echo
echo "===== 小节 4：递归求斐波那契数列 ====="
fib() {                                # 第 n 个斐波那契数
    local n=$1
    if (( n < 2 )); then               # 出口：fib(0)=0，fib(1)=1
        echo "$n"
        return
    fi
    echo $(( $(fib $((n - 1))) + $(fib $((n - 2))) ))   # 前两项之和
}
echo -n "  数列前 8 项："
for i in 0 1 2 3 4 5 6 7; do
    echo -n "$(fib "$i") "
done
echo

echo
echo "===== 小节 5：递归遍历（用递归拆解问题） ====="
count_down() {                         # 倒计时
    local n=$1
    if (( n <= 0 )); then              # 终止条件
        echo "  发射！"
        return
    fi
    echo "  $n ..."
    count_down $((n - 1))              # 规模减 1 后继续
}
count_down 3

echo
echo "===== 小节 6：把函数写进库文件用 source 复用 ====="
libfile=$(mktemp)                      # 自建一个"函数库"文件
cat > "$libfile" <<'EOF'
# ===== 这是一个函数库文件：只有函数定义，不做任何动作 =====
log_info()  { echo "[INFO]  $*"; }     # $* 会把所有参数拼起来
log_warn()  { echo "[WARN]  $*"; }
log_error() { echo "[ERROR] $*"; }
to_upper()  { echo "$1" | tr 'a-z' 'A-Z'; }   # 转大写
repeat()    { local i; for ((i = 0; i < $2; i++)); do echo -n "$1"; done; echo; }
EOF
echo "库文件已创建：$libfile"
source "$libfile"                      # 把库加载进当前 shell
log_info "库文件加载成功"               # 直接调用库里的函数
log_warn "磁盘使用率偏高"
log_error "数据库连接失败"
echo "转大写结果：$(to_upper "hello shell")"
echo "重复输出："$(repeat "=" 20)
echo "type -t log_info 的结果：$(type -t log_info)  <-- function 说明它是函数"
rm -f "$libfile"                       # 清理库文件
echo "库文件已删除，但函数在当前 shell 里依然可用："
log_info "这就是 source 的威力"

# ------------------------------------------------------------
# 运行结果：
# ===== 小节 1：不加 local 会污染全局变量 =====
# 调用 bad_func 之后 count = 0（全局变量被改坏了）
#   函数内部的 count = 0
# 调用 good_func 之后 count = 100（全局变量安然无恙）
#
# ===== 小节 2：local 的作用范围 =====
#   函数内看到的 msg：我是函数内的 msg
#   函数内 a=1 b=2
#   修改后 a=99
# 函数外看到的 msg：我是全局 msg
# 函数外看不到 a：a=[未定义]
# （对比一下）msg 在函数内被 local 保护，外面完全没被影响
#
# ===== 小节 3：递归求阶乘 =====
#   1! = 1
#   3! = 6
#   5! = 120
#   7! = 5040
#
# ===== 小节 4：递归求斐波那契数列 =====
#   数列前 8 项：0 1 1 2 3 5 8 13 
#
# ===== 小节 5：递归遍历（用递归拆解问题） =====
#   3 ...
#   2 ...
#   1 ...
#   发射！
#
# ===== 小节 6：把函数写进库文件用 source 复用 =====
# 库文件已创建：/tmp/tmp.xxxxxxxx
# [INFO]  库文件加载成功
# [WARN]  磁盘使用率偏高
# [ERROR] 数据库连接失败
# 转大写结果：HELLO SHELL
# 重复输出：====================
# type -t log_info 的结果：function  <-- function 说明它是函数
# 库文件已删除，但函数在当前 shell 里依然可用：
# [INFO]  这就是 source 的威力
# ------------------------------------------------------------
