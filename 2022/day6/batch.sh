#!/usr/bin/bash

echo "EXAMPLE INPUT (SCENARIO 1):"
awk -f start_of_packet.awk example.txt

echo ""

echo "ACTUAL INPUT (SCENARIO 1):"
awk -f start_of_packet.awk input.txt

echo ""
echo ""

echo "ACTUAL INPUT (SCENARIO 2):"
awk -f start_of_message.awk input.txt
