############
# fl_hard_cornorm.sh
#
# run by typing bash fl_hard_cornorm.sh in directory that contains the observation directory
#
#
# This script determines the cornorm value to be used in Xspec fitting and scales the background image to the obervation. It makes a director repro/specNEW and saves the cornorm value in cornorm.dat 
##########





while read line           
do           
	export obsid=$line 
	
	get_sky_limits $obsid/repro/flux/bin1_broad_thresh.expmap 
	export coords=$(pget get_sky_limits dmfilter)
	
	dmcopy "$obsid\/repro/evt2.fits[energy=10000:12000][bin $coords]" $obsid\/repro/img1012_noexp.fits clobber=yes

	dmcopy "$obsid\/repro/evt2.fits[energy=10000:12000][bin $coords]" $obsid\/repro/img1012_noexp.fits clobber=yes
	
	dmimgcalc $obsid\/repro/img1012_noexp.fits $obsid\/repro/flux/hard_bin1_broad_thresh.expmap $obsid\/repro/img1012_exp.fits DIV clobber=yes
	
	dmcopy "$obsid\/repro/bkgrnd/merge_bg_RP.fits[energy=10000:12000][bin $coords]" $obsid\/repro/bkgrnd/bgimg1012_noexp.fits clobber=yes
	dmimgcalc $obsid\/repro/bkgrnd/bgimg1012_noexp.fits $obsid\/repro/flux/hard_bin1_broad_thresh.expmap $obsid\/repro/bkgrnd/bgimg1012_exp.fits DIV clobber=yes	

	funcnts -G $obsid\/repro/img1012_exp.fits @400_off.reg > $obsid\/repro/img_hard.dat
	funcnts -G $obsid\/repro/bkgrnd/bgimg1012_exp.fits @400_off.reg > $obsid\/repro/bkg_hard.dat


	tail -n+23  $obsid\/repro/img_hard.dat>$obsid\/repro/lineimg.txt
	tail -n+23  $obsid\/repro/bkg_hard.dat>$obsid\/repro/linebkg.txt
	export imgh=$(awk '{print $2}' $obsid\/repro/lineimg.txt)
	export bkgh=$(awk '{print $2}' $obsid\/repro/linebkg.txt)

	export num1=$(echo $imgh | sed 's/e/\*10\^/' | sed 's/+//') 
	export imgh=$(echo ${num1} |bc)
	export num2=$(echo $bkgh | sed 's/e/\*10\^/' | sed 's/+//') 
	export bkgh=$(echo ${num2} |bc)
	
	export fact=$(echo $imgh/$bkgh|bc -l)

	dmimgcalc $obsid\/repro/bkgrnd/bin1_bg_img.fits NONE $obsid\/repro/bkgrnd/bin1_bg_imgN.fits MUL weight=$fact clobber=yes
	echo "background normalization factor based on HARDCOUNT is:" $fact
#this calculates the cornorm factor as well
	export exp=$(dmkeypar $obsid/repro/evt2.fits EXPOSURE echo+)
	export bgexp=$(dmkeypar $obsid/repro/bkgrnd/merge_bg_RP.fits EXPOSURE echo+)	
	export factc=$(echo $exp/$bgexp|bc -l)
	echo "background normalization factor based on EXPOSURE is:" $factc
	export factc=$(echo $exp/$bgexp|bc -l)
	export cdiff=$(echo $fact-$factc|bc -l)
	export cornorm=$(echo $cdiff/$factc|bc -l)
	echo "cornorm value for use in Xspec:" $cornorm
	mkdir $obsid\/repro/specNEW
	echo $cornorm >> $obsid\/repro/specNEW/cornorm.dat



done <flares.dat
