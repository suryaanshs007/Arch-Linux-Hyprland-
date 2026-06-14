#!/bin/zsh

# 1. Safe process locking: kill older copies of this script, ignore the current one ($$). I did this primarily because the 10 min loop would fail due to an anomalous override from the previous session
for pid in $(pgrep -f wallpaper_loop.sh); do
  if [ "$pid" != "$$" ]; then
    kill -9 "$pid" 2>/dev/null
  fi
done

DIR="$HOME/Wallpaper-Bank/wallpapers/"
INTERVAL=600

if ! pgrep -x "swww-daemon" >/dev/null; then
  swww-daemon &
  sleep 1
fi

while true; do
  # 3. Pull a random wallpaper (safely wrapped across lines)
  RANDOM_PIC=$(find "$DIR" -type f \( \
    -name "*.jpg" -o \
    -name "*.png" -o \
    -name "*.jpeg" -o \
    -name "*.webp" \
    \) | shuf -n 1)

  # 4. Apply the wallpaper with smooth wave transition (really cool transistion hehe )
  swww img "$RANDOM_PIC" \
    --transition-type wave \
    --transition-fps 60 \
    --transition-duration 2

  # 5. Generate colors dynamically via matugen (matugen automatically draws the colour pallete out of the current wallpaper, i dont wanna spend a year learning colour theory just to design a dynamic waybar)
  matugen image "$RANDOM_PIC" --source-color-index 1 -m dark -t scheme-vibrant --prefer saturation

  # 6. Refresh your Waybar styles (restart waybar to apply the new theme when the wallpaper changes)
  killall -SIGUSR2 waybar

  sleep $INTERVAL
done
