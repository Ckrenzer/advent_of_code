#!/usr/bin/bash

echo "EXAMPLE RESULTS:"
awk -f awk/most_calories.awk example.txt

echo ""

echo "RESULTS FOR ACTUAL INPUT:"
awk -f awk/most_calories.awk input.txt
