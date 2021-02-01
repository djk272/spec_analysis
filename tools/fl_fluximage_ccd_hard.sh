##################
# fl_fluximage_ccd_hard.sh
#
# run by typing bash fl_fluximage_ccd_hard.sh
#
#
# creates a fluxed image in the 10-12 energy keV range for use in normalization of bkg files and the determination of the cornorm value
#
#
##################



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
		fluximage "$obsid\/repro/evt2.fits[ccd_id=0:3][energy=10000:12000]"  $obsid\/repro/flux/hard_bin1 binsize=1 expmapthresh="1.5%" units=time verbose=1 clobber=yes
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo $obsid "FLUXED"
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	else
		fluximage "$obsid\/repro/evt2.fits[ccd_id=7][energy=10000:12000]"  $obsid\/repro/flux/hard_bin1 binsize=1 expmapthresh="1.5%" units=time verbose=1 clobber=yes
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo $obsid "FLUXED"
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

	fi

done <flares.dat  

		
