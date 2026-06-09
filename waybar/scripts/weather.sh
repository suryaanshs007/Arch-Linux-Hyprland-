#!/bin/bash
# Grabs weather for your location natively without clutter
curl -s "wttr.in/?format=%c+%t" | xargs
