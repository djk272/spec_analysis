############
#fl_back.sh
#
# run by typing bash fl_back.sh in directory that contains the observation directory
#
#
#
#this script grabs observation specific blanksyfiles for each chip, merges them and reprojects them to match to the observation coordinates/orientation.
########################



while read line           
do           
    export obsid=$line  
    echo $obsid
    #dmcopy $obsid\/repro/*_evt2.fits $obsid\/repro/evt2.fits clobber=yes	
    acis_bkgrnd_lookup $obsid\/repro/evt2.fits
    backgrnd="$(pget acis_bkgrnd_lookup outfile)"
    mkdir $obsid\/repro/bkgrnd
    echo $backgrnd > $obsid\/repro/bkgrnd/bkgrndlist.txt 
    export chips="$(awk -F, '{print NF}' $obsid\/repro/bkgrnd/bkgrndlist.txt)"
    echo $chips
    
	if [ "$chips" = "5" ]; then
		IFS=","
		while read A B C D E 
		do
		cp "$A" $obsid\/repro/bkgrnd/
		echo ${A:60:1}
		echo "$A"
		cp "$B" $obsid\/repro/bkgrnd/
		echo ${B:60:1}
		cp "$C" $obsid\/repro/bkgrnd/
		echo ${C:60:1}
		cp "$D" $obsid\/repro/bkgrnd/
		echo ${D:60:1}
		cp "$E" $obsid\/repro/bkgrnd/
		echo ${E:60:1}
		dmmerge "$A,$B,$C,$D,$E" $obsid\/repro/bkgrnd/merge_bg.fits verbose=2 clobber=yes


		mode=$(dmkeypar $obsid\/repro/evt2.fits DATAMODE echo+)
		if [ "$mode" = "VFAINT" ]; then
		dmcopy "$obsid\/repro/bkgrnd/merge_bg.fits[status=0]" $obsid\/repro/bkgrnd/merge_bg_clean.fits clobber=yes		
		fi
		
		dmmakepar $obsid\/repro/evt2.fits $obsid\/repro/event_header.par clobber=yes
		grep _pnt $obsid\/repro/event_header.par > $obsid\/repro/event_pnt.par
		cat $obsid\/repro/event_pnt.par
		chmod +w $obsid\/repro/bkgrnd/merge_bg_clean.fits
		dmreadpar $obsid\/repro/event_pnt.par "$obsid\/repro/bkgrnd/merge_bg_clean.fits[events]" clobber=yes		

		punlearn reproject_events
 		reproject_events infile=$obsid\/repro/bkgrnd/merge_bg_clean.fits outfile=$obsid\/repro/bkgrnd/merge_bg_RP.fits aspect=$obsid\/repro/*_asol1.fits match=$obsid\/repro/evt2.fits random=0 clobber=yes verbose=2
		

		done < $obsid\/repro/bkgrnd/bkgrndlist.txt 
	
	else
		IFS=","
		while read A B C D E F
		do
		cp "$A" $obsid\/repro/bkgrnd/
		echo ${A:60:1}
		export chip="${A:60:1}"
		cp "$B" $obsid\/repro/bkgrnd/
		echo ${B:60:1}
		cp "$C" $obsid\/repro/bkgrnd/
		echo ${C:60:1}
		cp "$D" $obsid\/repro/bkgrnd/
		echo ${D:60:1}
		cp "$E" $obsid\/repro/bkgrnd/
		echo ${E:60:1}
		cp "$F" $obsid\/repro/bkgrnd/
		echo ${F:60:1}
		dmmerge "$A,$B,$C,$D,$E,$F" $obsid\/repro/bkgrnd/merge_bg.fits clobber=yes
		
		dmcopy "$obsid\/repro/bkgrnd/merge_bg.fits[status=0]" $obsid\/repro/bkgrnd/merge_bg_clean.fits clobber=yes		

		dmmakepar $obsid\/repro/evt2.fits $obsid\/repro/event_header.par clobber=yes
		grep _pnt $obsid\/repro/event_header.par > $obsid\/repro/event_pnt.par
		cat $obsid\/repro/event_pnt.par
		chmod +w $obsid\/repro/bkgrnd/merge_bg_clean.fits
		dmreadpar $obsid\/repro/event_pnt.par "$obsid\/repro/bkgrnd/merge_bg_clean.fits[events]" clobber=yes	

		punlearn reproject_events
 		reproject_events infile=$obsid\/repro/bkgrnd/merge_bg_clean.fits outfile=$obsid\/repro/bkgrnd/merge_bg_RP.fits aspect=$obsid\/repro/*_asol1.fits match=$obsid\/repro/evt2.fits random=0 clobber=yes verbose=2


		done < $obsid\/repro/bkgrnd/bkgrndlist.txt 


          fi





done <flares.dat  


