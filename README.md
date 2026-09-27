<div align="center">

# 🐚 Shell Scripting: From Beginner to Advanced · 30 Lessons

**One concept per file · Every example runs · Every output is verified**

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

[简体中文](README.zh-CN.md) · [**English**](README.md)

</div>

---

## 📖 What Is This

A hands-on **Bash scripting tutorial** that takes you from zero to writing real automation scripts. Shell scripting is broken down into **30 self-contained lessons** — one concept per file, never mixed together.

Every lesson runs as-is:

```bash
bash 01-变量定义与使用.sh
```

**No external files required** — lessons that read or write files create their own temporary directories with `mktemp` and clean up after themselves.

> 📌 The comments and explanations inside the scripts are written in **Chinese**.
> The code itself is plain, portable Bash and reads fine on its own; the tables below summarize what each lesson teaches.

## ✨ Highlights

| | |
|:--:|---|
| 🎯 **One concept per file** | 30 files, each focused on a single idea — no overload |
| ▶️ **Runs out of the box** | No external files, no network — just `bash <file>.sh` |
| 📝 **Line-by-line comments** | Every command is annotated, with the *real* output pasted at the bottom |
| 🧱 **Consistent structure** | Header → concepts → example sections → expected output |
| ✅ **Actually verified** | All 30 scripts syntax-checked and executed; the documented output is the real output |

## 🚀 Quick Start

```bash
# 1. Clone
git clone https://github.com/jiejiebiezheyang/shelllearn.git
cd shelllearn

# 2. Run any lesson (files are already executable)
bash 01-变量定义与使用.sh
./01-变量定义与使用.sh

# 3. Run them all
for f in *.sh; do echo "===== $f ====="; bash "$f"; done
```

> 💡 **Best way to learn:** guess the output from the comments → run it → change a few values and watch what happens.

## 📂 Project Layout

```text
shelllearn/
├── README.md                      # English README (this file, repo home page)
├── README.zh-CN.md                # Chinese README · 中文说明
├── LICENSE                        # MIT License
├── 01-变量定义与使用.sh
├── 02-位置参数与特殊变量.sh
├── ...
└── 30-定时任务与cron综合案例.sh
```

## 📚 Lesson Index

### 🌱 Basics (01 – 10)

| # | Topic | Level | What you'll learn |
|:--:|:--|:--:|:--|
| 01 | [Variables](01-变量定义与使用.sh) | ★☆☆ | Define variables with `=`, `readonly`, `export` and understand scope |
| 02 | [Positional & Special Parameters](02-位置参数与特殊变量.sh) | ★☆☆ | Use `$0 $1 $# $? $$ $@` to accept arguments |
| 03 | [String Operations](03-字符串操作.sh) | ★☆☆ | Concatenate, measure, slice, replace, change case |
| 04 | [Conditionals](04-条件判断.sh) | ★★☆ | Write `if/elif/else`; know when to use `test`, `[ ]`, `[[ ]]` |
| 05 | [case & Pattern Matching](05-case分支与模式匹配.sh) | ★★☆ | Replace long `if` chains with `case` and glob patterns |
| 06 | [Numeric Comparison & Logic](06-数值比较与逻辑运算.sh) | ★★☆ | Compare numbers with `-eq` `-gt`, combine conditions with `(( ))` |
| 07 | [for Loops](07-for循环.sh) | ★★☆ | Four iteration styles: lists, ranges, `seq`, C-style |
| 08 | [while / until Loops](08-while与until循环.sh) | ★★☆ | Conditional loops, reading files line by line, `break` / `continue` |
| 09 | [Arrays Basics](09-数组基础.sh) | ★★☆ | Define arrays, iterate by value and index, add and remove |
| 10 | [Functions](10-函数定义与返回值.sh) | ★★☆ | Parameters, `return` exit codes, returning strings via `$( )` |

### 🌿 Intermediate (11 – 20)

| # | Topic | Level | What you'll learn |
|:--:|:--|:--:|:--|
| 11 | [Redirection](11-输入输出重定向.sh) | ★★☆ | `>` `>>` `<` `2>` `2>&1`, `/dev/null`, here-documents |
| 12 | [Pipes & Text Tools](12-管道与文本处理入门.sh) | ★★★ | Pipe data through `grep`, `sed` and `awk` |
| 13 | [Command Substitution & Math](13-命令替换与算术运算.sh) | ★★☆ | Capture output with `$( )`, do integer math with `$(( ))` |
| 14 | [File Tests & Combined Conditions](14-条件组合与文件测试.sh) | ★★☆ | `-e -f -d -r -w -x -s -L` and how to combine them |
| 15 | [Advanced String Handling](15-字符串处理进阶.sh) | ★★★ | Trim paths and suffixes with `${var#}` `${var##}` `${var%}` `${var%%}` |
| 16 | [Argument Parsing](16-命令行参数解析.sh) | ★★★ | Parse flags and options properly with `getopts` |
| 17 | [Reading User Input](17-读取用户输入.sh) | ★★☆ | `read` with `-p`, `-t`, `-s`, `-n` and array input |
| 18 | [Exit Codes & Error Handling](18-退出码与错误处理.sh) | ★★★ | `exit`, `set -euo pipefail`, `trap` for cleanup |
| 19 | [Debugging](19-调试技巧.sh) | ★★☆ | `bash -n`, `bash -x`, custom `PS4`, `shellcheck` |
| 20 | [Environment & Config Files](20-环境变量与配置文件.sh) | ★★☆ | `export`, `source`, `.bashrc` and `PATH` |

### 🚀 In Practice (21 – 30)

| # | Topic | Level | What you'll learn |
|:--:|:--|:--:|:--|
| 21 | [Arrays Advanced](21-数组进阶.sh) | ★★★ | Slicing, copying, associative arrays, word counting |
| 22 | [Functions Advanced](22-函数进阶.sh) | ★★★ | `local` scope, recursion, reusable function libraries |
| 23 | [Control Flow in Practice](23-流程控制综合.sh) | ★★★ | Nested loops, `select` menus, state machines |
| 24 | [Batch File Operations](24-文件与目录批量操作.sh) | ★★★ | Precise `find` filters and safe `xargs` usage |
| 25 | [Text Processing Advanced](25-文本处理进阶.sh) | ★★★ | `awk` fields and stats, `sed` groups and back-references |
| 26 | [Log Analysis Script](26-日志分析与统计.sh) | ★★★ | Turn a raw log into a complete analysis report |
| 27 | [System Info Collector](27-系统信息采集.sh) | ★★★ | Read `/proc` and system commands into a health report |
| 28 | [Backup & Archive Script](28-文件备份与压缩.sh) | ★★★ | `tar` archives, timestamps, rotation, restore verification |
| 29 | [Batch Rename & Organize](29-批量重命名与整理.sh) | ★★★ | Dry-run, normalize extensions, add prefixes, sort by type |
| 30 | [Cron in Practice](30-定时任务与cron综合案例.sh) | ★★★ | crontab syntax, overlap lock, troubleshooting checklist |

## 🗺️ Suggested Learning Path

| Stage | Lessons | Goal |
|:--:|:--:|:--|
| Step 1 | 01 → 06 | Define variables, write conditions, build the simplest scripts |
| Step 2 | 07 → 10 | Loops, arrays and functions — write scripts of a few dozen lines |
| Step 3 | 11 → 20 | Pipes and text tools — read and understand other people's scripts |
| Step 4 | 21 → 30 | Build real tools: log analysis, backups, batch processing |

## 🧩 Anatomy of a Lesson File

Every file follows exactly the same structure, which makes reviewing easy:

```bash
#!/bin/bash
# ============================================
# 序号: 01              <- Lesson number
# 主题: 变量定义与使用    <- Topic
# 难度: ★☆☆             <- Difficulty
# 前置知识: 无           <- Prerequisites
# 学习目标: ...          <- Learning objective
# ============================================

# ------------------------------------------------------------
# 【知识点讲解】          <- 10-20 lines explaining the concept
# ------------------------------------------------------------

echo "===== 小节 1：普通变量 ====="
name="小明"                    # every line carries a Chinese comment
echo "姓名: $name"

# ------------------------------------------------------------
# 运行结果：             <- the real output, pasted at the bottom
# ===== 小节 1：普通变量 =====
# 姓名: 小明
# ------------------------------------------------------------
```

## ⚙️ Requirements

| Item | Notes |
|:--|:--|
| Shell | **bash 4.0+**. Lessons 03, 21 and 29 use `${var^^}`, `declare -A`, `${ext,,}`, which need bash 4 or newer |
| macOS users | The system bash is 3.2 — install a newer one with `brew install bash` |
| Utilities | `grep` `sed` `awk` `find` `xargs` `tar` `gzip` — all ship with Linux / macOS / WSL |
| Optional | [shellcheck](https://www.shellcheck.net/) — used in lesson 19; everything still runs without it |

## ❓ FAQ

<details>
<summary><b>Why can't I see the <code>read -p</code> prompt?</b></summary>

<br>

The `-p` prompt is only printed when **stdin is a terminal**. The scripts feed input via `<<<` or a pipe, so the prompt is suppressed — that is expected behaviour, and lesson 17 explains it in detail.

</details>

<details>
<summary><b>A few lessons printed different output on my machine?</b></summary>

<br>

Lessons 13, 20 and 27 involve dates, hostnames, CPU / memory / disk figures, so the output necessarily varies per machine — the comments mark those lines as machine-dependent.

Every other lesson produces fully deterministic output you can compare line by line.

</details>

<details>
<summary><b>Does it work on Windows?</b></summary>

<br>

Yes — use WSL or Git Bash. Make sure the scripts keep **LF** line endings (Git users can set `git config core.autocrlf input`), otherwise you'll see `\r: command not found`.

</details>

## 🤝 Contributing

Bug reports, better examples and new topics are all welcome:

```bash
git checkout -b feature/your-idea
git commit -m "feat: add an example for xxx"
git push origin feature/your-idea
```

Before submitting, please run `bash -n <file>.sh` and `shellcheck <file>.sh`.

## 📄 License

Released under the [MIT License](LICENSE) — free to use for learning, teaching and derivative work.

## ⭐ Star History

<a href="https://star-history.com/#jiejiebiezheyang/shelllearn&Date">
  <img src="https://api.star-history.com/svg?repos=jiejiebiezheyang/shelllearn&type=Date" alt="Star History Chart" width="600">
</a>

---

<div align="center">

**If this project helps you, a ⭐ Star is the best way to say thanks!**

Made with ❤️ for Shell beginners

</div>

<!-- ===== Badge & link definitions ===== -->

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
