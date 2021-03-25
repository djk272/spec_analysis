#!/bin/bash

echo "Running fl_cha_repro.sh ..."
sh fl_cha_repro.sh

echo "Running fl_lightcurve ..."
sh fl_lightcurve.sh

echo "Running fl_back7 ..."
sh fl_back7.sh

echo "Running fl_fluximage_new ..."
sh fl_fluximage_new.sh

echo "Running fl_bkchipreg77 ..."
sh fl_bkchipreg77.sh

echo "Running fl_fluximage_ccd_hard ..."
sh fl_fluximage_ccd_hard.sh   

echo "Running fl_hard_cornorm ..."
sh fl_hard_cornorm.sh

echo "Running fl_imgall_new ..."
sh fl_imgall_new.sh

echo "Running fl_wavedetect_new ..."
sh fl_wavedetect_new.sh

echo "Running python fl_dmfilth ..."
python fl_dmfilth.py

echo "Running fl_dmfilth ..."
sh fl_dmfilth.sh