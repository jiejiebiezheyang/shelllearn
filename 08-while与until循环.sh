#!/bin/bash
# ============================================
# 序号: 08
# 主题: while / until 循环与 break/continue
# 难度: ★★☆
# 前置知识: 06 数值比较与逻辑运算、07 for 循环
# 学习目标: 掌握 while、until、逐行读取以及 break/continue 的用法
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. while：条件为"真"时反复执行循环体。
#      while 条件; do ...; done
#    写 while 时一定要保证循环体里有能让条件变假的语句，否则死循环。
# 2. until：和 while 正好相反，条件为"假"时反复执行，
#    条件一旦变真就退出。读起来像"一直做，直到……为止"。
# 3. 逐行读取文件的黄金写法：
#      while IFS= read -r line; do ... done < 文件
#    · IFS= 防止行首尾空格被吃掉
#    · -r 禁止反斜杠转义
#    · 也可以配 here-document（<<'EOF'）直接喂数据，无需外部文件
# 4. break：立刻结束整个循环（break 2 一次跳出两层）。
# 5. continue：跳过本轮剩下的语句，直接进入下一轮判断。
# 6. 无限循环写法：while true 或 while :，靠 break 退出。
# 7. 小技巧：管道后的 while 会在子 shell 中执行，循环里改的变量
#    出了循环就丢了；想保留结果用 while ... done < 文件 这种重定向写法。
# ------------------------------------------------------------

echo "===== 小节 1：while 基本用法 ====="
count=1                              # 计数器从 1 开始
while [ "$count" -le 3 ]; do         # 条件为真就一直循环
    echo "第 $count 次循环"
    count=$((count + 1))             # 别忘了让条件有变假的机会
done
echo "循环结束后 count = $count"

echo
echo "===== 小节 2：until 基本用法 ====="
n=1                                  # 同样从 1 开始
until [ "$n" -gt 3 ]; do             # 与 while 相反：条件为假才循环
    echo "until 第 $n 轮"
    n=$((n + 1))
done
echo "until 结束时 n = $n"

echo
echo "===== 小节 3：while read 逐行读取 ====="
while IFS= read -r line; do          # IFS= 和 -r 是逐行读取的标准配置
    echo "读到一行：[$line]"
done <<'EOF'                         # here-document 直接提供数据
第一行内容
   第二行前面有空格
第三行内容
EOF

echo
echo "===== 小节 4：while 累加求和 ====="
total=0                              # 累加器
i=1
while [ "$i" -le 5 ]; do
    total=$((total + i))             # 把当前 i 加进总和
    i=$((i + 1))
done
echo "1 到 5 的和是：$total"

echo
echo "===== 小节 5：break 与 continue ====="
i=0
while true; do                       # 无限循环，靠 break 退出
    i=$((i + 1))
    if [ "$i" -eq 3 ]; then
        echo "i = 3，continue 跳过本轮剩余语句"
        continue                     # 回到循环开头继续判断
    fi
    if [ "$i" -gt 5 ]; then
        echo "i 超过 5 了，break 结束循环"
        break                        # 直接跳出整个 while
    fi
    echo "  正常处理 i=$i"
done

echo
echo "===== 小节 6：break 2 跳出两层循环 ====="
for i in 1 2 3; do                   # 外层循环
    for j in a b c; do               # 内层循环
        if [ "$j" = "b" ]; then
            echo "遇到 i=$i j=$j，一次跳出两层"
            break 2                  # 数字表示要跳出的层数
        fi
        echo "  处理 i=$i j=$j"
    done
done

# ------------------------------------------------------------
# 运行结果：
# ===== 小节 1：while 基本用法 =====
# 第 1 次循环
# 第 2 次循环
# 第 3 次循环
# 循环结束后 count = 4
#
# ===== 小节 2：until 基本用法 =====
# until 第 1 轮
# until 第 2 轮
# until 第 3 轮
# until 结束时 n = 4
#
# ===== 小节 3：while read 逐行读取 =====
# 读到一行：[第一行内容]
# 读到一行：[   第二行前面有空格]
# 读到一行：[第三行内容]
#
# ===== 小节 4：while 累加求和 =====
# 1 到 5 的和是：15
#
# ===== 小节 5：break 与 continue =====
#   正常处理 i=1
#   正常处理 i=2
# i = 3，continue 跳过本轮剩余语句
#   正常处理 i=4
#   正常处理 i=5
# i 超过 5 了，break 结束循环
#
# ===== 小节 6：break 2 跳出两层循环 =====
#   处理 i=1 j=a
# 遇到 i=1 j=b，一次跳出两层
# ------------------------------------------------------------
