#!/bin/bash
cd scripts/
nohup sudo sh ./controller_ecmp.sh &
cd ..
sudo python lib/mn_ft.py -i lib/teste -d results/  -p 0.03 -t 10 --ecmp --iperf
cd results/
rm -rf h9.out
sudo sh ./results.sh
cd ..
