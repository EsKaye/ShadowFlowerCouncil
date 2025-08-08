#!/usr/bin/env bash
set -e
for b in guardian-athena guardian-persephone guardian-brigid guardian-hecate guardian-lilith; do
  git checkout -b "$b"
  mkdir -p guardians
  echo "# ${b#guardian-}" > "guardians/${b}.md"
  git add guardians/${b}.md
  git commit -m "chore($b): initialize branch"
  git push -u origin "$b"
done
git checkout main
