#!/usr/bin/env sh
#source $HOME/spec_analysis/ciao-4.12/bin/ciao.sh && exec "$@"
exec "$@"

echo "preparing data for analysis..."

	# generate file with regix for flare.dat, prefix data dirs
	#All scripts below (and flares.dat) should be located and 
	#run from the same directory that holds the observation directories.


echo "list the names of the observation directors as individual rows in the file flares.dat ..."
bash write_to_flares.sh #list the names of the observation directors as individual rows in the file "flares.dat"
echo "done"

echo "copy obsv dirs to data_prep dir..."
cp -r /home/heasoft/spec_analysis/data/* /home/heasoft/spec_analysis/data_prep #copy obsv dirs to data_prep dir
echo "done"

echo "Starting CIAO.."
source ~/spec_analysis/ciao-4.12/bin/ciao.csh #source isn't working with entrypoint

echo "Going to data_prep"
cd data_prep

echo "Running fl_cha_repro.sh ..."
bash fl_cha_repro.sh
echo "done"

echo "Running "
bash fl_lightcurve.sh
echo "done"

echo "Running "
bash fl_back7.sh
echo "done"

echo "Running "
bash fl_fluximage_new.sh
echo "done"

echo "Running "
bash fl_bkchipreg77.sh
echo "done"

echo "Running "
bash fl_fluximage_ccd_hard.sh
echo "done"