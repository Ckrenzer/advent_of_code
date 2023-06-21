#!/usr/bin/bash

echo "EXAMPLE INPUT (SCENARIO 1):"
awk -f visible_tree_counts.awk example.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 1):"
awk -f visible_tree_counts.awk input.txt

echo ""
echo ""

echo "EXAMPLE INPUT (SCENARIO 2):"
awk -f tree_scenic_score.awk example.txt

echo "ACTUAL INPUT (SCENARIO 2):"
awk -f tree_scenic_score.awk input.txt
