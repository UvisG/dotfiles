# mkdir + cd in one step
mkcd() {
  mkdir -p "$1" && cd "$1"
}
