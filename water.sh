#!/usr/bin/env bash
set -euo pipefail

COUNT=${1:-10}
PREFIX=${2:-update}
WHEN=${3:-}

# 作者信息不再写死。优先环境变量，其次 git config。
# （原来写死成仓库主人，等于大家一起帮他水，好人一生平安）
AUTHOR=${WATER_AUTHOR:-$(git config user.name || true)}
EMAIL=${WATER_EMAIL:-$(git config user.email || true)}

if [[ -z "$AUTHOR" || -z "$EMAIL" ]]; then
  echo "❌ 没有作者信息。" >&2
  echo "   请先 git config user.name / user.email，" >&2
  echo "   或用 WATER_AUTHOR / WATER_EMAIL 环境变量指定。" >&2
  exit 1
fi

# 跨平台日期：GNU date (Linux) 用 -d，BSD date (macOS) 用 -v。
# 原来只有 -v，在 Linux 上直接 date: invalid option -- v 然后 set -e 退出。
# 用 --version 判断家族：GNU date 有，BSD date 没有。
# （不能拿 -d 去试探，BSD 的 -d 是设置夏令时的，会误判。）
if date --version >/dev/null 2>&1; then
  DATE_FLAVOR=gnu
else
  DATE_FLAVOR=bsd
fi

days_ago() {
  local days=$1
  if [[ "$DATE_FLAVOR" == "gnu" ]]; then
    date -d "-${days} days" +%Y-%m-%dT%H:%M:%S%z
  else
    date -v"-${days}d" +%Y-%m-%dT%H:%M:%S%z
  fi
}

if [[ "$WHEN" == "today" ]]; then
  DATE=$(days_ago 0)
elif [[ -n "$WHEN" ]]; then
  DATE="$WHEN"
else
  # 原来是 ${RANDOM%365}，那是「去掉结尾的 365」的字符串截断，不是取模，
  # 所以能水到八十多年前去，跟 README 说的「过去 365 天」对不上。
  DATE=$(days_ago $(( RANDOM % 365 )))
fi

echo "🚰 水 $COUNT 个 commit，前缀: $PREFIX"
echo "   日期: $DATE"
echo "   作者: $AUTHOR <$EMAIL>"

water_commit() {
  GIT_AUTHOR_NAME="$AUTHOR" GIT_AUTHOR_EMAIL="$EMAIL" \
  GIT_COMMITTER_NAME="$AUTHOR" GIT_COMMITTER_EMAIL="$EMAIL" \
  GIT_AUTHOR_DATE="$2" GIT_COMMITTER_DATE="$2" \
  git commit -q -m "$1"
}

# 创建初始 commit（如果仓库为空）
if [[ $(git rev-list --all --count 2>/dev/null || echo 0) -eq 0 ]]; then
  echo "# Water Commits 🚰" > README.md
  git add README.md
  water_commit "initial commit" "$(days_ago 100)"
fi

MSGS=("update" "fix typo" "refactor" "chore" "wip" "temp" "debug" "fix bug" "merge" "asdf" "sync" "format" "cleanup")
for i in $(seq 1 "$COUNT"); do
  MSG="${PREFIX} ${MSGS[$(( RANDOM % ${#MSGS[@]} ))]}"

  FNAME="water_commit_${i}.txt"
  echo "commit $i: $MSG - by $AUTHOR" > "$FNAME"
  git add "$FNAME"
  water_commit "$MSG" "$DATE"

  if (( i % 100 == 0 )); then
    echo "  🌊 $i/$COUNT ..."
  fi
done

# 水完删掉多余的文件。
# 原来这里 git rm 失败会被 set -e 干掉，现在先看看有没有东西可删。
if [[ -n "$(git ls-files "water_commit_*.txt")" ]]; then
  echo "  🧹 清理临时文件..."
  git rm --cached -q water_commit_*.txt
  rm -f water_commit_*.txt
  water_commit "cleanup water files" "$DATE"
fi

echo ""
echo "✅ 完成！共 $COUNT 个 commit"
