while read line           
do           
    export obsid=$line  
	
	punlearn wavdetect 
	wavdetect infile=$obsid\/repro/flux/bin1_imgALL_cts.fits outfile=$obsid\/repro/flux/img_src.fits expfile=$obsid\/repro/flux/bin1_broad_thresh.expmap scellfile=$obsid\/repro/flux/image_scell.fits imagefile=$obsid\/repro/flux/image_imgfile.fits defnbkgfile=$obsid\/repro/flux/image_nbgd.fits regfile=$obsid\/repro/flux/$obsid\_src.reg scales="2 4 8" psffile="" clobber=yes verbose=2

done <flares.dat  

		

#wavdetect infile=$obsid\/repro/flux/bin1_imgALL_cts.fits outfile=$obsid\/repro/flux/img_src.fits expfile=$obsid\/repro/flux/bin1_broad_thresh.expmap scellfile=$obsid\/repro/flux/image_scell.fits imagefile=$obsid\/repro/flux/image_imgfile.fits defnbkgfile=$obsid\/repro/flux/image_nbgd.fits regfile=$obsid\/repro/flux/$obsid\_src.reg scales="2 4 8 16" psffile="" clobber=yes verbose=2
