#!/usr/bin/env bash
# 从官方上游同步 4 个前端 skill 到 skills/ 目录。
# 镜像语义:rsync --delete,上游删除的文件本地同样删除;skills/ 勿手改。
# 用法: bash scripts/sync.sh   (幂等,本地可随时重跑)
set -euo pipefail
cd "$(dirname "$0")/.."

# 映射:repo|branch|src(仓内路径)|dst(本仓路径)
UPSTREAMS=(
  "vercel-labs/agent-skills|main|skills/react-best-practices|skills/vercel-react-best-practices"
  "vercel-labs/agent-skills|main|skills/composition-patterns|skills/vercel-composition-patterns"
  "feature-sliced/skills|master|feature-sliced-design|skills/feature-sliced-design"
  "vercel/turborepo|main|skills/turborepo|skills/turborepo"
)

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
: > UPSTREAM.lock

for entry in "${UPSTREAMS[@]}"; do
  IFS='|' read -r repo branch src dst <<< "$entry"
  key="${repo//\//-}"
  if [ ! -d "$WORK/$key" ]; then
    echo ">> clone $repo (branch $branch)"
    git clone --quiet --depth 1 --branch "$branch" "https://github.com/$repo.git" "$WORK/$key"
  fi
  if [ ! -d "$WORK/$key/$src" ]; then
    echo "!! 上游路径不存在: $repo:$src(上游可能已移动/重命名,请更新脚本内 UPSTREAMS 映射)" >&2
    exit 1
  fi
  mkdir -p "$dst"
  rsync -a --delete "$WORK/$key/$src/" "$dst/"
  sha="$(git -C "$WORK/$key" rev-parse HEAD)"
  echo "$repo@$branch $sha" >> UPSTREAM.lock
done

echo ">> 同步完成,上游版本:"
cat UPSTREAM.lock
