#!/bin/bash
# ============================================
# 序号: 14
# 主题: 条件组合与文件测试
# 难度: ★★☆
# 前置知识: 04 条件判断、06 数值比较与逻辑运算
# 学习目标: 掌握 -e -f -d -r -w -x -s -L 等文件测试与条件组合
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 脚本里经常要判断"这个文件在不在、是不是目录、能不能写"，
#    这些都用文件测试符完成，写法：[[ -f 路径 ]]。常用清单：
#      -e  存在（不管文件还是目录）
#      -f  存在且是普通文件
#      -d  存在且是目录
#      -r  存在且可读      -w  存在且可写      -x  存在且可执行
#      -s  存在且大小不为 0（-s 为真说明"有内容"）
#      -L  存在且是符号链接（软链接）
# 2. 判断"文件是否为空"最常用的组合：[[ -e 文件 && ! -s 文件 ]]
# 3. 组合条件三种方式：
#      · [[ -f a && -d b ]]      推荐，&& || ! 直接写
#      · [ -f a ] && [ -d b ]    两个独立判断用 && 串
#      · [ -f a -a -d b ]        老写法，-a 与、-o 或，容易看错，不推荐
# 4. 变量一定要加引号：[[ -f "$file" ]]，否则变量为空时语法会出错。
# 5. 测试符用在"路径不存在"时大多返回假（-e 本身除外，它就是测存在性），
#    不会报错，可以放心使用。
# 6. 本脚本用 mktemp -d 自建实验目录，结束时清理，无需外部文件。
# ------------------------------------------------------------

tmp=$(mktemp -d)                     # 自建实验目录
echo "实验目录：$tmp"
touch "$tmp/normal.txt"              # 普通文件
echo "有内容" > "$tmp/notempty.txt"  # 非空文件
: > "$tmp/empty.txt"                 # 空文件
mkdir "$tmp/mydir"                   # 目录
chmod +x "$tmp/normal.txt"           # 让它变成可执行文件
ln -s "$tmp/normal.txt" "$tmp/mylink"  # 创建一个软链接

echo
echo "===== 小节 1：-e 与 -f 判断存在性和文件类型 ====="
if [[ -e "$tmp/normal.txt" ]]; then echo "-e：normal.txt 存在"; fi
if [[ -f "$tmp/normal.txt" ]]; then echo "-f：normal.txt 是普通文件"; fi
if [[ ! -f "$tmp/mydir" ]]; then echo "! -f：mydir 不是普通文件"; fi
if [[ ! -e "$tmp/不存在.txt" ]]; then echo "! -e：不存在.txt 确实不存在"; fi

echo
echo "===== 小节 2：-d 判断目录 ====="
if [[ -d "$tmp/mydir" ]]; then echo "-d：mydir 是目录"; fi
if [[ ! -d "$tmp/normal.txt" ]]; then echo "! -d：normal.txt 不是目录"; fi
if [[ -d /tmp ]]; then echo "-d：系统目录 /tmp 也是目录"; fi

echo
echo "===== 小节 3：-r -w -x 判断权限 ====="
if [[ -r "$tmp/normal.txt" ]]; then echo "-r：normal.txt 可读"; fi
if [[ -w "$tmp/normal.txt" ]]; then echo "-w：normal.txt 可写"; fi
if [[ -x "$tmp/normal.txt" ]]; then echo "-x：normal.txt 可执行（刚给它加了执行权限）"; fi
if [[ ! -x "$tmp/mydir" ]]; then echo "! -x：mydir 现在不可执行"; fi

echo
echo "===== 小节 4：-s 判断文件是否为空 ====="
if [[ -s "$tmp/notempty.txt" ]]; then echo "-s：notempty.txt 有内容"; fi
if [[ ! -s "$tmp/empty.txt" ]]; then echo "! -s：empty.txt 是空文件"; fi
if [[ -e "$tmp/empty.txt" && ! -s "$tmp/empty.txt" ]]; then
    echo "组合判断：empty.txt 存在且为空"
fi

echo
echo "===== 小节 5：-L 判断符号链接 ====="
if [[ -L "$tmp/mylink" ]]; then echo "-L：mylink 是符号链接"; fi
if [[ ! -L "$tmp/normal.txt" ]]; then echo "! -L：normal.txt 不是链接"; fi

echo
echo "===== 小节 6：条件的组合写法 ====="
if [[ -f "$tmp/normal.txt" && -d "$tmp/mydir" ]]; then
    echo "[[ && ]]：文件和目录同时存在"
fi
if [[ -x "$tmp/normal.txt" || -x "$tmp/mydir" ]]; then
    echo "[[ || ]]：两者至少有一个可执行"
fi
[ -f "$tmp/normal.txt" ] && [ -d "$tmp/mydir" ] && echo "[ ] && [ ]：老式串联写法同样可行"
[ -f "$tmp/normal.txt" -a -d "$tmp/mydir" ] && echo "[ -a ]：老式写法（不推荐，但要知道）"

echo
echo "===== 小节 7：用文件测试做参数校验 ====="
check_file() {                       # 定义一个检查函数
    local f="$1"                     # 拿第一个参数，local 见第 22 课
    if [[ ! -e "$f" ]]; then
        echo "校验失败：$f 不存在"
    elif [[ -d "$f" ]]; then
        echo "校验结果：$f 是一个目录"
    elif [[ -s "$f" ]]; then
        echo "校验结果：$f 是普通文件，且有内容"
    else
        echo "校验结果：$f 是空文件"
    fi
}
check_file "$tmp/notempty.txt"       # 逐个测试
check_file "$tmp/empty.txt"
check_file "$tmp/mydir"
check_file "$tmp/根本不存在.txt"

rm -rf "$tmp"                        # 清理实验目录
echo
echo "实验目录已删除"

# ------------------------------------------------------------
# 运行结果（临时目录名每次不同）：
# 实验目录：/tmp/tmp.xxxxxxxx
#
# ===== 小节 1：-e 与 -f 判断存在性和文件类型 =====
# -e：normal.txt 存在
# -f：normal.txt 是普通文件
# ! -f：mydir 不是普通文件
# ! -e：不存在.txt 确实不存在
#
# ===== 小节 2：-d 判断目录 =====
# -d：mydir 是目录
# ! -d：normal.txt 不是目录
# -d：系统目录 /tmp 也是目录
#
# ===== 小节 3：-r -w -x 判断权限 =====
# -r：normal.txt 可读
# -w：normal.txt 可写
# -x：normal.txt 可执行（刚给它加了执行权限）
# ! -x：mydir 现在不可执行
#
# ===== 小节 4：-s 判断文件是否为空 =====
# -s：notempty.txt 有内容
# ! -s：empty.txt 是空文件
# 组合判断：empty.txt 存在且为空
#
# ===== 小节 5：-L 判断符号链接 =====
# -L：mylink 是符号链接
# ! -L：normal.txt 不是链接
#
# ===== 小节 6：条件的组合写法 =====
# [[ && ]]：文件和目录同时存在
# [[ || ]]：两者至少有一个可执行
# [ ] && [ ]：老式串联写法同样可行
# [ -a ]：老式写法（不推荐，但要知道）
#
# ===== 小节 7：用文件测试做参数校验 =====
# 校验结果：/tmp/tmp.xxxxxxxx/notempty.txt 是普通文件，且有内容
# 校验结果：/tmp/tmp.xxxxxxxx/empty.txt 是空文件
# 校验结果：/tmp/tmp.xxxxxxxx/mydir 是一个目录
# 校验失败：/tmp/tmp.xxxxxxxx/根本不存在.txt 不存在
#
# 实验目录已删除
# ------------------------------------------------------------
