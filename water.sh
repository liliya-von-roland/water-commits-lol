#!/usr/bin/env bash
set -e
COUNT=${1:-10}
PREFIX=${2:-update}
AUTHOR="WeepingDogel"
EMAIL="weepingdogel@gmail.com"

echo "🚰 水 $COUNT 个 commit，前缀: $PREFIX"
echo "   作者: $AUTHOR <$EMAIL>"

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
  DAYS_AGO=$(( RANDOM % 365 ))
  DT=$(date -v"-${DAYS_AGO}d" +%Y-%m-%dT%H:%M:%S+0800)
  MSG="${PREFIX} ${MSGS[$(( RANDOM % ${#MSGS[@]} ))]}"
  
  FNAME="water_commit_${i}.txt"
  echo "commit $i: $MSG - by $AUTHOR" > "$FNAME"
  git add "$FNAME"
  
  GIT_AUTHOR_NAME="$AUTHOR" GIT_AUTHOR_EMAIL="$EMAIL" \
  GIT_COMMITTER_NAME="$AUTHOR" GIT_COMMITTER_EMAIL="$EMAIL" \
  GIT_AUTHOR_DATE="$DT" GIT_COMMITTER_DATE="$DT" \
  git commit -m "$MSG" >/dev/null 2>&1
  
  if (( i % 100 == 0 )); then
    echo "  🌊 $i/$COUNT ..."
  fi
done
echo ""
echo "✅ 完成！共 $COUNT 个 commit"
