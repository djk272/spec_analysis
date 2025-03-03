#!/usr/bin/env sh
#source $HOME/spec_analysis/ciao-4.12/bin/ciao.sh && exec "$@"
exec "$@"

echo "preparing data for analysis..."

echo "list the names of the observation directories as individual rows in the file flares.dat..."
bash write_to_flares.sh #list the names of the observation directors as individual rows in the file "flares.dat"
echo "DONE"

echo "copy obsv dirs to data_prep dir..."
cp -r /home/heasoft/spec_analysis/data/* /home/heasoft/spec_analysis/data_prep #copy obsv dirs to data_prep dir
echo "DONE"

echo "python version before ciao..."
python -V

echo "Starting CIAO..."
. ~/spec_analysis/ciao-4.12/bin/ciao.sh
echo "DONE"

echo "running pip install..."
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo "python version after ciao..."
python -V

echo "Going to data_prep ..."
cd data_prep
echo "DONE"

echo "Running fl_cha_repro.sh ..."
bash fl_cha_repro.sh
echo "DONE"

echo "Running fl_lightcurve.sh ..."
bash fl_lightcurve.sh
echo "DONE"

echo "Running fl_back7.sh ..."
bash fl_back7.sh
echo "DONE"

echo "Running fl_fluximage_new.sh ..."
bash fl_fluximage_new.sh
echo "DONE"

echo "Running fl_bkchipreg77.sh ..."
bash fl_bkchipreg77.sh
echo "DONE"

echo "Running fl_fluximage_ccd_hard.sh ..."
bash fl_fluximage_ccd_hard.sh
echo "DONE"

echo "Running fl_hard_cornorm.sh ..."
bash fl_hard_cornorm.sh
echo "DONE"

echo "Running fl_imgall_new.sh ..."
bash fl_imgall_new.sh
echo "DONE"

echo "Running fl_wavedetect_new.sh ..."
bash fl_wavedetect_new.sh
echo "DONE"

echo "Running fl_dmfilth.py ..."
python fl_dmfilth.py
echo "DONE"

echo "Running fl_dmfilth.sh ..."
bash fl_dmfilth.sh
echo "DONE"

echo "python version right before v2fits..."
python -V

echo "running v2fits..."
python3 v2fits.py
echo "DONE"