#!/usr/bin/bash
for seq in $(seq 100)
do
    echo $seq
    radtest isedemolab ISEisC00L 192.168.102.106:1812 $seq ISEisC00L
done