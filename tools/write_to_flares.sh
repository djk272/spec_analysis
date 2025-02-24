#!/bin/bash

#Before running, list the names of the observation directors as individual rows in the file "flares.dat".
#grab dir names of observation files and write to flares.dat

for dir in /home/heasoft/spec_analysis/data/*/; #Navigate to "/data" and parse dir names, and write to flares.dat
	do basename "$dir"; 
done > data_prep/flares.dat