#!/bin/bash
# Double-click this file in Finder to start the MIDI Marker Tool.
# It starts a local web server (required — opening index.html directly
# via file:// blocks the fetches this app needs) and opens your browser.
cd "$(dirname "$0")"
PORT=8100

while lsof -i ":$PORT" -sTCP:LISTEN >/dev/null 2>&1; do
  PORT=$((PORT + 1))
done

echo "Starting MIDI Marker Tool at http://localhost:$PORT/index.html"
echo "Keep this window open while you use the app."
echo "Close this window (or press Ctrl+C) to stop it."
echo ""

(sleep 1 && open "http://localhost:$PORT/index.html") &
python3 -m http.server "$PORT"
