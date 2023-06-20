#!/usr/bin/bash

echo "EXAMPLE RESULTS (SCENARIO 1):"
awk -f rucksack_priority.awk example.txt

echo ""

echo "RESULTS FOR ACTUAL INPUT (SCENARIO 1):"
awk -f rucksack_priority.awk input.txt

echo ""
echo ""

echo "EXAMPLE RESULTS (SCENARIO 2):"
awk -f elf_badges.awk example.txt

echo ""

echo "RESULTS FOR ACTUAL INPUT (SCENARIO 2):"
awk -f elf_badges.awk input.txt
