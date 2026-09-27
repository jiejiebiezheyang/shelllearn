#!/bin/bash
# ============================================
# 序号: 12
# 主题: 管道与常用文本处理（grep/sed/awk 入门）
# 难度: ★★★
# 前置知识: 11 输入输出重定向
# 学习目标: 理解管道机制，会用 grep 过滤、sed 替换、awk 取列
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 管道符 | 把左边命令的"标准输出"直接接到右边命令的"标准输入"，
#    数据像流水一样传下去，所以叫"管道"。
#    注意：只传标准输出，左边命令的报错（stderr）不会进管道。
# 2. grep —— 按行过滤
#      grep 关键词 文件      grep -c 只数行数
#      grep -i 忽略大小写    grep -v 反向选择（不要匹配的行）
#      grep -n 显示行号      grep -E 用扩展正则
# 3. sed —— 流式编辑器，最常用的是替换
#      sed 's/旧/新/'     每行替换第一处
#      sed 's/旧/新/g'    每行替换全部（g = global）
#      sed -n '1,2p'      只打印第 1 到 2 行（-n 取消默认打印）
#      sed '/关键词/d'    删除匹配的行
# 4. awk —— 按"列"处理文本，默认以空格/Tab 分列，$1 是第一列，$0 是整行
#      awk '{print $1}'        打印第一列
#      awk '{print $2, $3}'    打印第二、三列
#      awk '/ERROR/ {print $1}'  先按行过滤再取列
#      awk -F: '{print $1}'    用 -F 指定分隔符
# 5. 组合套路：grep 过滤 -> awk 取列 -> sort 排序 -> uniq -c 计数，
#    这就是日志分析脚本的核心骨架（进阶见第 25、26 课）。
# ------------------------------------------------------------

datafile=$(mktemp)                   # 临时数据文件，脚本自带测试数据
cat > "$datafile" <<'EOF'
2024-01-01 INFO  用户登录成功 user=alice
2024-01-02 ERROR 数据库连接失败 db=mysql
2024-01-03 INFO  用户登出 user=bob
2024-01-04 WARN  磁盘使用率 85%
2024-01-05 ERROR 接口超时 api=/order
EOF

echo "===== 小节 1：管道的基本概念 ====="
printf 'a\nb\nc\n' | wc -l                    # printf 的输出直接喂给 wc
echo "上面这条管道统计出 3 行，中间没有产生任何临时文件"

echo
echo "===== 小节 2：grep 过滤 ====="
echo "-- 只留 ERROR 行 --"
grep 'ERROR' "$datafile"
echo "-- 只数 ERROR 行数：$(grep -c 'ERROR' "$datafile") --"
echo "-- 忽略大小写搜 error：$(grep -ic 'error' "$datafile") 行 --"
echo "-- -v 反向选择，去掉所有 INFO 行 --"
grep -v 'INFO' "$datafile"
echo "-- -n 显示行号 --"
grep -n 'WARN' "$datafile"

echo
echo "===== 小节 3：sed 替换与删行 ====="
echo "-- 把 ERROR 换成 错误（每行第一处） --"
sed 's/ERROR/错误/' "$datafile"
echo "-- 只打印第 1 到 2 行 --"
sed -n '1,2p' "$datafile"
echo "-- 删除含 WARN 的行 --"
sed '/WARN/d' "$datafile"

echo
echo "===== 小节 4：awk 取列 ====="
echo "-- 打印第一列（日期） --"
awk '{print $1}' "$datafile"
echo "-- 打印第二列和第三列 --"
awk '{print $2, $3}' "$datafile"
echo "-- 先过滤 ERROR，再取日期列 --"
awk '/ERROR/ {print $1}' "$datafile"
echo "-- 按 = 分割，取出 user=alice 的值 --"
awk -F'=' '/user=/ {print $2}' "$datafile"
echo "-- 统计行数 NR --"
awk 'END {print "总行数：" NR}' "$datafile"

echo
echo "===== 小节 5：把管道串起来 ====="
echo "-- 各日志级别出现次数（sort + uniq -c） --"
awk '{print $2}' "$datafile" | sort | uniq -c
echo "-- ERROR 一共有几条 --"
grep 'ERROR' "$datafile" | wc -l
echo "-- 取出所有 user= 的值 --"
awk -F'=' '/user=/ {print $2}' "$datafile" | tr '\n' ' '
echo

rm -f "$datafile"                    # 清理临时文件
echo "临时数据文件已删除"

# ------------------------------------------------------------
# 运行结果：
# ===== 小节 1：管道的基本概念 =====
# 3
# 上面这条管道统计出 3 行，中间没有产生任何临时文件
#
# ===== 小节 2：grep 过滤 =====
# -- 只留 ERROR 行 --
# 2024-01-02 ERROR 数据库连接失败 db=mysql
# 2024-01-05 ERROR 接口超时 api=/order
# -- 只数 ERROR 行数：2 --
# -- 忽略大小写搜 error：2 行 --
# -- -v 反向选择，去掉所有 INFO 行 --
# 2024-01-02 ERROR 数据库连接失败 db=mysql
# 2024-01-04 WARN  磁盘使用率 85%
# 2024-01-05 ERROR 接口超时 api=/order
# -- -n 显示行号 --
# 4:2024-01-04 WARN  磁盘使用率 85%
#
# ===== 小节 3：sed 替换与删行 =====
# -- 把 ERROR 换成 错误（每行第一处） --
# 2024-01-01 INFO  用户登录成功 user=alice
# 2024-01-02 错误 数据库连接失败 db=mysql
# 2024-01-03 INFO  用户登出 user=bob
# 2024-01-04 WARN  磁盘使用率 85%
# 2024-01-05 错误 接口超时 api=/order
# -- 只打印第 1 到 2 行 --
# 2024-01-01 INFO  用户登录成功 user=alice
# 2024-01-02 ERROR 数据库连接失败 db=mysql
# -- 删除含 WARN 的行 --
# 2024-01-01 INFO  用户登录成功 user=alice
# 2024-01-02 ERROR 数据库连接失败 db=mysql
# 2024-01-03 INFO  用户登出 user=bob
# 2024-01-05 ERROR 接口超时 api=/order
#
# ===== 小节 4：awk 取列 =====
# -- 打印第一列（日期） --
# 2024-01-01
# 2024-01-02
# 2024-01-03
# 2024-01-04
# 2024-01-05
# -- 打印第二列和第三列 --
# INFO 用户登录成功
# ERROR 数据库连接失败
# INFO 用户登出
# WARN 磁盘使用率
# ERROR 接口超时
# -- 先过滤 ERROR，再取日期列 --
# 2024-01-02
# 2024-01-05
# -- 按 = 分割，取出 user=alice 的值 --
# alice
# bob
# -- 统计行数 NR --
# 总行数：5
#
# ===== 小节 5：把管道串起来 =====
# -- 各日志级别出现次数（sort + uniq -c） --
#       2 ERROR
#       2 INFO
#       1 WARN
# -- ERROR 一共有几条 --
# 2
# -- 取出所有 user= 的值 --
# alice bob 
# 临时数据文件已删除
# ------------------------------------------------------------
