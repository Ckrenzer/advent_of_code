#!/usr/bin/bash

echo "EXAMPLE RESULTS (SCENARIO 1):"
awk -f rock_paper_scissors_scenario_1.awk example.txt

echo ""

echo "RESULTS FOR ACTUAL INPUT (SCENARIO 1):"
awk -f rock_paper_scissors_scenario_1.awk input.txt

echo ""
echo ""

echo "EXAMPLE RESULTS (SCENARIO 2):"
awk -f rock_paper_scissors_scenario_2.awk example.txt

echo ""

echo "RESULTS FOR ACTUAL INPUT (SCENARIO 2):"
awk -f rock_paper_scissors_scenario_2.awk input.txt

