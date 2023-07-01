#!/usr/bin/bash

echo "EXAMPLE INPUT:"
awk -f cathode_ray_tube.awk example.txt

echo ""

echo "ACTUAL INPUT:"
awk -f cathode_ray_tube.awk input.txt
