#!/usr/bin/bash

echo "EXAMPLE INPUT (SCENARIO 1):"
awk -f monkey_business_no_overflow.awk example.txt

echo ""

echo "EXAMPLE INPUT (SCENARIO 1):"
awk -f monkey_business_no_overflow.awk input.txt

echo ""
echo ""

echo "EXAMPLE INPUT (SCENARIO 2):"
awk -f monkey_business.awk example.txt

echo ""

echo "EXAMPLE INPUT (SCENARIO 2):"
awk -f monkey_business.awk input.txt
