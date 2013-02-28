#!/bin/bash
python ../sizing/task1.py | tee sizes.txt | sed -e '/^[0-9]/p' -n | awk '{print ".param S"$1"_WN="$3" S"$1"_WP="$4}'
