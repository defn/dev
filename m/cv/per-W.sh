#!/usr/bin/env bash

find fm/W -type f | cut -d/ -f3 | sort | while read -r a; do 
  echo $a 1>&2
  echo "<a href="W/$a.html"><img src=fm/W/$a></a>"
  ls fm/w-*/*-$a | sort | while read -r b; do 
    echo "<img src=../$b>"
  done > W/$a.html
done > W.html

