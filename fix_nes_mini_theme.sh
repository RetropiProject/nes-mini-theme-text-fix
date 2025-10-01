#!/bin/bash

FILE="/etc/emulationstation/themes/nes-mini/nesmini.xml"
POS_VALUE="0.2959 0.2035"
SIZE_VALUE="0.4085 0.6"

# Backup original file
cp "$FILE" "${FILE}.backup_$(date +%Y%m%d_%H%M%S)"

# Using awk to process the XML:
awk -v pos="$POS_VALUE" -v size="$SIZE_VALUE" '
  BEGIN {in_textlist=0; pos_done=0; size_done=0}
  {
    if ($0 ~ /<textlist name="gamelist">/) {
      in_textlist=1
    }

    if (in_textlist==1) {
      # Check if the line is <pos> and replace it
      if ($0 ~ /<pos>/) {
        print "  <pos>" pos "</pos>"
        pos_done=1
        next
      }
      # Check if the line is <size> and replace it
      if ($0 ~ /<size>/) {
        print "  <size>" size "</size>"
        size_done=1
        next
      }
      # Before closing textlist tag, insert missing tags if needed
      if ($0 ~ /<\/textlist>/) {
        if (pos_done==0) {
          print "  <pos>" pos "</pos>"
          pos_done=1
        }
        if (size_done==0) {
          print "  <size>" size "</size>"
          size_done=1
        }
        in_textlist=0
      }
    }

    print
  }
' "$FILE" > "${FILE}.tmp" && mv "${FILE}.tmp" "$FILE"
