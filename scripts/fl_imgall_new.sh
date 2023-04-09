############
#fl_imgall_new.sh
#
# run by typing bash fl_imgall_new.sh in directory that contains the observation directory
#
#
#
# this script creates and exposure corrected, background subtracted image. 
##########



while read line           
do           
    export obsid=$line  
	
	
	dmstat $obsid\/repro/flux/bin1_broad_thresh.expmap
	export expmax=$(pget dmstat out_max)	
	echo "______________________________"
	echo "MAXIMUM EXPOSURE IS:" $expmax
	echo "______________________________"	
	fact=$(echo 1/$expmax|bc -l)


	dmimgcalc $obsid\/repro/flux/bin1_broad_thresh.img $obsid\/repro/flux/bin1_broad_thresh.expmap $obsid\/repro/flux/bin1_img_exp.fits DIV clobber=yes verbose=2
	
	dmimgcalc $obsid\/repro/bkgrnd/bin1_bg_imgN.fits $obsid\/repro/flux/bin1_broad_thresh.expmap $obsid\/repro/bkgrnd/bin1_bg_imgN_exp.fits  DIV clobber=yes verbose=2 
	

	dmimgcalc $obsid\/repro/flux/bin1_img_exp.fits $obsid\/repro/bkgrnd/bin1_bg_imgN_exp.fits $obsid\/repro/flux/bin1_imgALL.fits SUB clobber=yes verbose=2
	

	dmimgcalc $obsid\/repro/flux/bin1_imgALL.fits NONE $obsid\/repro/flux/bin1_imgALL_cts.fits MUL weight=$expmax clobber=yes


	dmimgcalc $obsid\/repro/bkgrnd/bin1_bg_imgN_exp.fits NONE $obsid\/repro/bkgrnd/bin1_bg_imgN_expN.fits MUL weight=$expmax clobber=yes














done <flares.dat  

		


