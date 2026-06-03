$ErrorActionPreference = "Stop"
$RepoName = "noesis-codex-ufs5qymk"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
gh auth status | Out-Null
$User = (gh api user --jq ".login").Trim()
Push-Location $Root
try {
  if (-not (Test-Path ".git")) { git init; git branch -M main }
  git config user.name "takosuke0215"
  git config user.email "takosuke0215@gmail.com"
  git add .
  git commit -m "Publish NOESIS official codex" 2>$null
  gh repo view "$User/$RepoName" *> $null
  if ($LASTEXITCODE -ne 0) { gh repo create "$RepoName" --public --description "NOESIS official setting site" --source "." --remote origin --push } else { git remote remove origin 2>$null; git remote add origin "https://github.com/$User/$RepoName.git"; git push -u origin main }
  gh api --method POST "repos/$User/$RepoName/pages" -f source.branch="main" -f source.path="/" 2>$null
  if ($LASTEXITCODE -ne 0) { gh api --method PUT "repos/$User/$RepoName/pages" -f source.branch="main" -f source.path="/" }
  "https://$User.github.io/$RepoName/"
}
finally { Pop-Location }
