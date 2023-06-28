#!/usr/bin/bash

echo "EXAMPLE INPUT (SCENARIO 1):"
awk -f knot_grid.awk example.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 1):"
awk -f knot_grid.awk input.txt

echo ""
echo ""

echo "EXAMPLE INPUT 1 (SCENARIO 2)"
awk -f multiple_knots.awk example.txt

echo ""

echo "SECOND EXAMPLE INPUT 2 (SCENARIO 2)"
awk -f multiple_knots.awk example2.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 2)"
awk -f multiple_knots.awk input.txt
