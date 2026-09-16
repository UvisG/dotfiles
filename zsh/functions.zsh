# mkdir + cd in one step
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Current git branch (or short commit SHA in detached HEAD), with a red dot
# appended when the working tree has uncommitted changes. Shown in PROMPT
# (see exports.zsh). Silent - no output - outside a git repo, same
# "invisible unless relevant" style as kube_ps1.
git_ps1() {
  local branch
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || branch=$(git rev-parse --short HEAD 2>/dev/null) || return
  local dirty=""
  [ -n "$(git status --porcelain 2>/dev/null)" ] && dirty=" %F{red}●%f"
  echo "%F{cyan}${branch}%f${dirty} "
}
