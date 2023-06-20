#!/usr/bin/bash

echo "EXAMPLE INPUT (SCENARIO 1):"
awk -f total_overlap.awk example.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 1):"
awk -f total_overlap.awk input.txt

echo ""
echo ""

echo "EXAMPLE INPUT (SCENARIO 2):"
awk -f overlap.awk example.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 2):"
awk -f overlap.awk input.txt
