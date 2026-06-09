#!/bin/bash
zcroll -l 20 -d 0.3 -f "playerctl metadata --format '{{title}} - {{artist}}'" -e "echo ''" &
wait
