#!/usr/bin/env bash
# 把本仓 skills/ 下的 skill 软链到 Codex / Grok / pi 的用户级 skill 目录。
# 软链共享:cd 本仓 && git pull 一次,所有工具同步拿到最新(配合每日 GitHub Actions 同步)。
#
# 用法:
#   bash scripts/install-other-agents.sh            # 装全部(codex grok pi)
#   bash scripts/install-other-agents.sh codex pi   # 只装指定工具
#
# 注意:Grok Build 会自动读取已安装的 Claude Code 插件(零配置兼容)。
# 若你已通过 claude plugin install 安装本插件,可不装 grok 软链,避免同一 skill 被发现两次。
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

declare -A TARGETS=(
  [codex]="$HOME/.codex/skills"
  [grok]="$HOME/.grok/skills"
  [pi]="$HOME/.pi/agent/skills"
)

WANTED=("${@:-}")
if [ ${#WANTED[@]} -eq 0 ]; then
  WANTED=("${!TARGETS[@]}")
fi

for agent in "${WANTED[@]}"; do
  if [ -z "${TARGETS[$agent]+x}" ]; then
    echo "!! 未知目标: $agent(可选:${!TARGETS[*]})" >&2
    exit 1
  fi
done

for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_dir="${skill_dir%/}"
  name="$(basename "$skill_dir")"
  for agent in "${WANTED[@]}"; do
    dst="${TARGETS[$agent]}"
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
