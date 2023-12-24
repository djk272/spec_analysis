.PHONY: image prep_data push_image
CR := "docker"
IMAGE_NAME := "spectral_analysis"
IMAGE_TAG := "1.0.0"
IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)

image:
	$(CR) build -t $(IMAGE) .

prep_data:
	# generate file with regix for flare.dat, prefix data dirs
	#fl_lightcurve.sh
	#fl_back7.sh
	#fl_fluximage_new.sh
	#fl_bkchipreg77.sh
	#fl_fluximage_ccd_hard.sh    
	#fl_hard_cornorm.sh
	#fl_imgall_new.sh
	#fl_wavedetect_new.sh
	#python fl_dmfilth.py
	#bash fl_dmfilth.sh

push_image:
	$(CR) push -t $(IMAGE) .
