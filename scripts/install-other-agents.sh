#!/usr/bin/env bash
# 把本仓 skills/ 下的 skill 软链到 pi 等工具的用户级 skill 目录。
# 软链共享:cd 本仓 && git pull 一次,所有工具同步拿到最新(配合每日 GitHub Actions 同步)。
#
# 用法:
#   bash scripts/install-other-agents.sh          # 默认装 pi
#   bash scripts/install-other-agents.sh pi grok  # 显式指定(pi grok)
#
# 注意:Codex 与 Grok 推荐 plugin 形态安装(见 README),不要再用软链,避免同一 skill 被发现两次:
#   codex plugin marketplace add FlameMida/frontend-standards && codex plugin add frontend-standards@flame-standards
#   grok plugin install https://github.com/FlameMida/frontend-standards.git --trust
# Grok 也会自动读取已安装的 Claude Code 插件(零配置兼容)。
# 兼容 macOS 自带 bash 3.2,不使用 associative array。
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

agent_dir() {
  case "$1" in
    pi)    echo "$HOME/.pi/agent/skills" ;;
    codex) echo "$HOME/.codex/skills" ;;
    grok)  echo "$HOME/.grok/skills" ;;
    *)     return 1 ;;
  esac
}

if [ $# -eq 0 ]; then
  set -- pi
fi

for agent in "$@"; do
  if ! agent_dir "$agent" >/dev/null 2>&1; then
    echo "!! 未知目标: $agent(可选:codex grok pi)" >&2
    exit 1
  fi
done

for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_dir="${skill_dir%/}"
  name="$(basename "$skill_dir")"
  for agent in "$@"; do
    dst="$(agent_dir "$agent")"
    mkdir -p "$dst"
    if [ -e "$dst/$name" ] && [ ! -L "$dst/$name" ]; then
      echo "!! 跳过 $agent/$name:目标已存在且不是软链(请手动处理)"
      continue
    fi
    ln -sfn "$skill_dir" "$dst/$name"
    echo ">> $agent: $name -> $skill_dir"
  done
done

echo "完成。日常更新: cd $REPO_DIR && git pull"
