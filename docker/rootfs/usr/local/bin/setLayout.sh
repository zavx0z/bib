#!/bin/sh

setxkbmap -layout us -print | sed -e 's,\+inet[^+"]*,,' | xkbcomp - $DISPLAY 2>/dev/null

exit 0
