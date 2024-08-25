.PHONY: image prep_data push_image v2fits specextract xspec spectral_analysis
CR := "docker"
IMAGE_NAME := "spectral_analysis"
IMAGE_TAG := "1.0.0"
IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)

image:
	$(CR) build -t $(IMAGE) .

run: image
	docker run -v /Users/davidkelly/spec_analysis/data:/home/heasoft/spec_analysis/data -it $(IMAGE) tcsh
# push_image: image
# 	$(CR) push -t $(IMAGE) .

# prep_data: image
# 	echo "preparing data for analysis..."

# 	# generate file with regix for flare.dat, prefix data dirs
# 	#All scripts below (and flares.dat) should be located and 
# 	#run from the same directory that holds the observation directories.

# 	echo "list the names of the observation directors as individual rows in the file flares.dat"
# 	bash write_to_flares.sh #list the names of the observation directors as individual rows in the file "flares.dat"

# 	echo "copy obsv dirs to data_prep dir"
# 	cp -r /home/heasoft/spec_analysis/data/* /home/heasoft/spec_analysis/data_prep #copy obsv dirs to data_prep dir

	#bash fl_cha_repro.sh
	#bash fl_lightcurve.sh
	#bash fl_back7.sh
	#bash fl_fluximage_new.sh
	#bash fl_bkchipreg77.sh
	#bash fl_fluximage_ccd_hard.sh
	#bash fl_hard_cornorm.sh
	#bash fl_imgall_new.sh
	#bash fl_wavedetect_new.sh
	#python fl_dmfilth.py
	#bash fl_dmfilth.sh

# v2fits: prep_data
# 	echo "running v2fits..."

# specextract:
# 	echo "running specextract..."

# xspec:
# 	echo "running xspec..."

# spectral_analysis: v2fits specextract xspec
