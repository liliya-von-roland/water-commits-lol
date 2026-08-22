#!/usr/bin/env bash
set -e
COUNT=${1:-10}
PREFIX=${2:-update}
AUTHOR="WeepingDogel"
EMAIL="weepingdogel@gmail.com"
DATE=${3:-$(date -v"-${RANDOM%365}d" +%Y-%m-%dT%H:%M:%S+0800)}
# 如果传入 "today"，用今天
if [[ "$3" == "today" ]]; then
  DATE=$(date +"%Y-%m-%dT%H:%M:%S+0800")
fi

echo "🚰 水 $COUNT 个 commit，前缀: $PREFIX"
echo "   日期: $DATE"
echo "   作者: $AUTHOR <$EMAIL>"

# 创建初始 commit（如果仓库为空）
if [[ $(git rev-list --all --count 2>/dev/null) -eq 0 ]]; then
  echo "# Water Commits 🚰" > README.md
  git add README.md
  DT=$(date -v"-100d" +%Y-%m-%dT%H:%M:%S+0800)
  GIT_AUTHOR_NAME="$AUTHOR" GIT_AUTHOR_EMAIL="$EMAIL" \
  GIT_COMMITTER_NAME="$AUTHOR" GIT_COMMITTER_EMAIL="$EMAIL" \
  GIT_AUTHOR_DATE="$DT" GIT_COMMITTER_DATE="$DT" \
  git commit -m "initial commit"
fi

MSGS=("update" "fix typo" "refactor" "chore" "wip" "temp" "debug" "fix bug" "merge" "asdf" "sync" "format" "cleanup")
for i in $(seq 1 $COUNT); do
  MSG="${PREFIX} ${MSGS[$(( RANDOM % ${#MSGS[@]} ))]}"
  
  FNAME="water_commit_${i}.txt"
  echo "commit $i: $MSG - by $AUTHOR" > "$FNAME"
  git add "$FNAME"
  
  GIT_AUTHOR_NAME="$AUTHOR" GIT_AUTHOR_EMAIL="$EMAIL" \
  GIT_COMMITTER_NAME="$AUTHOR" GIT_COMMITTER_EMAIL="$EMAIL" \
  GIT_AUTHOR_DATE="$DATE" GIT_COMMITTER_DATE="$DATE" \
  git commit -m "$MSG" >/dev/null 2>&1
  
  if (( i % 100 == 0 )); then
    echo "  🌊 $i/$COUNT ..."
  fi
done

# 水完删掉多余的文件
echo "  🧹 清理临时文件..."
git rm --cached water_commit_*.txt >/dev/null 2>&1
rm -f water_commit_*.txt
git commit -m "cleanup water files" >/dev/null 2>&1

echo ""
echo "✅ 完成！共 $COUNT 个 commit"
