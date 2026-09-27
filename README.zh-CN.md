<div align="center">

# 🐚 Shell 脚本从入门到进阶 · 30 讲

**一个知识点一个文件 · 每个示例都能跑 · 每份输出都验证过**

[![Bash][b-bash]][repo]
[![Platform][b-platform]][repo]
[![Lessons][b-lessons]][repo]
[![Dependencies][b-dep]][repo]
[![License][b-license]](LICENSE)

[![Stars][b-stars]][repo]
[![Forks][b-forks]][repo]
[![Issues][b-issues]][issues]
[![Last Commit][b-commit]][repo]
[![PRs Welcome][b-prs]][pulls]

[**简体中文**](README.zh-CN.md) · [English](README.md)

</div>

---

## 📖 这是什么

一份面向 **零基础到进阶** 的 Bash 脚本教程。把 Shell 脚本拆成 **30 个独立知识点**，一个文件只讲一件事，绝不混在一起。

每个文件都能直接跑起来：

```bash
bash 01-变量定义与使用.sh
```

**不需要任何外部文件** —— 需要读写的课程会在脚本内用 `mktemp` 自建临时目录，跑完自动清理，不留痕迹。

## ✨ 特点

| | |
|:--:|---|
| 🎯 **单一知识点** | 30 个文件，每个只讲一个概念，不贪多、不跑题 |
| ▶️ **开箱即跑** | 不依赖外部文件、不需要联网，`bash 文件名.sh` 直接出结果 |
| 📝 **全中文注释** | 逐行中文注释 + 文件底部粘贴**真实运行输出**，对照着看 |
| 🧱 **统一结构** | 每个文件都是「头部信息 → 知识点讲解 → 示例小节 → 运行结果」 |
| ✅ **实跑验证** | 30 个脚本全部通过语法检查和实际运行，注释里的输出就是真实输出 |

## 🚀 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/jiejiebiezheyang/shelllearn.git
cd shelllearn

# 2. 挑一课跑起来（脚本已带执行权限，两种方式都行）
bash 01-变量定义与使用.sh
./01-变量定义与使用.sh

# 3. 一口气全跑一遍
for f in *.sh; do echo "===== $f ====="; bash "$f"; done
```

> 💡 **最好的学法**：先看注释猜输出 → 运行验证 → 动手改几个变量再看输出怎么变。

## 📂 目录结构

```text
shelllearn/
├── README.md                      # English README（默认，GitHub 首页展示）
├── README.zh-CN.md                # 中文说明（本文件）
├── LICENSE                        # MIT License
├── 01-变量定义与使用.sh
├── 02-位置参数与特殊变量.sh
├── ...
└── 30-定时任务与cron综合案例.sh
```

## 📚 课程目录

### 🌱 基础篇（01 - 10）

| # | 主题 | 难度 | 学完你会 |
|:--:|:--|:--:|:--|
| 01 | [变量定义与使用](01-变量定义与使用.sh) | ★☆☆ | 用 `=` / `readonly` / `export` 定义变量，搞懂作用域 |
| 02 | [位置参数与特殊变量](02-位置参数与特殊变量.sh) | ★☆☆ | 取用 `$0 $1 $# $? $$ $@`，让脚本接收参数 |
| 03 | [字符串操作](03-字符串操作.sh) | ★☆☆ | 拼接、取长度、截取、替换、大小写转换 |
| 04 | [条件判断](04-条件判断.sh) | ★★☆ | 写出 `if/elif/else`，分清 `test`、`[ ]`、`[[ ]]` |
| 05 | [case 分支与模式匹配](05-case分支与模式匹配.sh) | ★★☆ | 用 `case` 加通配符替代一长串 `if` |
| 06 | [数值比较与逻辑运算](06-数值比较与逻辑运算.sh) | ★★☆ | 用 `-eq`、`-gt` 比大小，用逻辑运算符组合条件 |
| 07 | [for 循环](07-for循环.sh) | ★★☆ | 四种遍历写法：列表、范围、`seq`、C 风格 |
| 08 | [while 与 until 循环](08-while与until循环.sh) | ★★☆ | 条件循环、逐行读文件、`break` / `continue` |
| 09 | [数组基础](09-数组基础.sh) | ★★☆ | 定义数组、按值和下标遍历、增删改 |
| 10 | [函数定义与返回值](10-函数定义与返回值.sh) | ★★☆ | 定义函数、传参，用 `return` 和 `$( )` 返回结果 |

### 🌿 进阶篇（11 - 20）

| # | 主题 | 难度 | 学完你会 |
|:--:|:--|:--:|:--|
| 11 | [输入输出重定向](11-输入输出重定向.sh) | ★★☆ | 把输出写进文件、屏蔽报错、用 here-document 喂数据 |
| 12 | [管道与文本处理入门](12-管道与文本处理入门.sh) | ★★★ | 用管道串起 `grep` / `sed` / `awk` 处理文本 |
| 13 | [命令替换与算术运算](13-命令替换与算术运算.sh) | ★★☆ | `$( )` 取命令结果，`$(( ))` 做整数运算 |
| 14 | [条件组合与文件测试](14-条件组合与文件测试.sh) | ★★☆ | 判断文件是否存在、是目录、可读可写可执行 |
| 15 | [字符串处理进阶](15-字符串处理进阶.sh) | ★★★ | 用 `${var#}` `${var%}` 一刀切掉路径和后缀 |
| 16 | [命令行参数解析](16-命令行参数解析.sh) | ★★★ | 用 `getopts` 规范解析 `-u alice -p 8080 -v` |
| 17 | [读取用户输入](17-读取用户输入.sh) | ★★☆ | `read` 的提示、限时、隐藏、单字符与数组读取 |
| 18 | [退出码与错误处理](18-退出码与错误处理.sh) | ★★★ | `exit`、`set -euo pipefail`、`trap` 收尾清理 |
| 19 | [调试技巧](19-调试技巧.sh) | ★★☆ | `bash -n` / `bash -x` / `PS4` / `shellcheck` |
| 20 | [环境变量与配置文件](20-环境变量与配置文件.sh) | ★★☆ | `export`、`source`、`.bashrc` 与 `PATH` |

### 🚀 实战篇（21 - 30）

| # | 主题 | 难度 | 学完你会 |
|:--:|:--|:--:|:--|
| 21 | [数组进阶](21-数组进阶.sh) | ★★★ | 数组切片、复制合并、关联数组与词频统计 |
| 22 | [函数进阶](22-函数进阶.sh) | ★★★ | `local` 作用域、递归、用 `source` 复用函数库 |
| 23 | [流程控制综合](23-流程控制综合.sh) | ★★★ | 嵌套循环、`select` 菜单、状态机 |
| 24 | [文件与目录批量操作](24-文件与目录批量操作.sh) | ★★★ | `find` 精准筛选 + 安全的 `xargs` 批处理 |
| 25 | [文本处理进阶](25-文本处理进阶.sh) | ★★★ | `awk` 字段统计与 `sed` 分组替换、反向引用 |
| 26 | [日志分析与统计](26-日志分析与统计.sh) | ★★★ | 从原始日志一路生成完整的分析报告 |
| 27 | [系统信息采集](27-系统信息采集.sh) | ★★★ | 读 `/proc` 与系统命令，产出巡检报告 |
| 28 | [文件备份与压缩](28-文件备份与压缩.sh) | ★★★ | `tar` 打包、时间戳命名、轮转保留与恢复校验 |
| 29 | [批量重命名与整理](29-批量重命名与整理.sh) | ★★★ | 干跑、统一后缀、加日期前缀、按类型归档 |
| 30 | [定时任务与 cron 综合案例](30-定时任务与cron综合案例.sh) | ★★★ | crontab 语法、防重叠锁、cron 排错清单 |

## 🗺️ 学习路线

| 阶段 | 课程 | 目标 |
|:--:|:--:|:--|
| 第 1 步 | 01 → 06 | 会定义变量、会写判断，能写最简单的脚本 |
| 第 2 步 | 07 → 10 | 掌握循环、数组、函数，能写几十行的脚本 |
| 第 3 步 | 11 → 20 | 会用管道和文本三剑客，能读懂别人的脚本 |
| 第 4 步 | 21 → 30 | 独立写出日志分析、备份、批量处理等实用脚本 |

## 🧩 每个文件长什么样

所有文件结构完全统一，方便检索和复习：

```bash
#!/bin/bash
# ============================================
# 序号: 01
# 主题: 变量定义与使用
# 难度: ★☆☆
# 前置知识: 无
# 学习目标: 掌握 3 种变量定义方式与作用域
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】     ← 10 - 20 行，把一个知识点讲透
# ------------------------------------------------------------

echo "===== 小节 1：普通变量 ====="
name="小明"                    # 每一行都有中文注释
echo "姓名: $name"             # 说明这行在做什么

# ------------------------------------------------------------
# 运行结果：          ← 文件底部粘贴真实运行输出
# ===== 小节 1：普通变量 =====
# 姓名: 小明
# ------------------------------------------------------------
```

## ⚙️ 环境要求

| 项目 | 说明 |
|:--|:--|
| Shell | **bash 4.0+**。第 03、21、29 课用到 `${var^^}`、`declare -A`、`${ext,,}`，bash 4 以下不支持 |
| macOS 用户 | 系统自带的是 bash 3.2，建议 `brew install bash` |
| 系统命令 | `grep` `sed` `awk` `find` `xargs` `tar` `gzip`，Linux / macOS / WSL 均自带 |
| 可选工具 | [shellcheck](https://www.shellcheck.net/) —— 第 19 课会用到，没装也能正常跑，脚本会给出提示 |

## ❓ 常见问题

<details>
<summary><b>为什么 <code>read -p</code> 的提示语看不到？</b></summary>

<br>

`-p` 的提示语只在 **标准输入是终端** 时显示。脚本里用 `<<<` 或管道喂数据，输入不是终端，所以看不到提示语 —— 这是正常现象，第 17 课的注释里也专门说明了。

</details>

<details>
<summary><b>有几课的输出和我这里不一样？</b></summary>

<br>

第 13、20、27 课涉及日期、主机名、CPU / 内存 / 磁盘等信息，输出必然随机器变化，注释里已标注「随机器变化」。

其余课程的输出是完全固定的，可以逐行对照。

</details>

<details>
<summary><b>Windows 下能跑吗？</b></summary>

<br>

可以，用 WSL 或 Git Bash。注意保证脚本是 **LF** 换行（Git 用户可以设置 `git config core.autocrlf input`），否则会报 `\r: command not found`。

</details>

## 🤝 贡献

发现错误、有更好的例子、想补充新知识点，都欢迎提 Issue 或 PR：

```bash
git checkout -b feature/your-idea
git commit -m "feat: 补充 xxx 的例子"
git push origin feature/your-idea
```

提交前建议先跑一遍 `bash -n 文件名.sh` 和 `shellcheck 文件名.sh`。

## 📄 License

本项目采用 [MIT License](LICENSE) 授权，可自由用于学习、教学和二次创作。

## ⭐ Star History

<a href="https://star-history.com/#jiejiebiezheyang/shelllearn&Date">
  <img src="https://api.star-history.com/svg?repos=jiejiebiezheyang/shelllearn&type=Date" alt="Star History Chart" width="600">
</a>

---

<div align="center">

**如果这个项目对你有帮助，点个 ⭐ Star 就是最好的支持！**

Made with ❤️ for Shell beginners

</div>

<!-- ===== 徽章与链接定义 ===== -->

[repo]: https://github.com/jiejiebiezheyang/shelllearn
[issues]: https://github.com/jiejiebiezheyang/shelllearn/issues
[pulls]: https://github.com/jiejiebiezheyang/shelllearn/pulls

[b-bash]: https://img.shields.io/badge/Bash-4.0%2B-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white
[b-platform]: https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20WSL-1793D1?style=for-the-badge&logo=linux&logoColor=white
[b-lessons]: https://img.shields.io/badge/Lessons-30-FF6F00?style=for-the-badge&logo=bookstack&logoColor=white
[b-dep]: https://img.shields.io/badge/Dependencies-None-2EA44F?style=for-the-badge&logo=checkmarx&logoColor=white
[b-license]: https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge&logo=opensourceinitiative&logoColor=white
[b-stars]: https://img.shields.io/github/stars/jiejiebiezheyang/shelllearn?style=for-the-badge&logo=github&color=f5c542
[b-forks]: https://img.shields.io/github/forks/jiejiebiezheyang/shelllearn?style=for-the-badge&logo=github&color=8b949e
[b-issues]: https://img.shields.io/github/issues/jiejiebiezheyang/shelllearn?style=for-the-badge&logo=github&color=orange
[b-commit]: https://img.shields.io/github/last-commit/jiejiebiezheyang/shelllearn?style=for-the-badge&logo=git&color=blue
[b-prs]: https://img.shields.io/badge/PRs-welcome-brightgreen?style=for-the-badge&logo=github
