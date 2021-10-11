#!/bin/bash

#make aliases avalible
shopt -s expand_aliases
source ~/.bash_profile

#start ciao
ciao

#start heasoft
heainit

#data prep
echo "Running data_prep ..."
. data_prep/data_prep.sh

#find regions
echo "Running v2fits ..."
python3 v2fits.py

#spectral analysis
echo "Running spec_analysis"

#start specextract
echo "Running specextract ..."
spec="specextract"
${spec}
. spec.sh

#start xspec
echo "Running xpsec ..."
file="- A1763.xcm"
xspec ${file}





