#!/usr/bin/bash

echo "EXAMPLE INPUT:"
awk -f directory_sizes.awk example.txt

echo ""

echo "ACTUAL INPUT:"
awk -f directory_sizes.awk input.txt
