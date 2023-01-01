############
#fl_lightcurve.sh
#
# run by typing fl_lightcurve.sh in directory that contains the observation directory
#
#
#
#this program removes any times associated with anomalous flux (i.e. background flares) from the observations. A plot is produced and saved as deflare.png in the observation's repro directory.
############

while read line           
do           
    export obsid=$line  
	echo $obsid
	
	dmextract "$obsid/repro/*_evt2.fits[bin time=::200]" outfile=$obsid/repro/lc.fits opt=ltc1 clobber=yes
	
	deflare $obsid/repro/lc.fits outfile=$obsid/repro/lc.gti method="sigma" plot=no save=$obsid/repro/deflare.png	

	dmcopy "$obsid/repro/*_evt2.fits[@$obsid/repro/lc.gti]" $obsid/repro/evt2_lc.fits clobber=yes

	dmcopy "$obsid/repro/evt2_lc.fits[ccd_id=0:3]" $obsid/repro/evt2.fits clobber=yes

done <flares.dat  
