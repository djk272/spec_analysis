#!/bin/bash

echo "Running fl_cha_repro.sh ..."
. fl_cha_repro.sh

echo "Running fl_lightcurve ..."
. fl_lightcurve.sh

echo "Running fl_back7 ..."
. fl_back7.sh

echo "Running fl_fluximage_new ..."
. fl_fluximage_new.sh

echo "Running fl_bkchipreg77 ..."
. fl_bkchipreg77.sh

echo "Running fl_fluximage_ccd_hard ..."
. fl_fluximage_ccd_hard.sh   

echo "Running fl_hard_cornorm ..."
. fl_hard_cornorm.sh

echo "Running fl_imgall_new ..."
. fl_imgall_new.sh

echo "Running fl_wavedetect_new ..."
. fl_wavedetect_new.sh

echo "Running python fl_dmfilth ..."
python fl_dmfilth.py

echo "Running fl_dmfilth ..."
. fl_dmfilth.sh