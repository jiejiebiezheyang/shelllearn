#!/bin/bash
# ============================================
# 序号: 29
# 主题: 批量重命名与整理脚本
# 难度: ★★★
# 前置知识: 15 字符串处理进阶、24 文件与目录批量操作
# 学习目标: 掌握干跑、统一后缀、空格换下划线、加前缀、按类型归档
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】
# 1. 批量重命名的第一原则：先干跑（dry-run），再真改。
#    干跑就是只 echo 出"将要执行什么"，不动任何文件；
#    确认清单没问题，再把 echo 换成 mv。
# 2. 拆解文件名的两个必备写法（第 15 课学过）：
#      base="${f%.*}"     去掉最后一个后缀 -> 只要主名
#      ext="${f##*.}"     取最后一个后缀
#      new="${f// /_}"    把文件名里的空格全换成下划线
#      "${ext,,}"         后缀转小写（bash 4+ 支持）
# 3. mv 的两个安全习惯：
#      · 用 mv -- "$f" "$new"，-- 之后的内容一律当成文件名，
#        防止文件名以 - 开头时被误认为选项；
#      · 变量一定加引号，否则文件名里的空格会把参数拆散。
# 4. 遍历文件不要用 for f in $(ls)！要用
#      mapfile -t files < <(find . -maxdepth 1 -type f -printf '%f\n' | sort)
#    这样能正确处理空格，而且顺序固定、输出可复现。
# 5. 批量归档：先用 case 判断后缀决定目标目录，再 mkdir -p + mv 进去。
#      case "$ext" in jpg|png) target="图片" ;; esac
# 6. 真实场景里日期前缀用 $(date +%Y%m%d)，本脚本用固定值，
#    这样每次运行的输出都一样，方便你对照。
# ------------------------------------------------------------

work=$(mktemp -d)                      # 自建实验目录
cd "$work" || exit 1                   # 进去操作，不碰你真实的其他文件

echo "===== 小节 1：准备一批「很脏」的文件名 ====="
touch "IMG_001.JPG" "IMG_002.JPG" "IMG_003.JPG"   # 后缀是大写
touch "beach photo.jpg"                            # 名字里带空格
touch "report final.txt"                           # 名字里带空格
touch "DATA.CSV"                                   # 又是大写后缀
echo "原始文件清单（顺序已排好，保证输出稳定）："
mapfile -t files < <(find . -maxdepth 1 -type f -printf '%f\n' | sort)
printf '  %s\n' "${files[@]}"

echo
echo "===== 小节 2：先干跑（只看不改） ====="
for f in "${files[@]}"; do             # 遍历刚才那个排好序的数组
    base="${f%.*}"                     # 去掉最后一个后缀
    ext="${f##*.}"                     # 取出最后一个后缀
    new="${base// /_}.${ext,,}"        # 空格换下划线 + 后缀转小写
    if [[ "$f" != "$new" ]]; then
        echo "  [将改名] $f  ->  $new"
    else
        echo "  [无需改] $f"
    fi
done
echo "（确认无误后再把 echo 换成 mv，这就是干跑的价值）"

echo
echo "===== 小节 3：真正执行改名 ====="
for f in "${files[@]}"; do
    base="${f%.*}"                     # 主名
    ext="${f##*.}"                     # 后缀
    new="${base// /_}.${ext,,}"        # 目标名字
    if [[ "$f" == "$new" ]]; then
        continue                       # 一样就跳过，省一次 mv
    fi
    mv -- "$f" "$new"                  # -- 防止文件名以 - 开头被当成选项
done
echo "改名后的清单："
mapfile -t files < <(find . -maxdepth 1 -type f -printf '%f\n' | sort)
printf '  %s\n' "${files[@]}"

echo
echo "===== 小节 4：统一加日期前缀 ====="
prefix="20240501"                      # 真实场景请写成 $(date +%Y%m%d)
for f in "${files[@]}"; do
    mv -- "$f" "${prefix}_${f}"        # 名字前面挂上日期
    echo "  $f  ->  ${prefix}_${f}"
done
echo "（加日期前缀后，同名文件再也不会互相覆盖）"

echo
echo "===== 小节 5：按文件类型自动归档 ====="
mapfile -t files < <(find . -maxdepth 1 -type f -printf '%f\n' | sort)
for f in "${files[@]}"; do
    ext="${f##*.}"                     # 看后缀决定去处
    case "$ext" in
        jpg|png|gif) target="图片" ;;   # 图片类
        csv|xlsx)    target="表格" ;;   # 表格类
        txt|md)      target="文档" ;;   # 文档类
        *)           target="其他" ;;   # 兜底
    esac
    mkdir -p "$target"                 # -p 保证目录不存在时自动创建
    mv -- "$f" "$target/"              # 移进对应目录
done
echo "归档结果："
for d in 图片 表格 文档; do
    if [[ -d "$d" ]]; then
        echo "  【$d】$(ls -1 "$d" | tr '\n' ' ')"
    fi
done

echo
echo "===== 小节 6：清理现场 ====="
echo "本次共处理了 $(find . -type f | wc -l) 个文件"
cd / && rm -rf "$work"                 # 回到安全目录再删实验目录
echo "实验目录已清理"
echo "提醒：真实环境里删之前一定要先看清单，重命名脚本是「不可撤销」的操作"

# ------------------------------------------------------------
# 运行结果：
# ===== 小节 1：准备一批「很脏」的文件名 =====
# 原始文件清单（顺序已排好，保证输出稳定）：
#   DATA.CSV
#   IMG_001.JPG
#   IMG_002.JPG
#   IMG_003.JPG
#   beach photo.jpg
#   report final.txt
#
# ===== 小节 2：先干跑（只看不改） =====
#   [将改名] DATA.CSV  ->  DATA.csv
#   [将改名] IMG_001.JPG  ->  IMG_001.jpg
#   [将改名] IMG_002.JPG  ->  IMG_002.jpg
#   [将改名] IMG_003.JPG  ->  IMG_003.jpg
#   [将改名] beach photo.jpg  ->  beach_photo.jpg
#   [将改名] report final.txt  ->  report_final.txt
# （确认无误后再把 echo 换成 mv，这就是干跑的价值）
#
# ===== 小节 3：真正执行改名 =====
# 改名后的清单：
#   DATA.csv
#   IMG_001.jpg
#   IMG_002.jpg
#   IMG_003.jpg
#   beach_photo.jpg
#   report_final.txt
#
# ===== 小节 4：统一加日期前缀 =====
#   DATA.csv  ->  20240501_DATA.csv
#   IMG_001.jpg  ->  20240501_IMG_001.jpg
#   IMG_002.jpg  ->  20240501_IMG_002.jpg
#   IMG_003.jpg  ->  20240501_IMG_003.jpg
#   beach_photo.jpg  ->  20240501_beach_photo.jpg
#   report_final.txt  ->  20240501_report_final.txt
# （加日期前缀后，同名文件再也不会互相覆盖）
#
# ===== 小节 5：按文件类型自动归档 =====
# 归档结果：
#   【图片】20240501_IMG_001.jpg 20240501_IMG_002.jpg 20240501_IMG_003.jpg 20240501_beach_photo.jpg 
#   【表格】20240501_DATA.csv 
#   【文档】20240501_report_final.txt 
#
# ===== 小节 6：清理现场 =====
# 本次共处理了 6 个文件
# 实验目录已清理
# 提醒：真实环境里删之前一定要先看清单，重命名脚本是「不可撤销」的操作
# ------------------------------------------------------------
