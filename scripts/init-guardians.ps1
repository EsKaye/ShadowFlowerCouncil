$branches = 'guardian-athena','guardian-persephone','guardian-brigid','guardian-hecate','guardian-lilith'
foreach ($b in $branches) {
  git checkout -b $b
  New-Item -ItemType Directory -Force -Path guardians | Out-Null
  "# $($b -replace 'guardian-','')" | Set-Content "guardians/$b.md"
  git add "guardians/$b.md"
  git commit -m "chore($b): initialize branch"
  git push -u origin $b
}
git checkout main
