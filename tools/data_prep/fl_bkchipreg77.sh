############
#fl_bkchipreg77.sh
#
# run by typing bash fl_bkchipreg77.sh in directory that contains the observation directory
#
#
#
#this script grabs observation specific blanksyfiles for each chip, merges them and reprojects them to match to the observation coordinates/orientation
##########



while read line           
do           
    export obsid=$line  
	det=$(dmkeypar $obsid\/repro/evt2.fits DETNAM echo+)
	export detcut=${det:5:1}	
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"	
	echo $det	
	echo $detcut
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	
	if [ "$detcut" = "0" ]; then
		echo "--------------------------------------------------------------------"
		get_sky_limits $obsid\/repro/flux/bin1_broad_thresh.img
		export coords=$(pget get_sky_limits dmfilter)
		dmcopy "$obsid\/repro/bkgrnd/merge_bg_RP.fits[ccd_id=0:3][bin $coords][energy=500:7000]" $obsid\/repro/bkgrnd/bin1_bg_img.fits clobber=yes

	else
		get_sky_limits $obsid\/repro/flux/bin1_broad_thresh.img
		export coords=$(pget get_sky_limits dmfilter)
		dmcopy "$obsid\/repro/bkgrnd/merge_bg_RP.fits[ccd_id=7][bin $coords][energy=500:7000]" $obsid\/repro/bkgrnd/bin1_bg_img.fits clobber=yes

	fi


















done <flares.dat  

		

#dmimgcalc "flux_bin2/bin1_broad_thresh.img,bkgrnd/bg_img.fits,flux_bin2/bin1_broad_thresh.expmap" none foo.fits op="imgout=((img1-0.0133349*img2)/img3)"
		
