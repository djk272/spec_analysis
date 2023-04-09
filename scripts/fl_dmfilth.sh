##################
# fl_dmfilth.sh
#
# to reun this type bash fl_dmfilth.sh
#
# this script funs dmfilth with removes the point sources and files in the space with local average background
#
#
#
#
##################


while read line           
do           
    export obsid=$line  
	#dmfilth $obsid\/repro/flux/bin1_fg04.fits $obsid\/repro/flux/bin1_imgALL_fg04_filth.fits DIST @$obsid\/repro/flux/$obsid\_src12.reg @$obsid\/repro/flux/$obsid\_src12_bkg.reg verbose=2 clobber=yes

	dmfilth $obsid\/repro/flux/bin1_imgALL_cts.fits $obsid\/repro/flux/bin1_imgALL_cts_filth01.fits DIST @$obsid\/repro/flux/$obsid\_src.reg @$obsid\/repro/flux/$obsid\_src_bkg.reg verbose=2 clobber=yes


done <flares.dat   
