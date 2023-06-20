#!/usr/bin/bash

echo "ACTUAL INPUT (SCENARIO 1):"
awk -f crates.awk input.txt

echo "ACTUAL INPUT (SCENARIO 2):"
awk -f multiple_crates.awk input.txt
