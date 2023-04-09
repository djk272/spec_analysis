############
#fl_cha_repro.sh
#
# run by typing bash fl_cha_repro.sh in directory that contains the observation directory
#
#
#
#this script runs standard chandra reprocessing (chandra_repro)
##########

while read line           
do           
	export obsid=$line  
	
	echo "reproing " $obsid
	
	chandra_repro $obsid $obsid\/repro "check_vf_pha=yes" clobber=yes verbose=2
	#chandra_repro $obsid $obsid\/repro clobber=yes verbose=2


done <flares.dat  

		


