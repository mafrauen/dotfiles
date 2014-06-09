#!/bin/zsh
# https://gist.github.com/jpb0104/1051544

local DATE=$(date +"%Y-%m-%d")
local TIME=$(date +"%I.%M.%S")
local AMPM=$(date +"%p")
local FILENAME=Screen\ shot\ $DATE\ at\ $TIME\ $AMPM.png

local filepath="/Users/mfrauenholtz/screens/$FILENAME"
screencapture -i $filepath
if [[ -f $filepath  ]]; then
  up $filepath
fi

