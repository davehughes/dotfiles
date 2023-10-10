kill-spotify () {
  kill -9 $(ps ax | ag Spotify | head -n 1 | awk -F" " '{print $1}')
}
