#!/usr/bin/env bash
# 使用 agentfuture/.env 主号 PAT 推送本仓（勿提交 .env）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ENV_FILE:-/home/cx/agentfuture/.env}"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi
: "${CHENXI750328AI_GITHUB_USER:?设 CHENXI750328AI_GITHUB_USER}"
: "${CHENXI750328AI_GITHUB_PAT:?设 CHENXI750328AI_GITHUB_PAT}"
cd "$ROOT"
REMOTE="${1:-origin}"
BRANCH="${2:-$(git branch --show-current)}"
URL="https://${CHENXI750328AI_GITHUB_USER}:${CHENXI750328AI_GITHUB_PAT}@github.com/${CHENXI750328AI_GITHUB_USER}/neuromorphic-computing.git"
if ! git remote get-url "$REMOTE" &>/dev/null; then
  git remote add "$REMOTE" "https://github.com/${CHENXI750328AI_GITHUB_USER}/neuromorphic-computing.git"
fi
GIT_TERMINAL_PROMPT=0 git push "$URL" "HEAD:refs/heads/${BRANCH}"
