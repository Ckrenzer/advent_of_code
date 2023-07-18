#!/usr/bin/bash

echo "EXAMPLE INPUT (SCENARIO 1):"
awk -f hill_climbing.awk example.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 1):"
awk -f hill_climbing.awk input.txt

echo ""
echo ""

echo "EXAMPLE INPUT (SCENARIO 2):"
awk -f starting_point.awk example.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 2):"
awk -f starting_point input.txt
