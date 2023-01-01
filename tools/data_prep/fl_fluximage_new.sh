############
#fl_fluximage_new.sh
#
# run by typing bash fl_fluximage_new.sh in directory that contains the observation directory
#
#
#
# this script creates an exposure map and fluxed image using fluximage
##########



while read line           
do           
    export obsid=$line  
	det=$(dmkeypar $obsid\/repro/*_evt2.fits DETNAM echo+)
	export detcut=${det:5:1}	
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"	
	echo $det	
	echo $detcut
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	
	if [ "$detcut" = "0" ]; then
		echo "--------------------------------------------------------------------"
		fluximage "$obsid\/repro/evt2.fits[ccd_id=0:3]"  $obsid\/repro/flux/bin1 binsize=1 expmapthresh="1.5%" units=time verbose=1 clobber=yes
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo $obsid "FLUXED"
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	else
		fluximage "$obsid\/repro/evt2.fits[ccd_id=7]"  $obsid\/repro/flux/bin1 binsize=1 expmapthresh="1.5%" units=time verbose=1 clobber=yes
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo $obsid "FLUXED"
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

	fi

done <flares.dat  

		
