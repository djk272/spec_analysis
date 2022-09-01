#!/usr/bin/python

# A program that reads in the fits file and then finds the smallest region around a specific point that contains X number of counts.

import astropy
import os
import sys
from math import pi
from math import atan
#import glob
import matplotlib.pyplot as plt
import numpy as np
from decimal import *
#import time
#start_time = time.time()

from astropy.io import fits

##########################################################################
def write_file(string): # Function to write output to file
  try:
    annuli_file.write(str(string))
  except:
   None  
##########################################################################

##########################################################################
def write_big_file(string): # Function to write all outputs to one file
  try:
    final_annuli_file.write(str(string)+"\n")
  except:
   None  
##########################################################################

##########################################################################
def write_specex_file(string): # Function to write specextract outputs to one file
  try:
    specex_file.writelines(str(string)+"\n")
  except:
   None  
##########################################################################

# Change to your current working directory
os.chdir(os.path.dirname(os.path.abspath(__file__))) 

filename = "annuli"
specex_filename = "spec"
file_ext = ".reg"
specex_ext = ".sh"
filepath = os.getcwd() 
data_path = "/usr/src/astro/spec_analysis/data/"

##-- Circle Stuff --##


hdulist = fits.open(str(data_path)+'A1763_img5_exp.fits') # Raw foreground file #bin1_imgALL_cts_filth.fits #A1763_img5_exp.fits
imgf = hdulist[0].data # Relevant slice of foreground from the file

hdulist2 = fits.open(str(data_path)+'A1763_bg5_exp.fits') # Raw background file #bin1_bg_imgN_expN.fits #A1763_bg5_exp.fits
imgbg = hdulist2[0].data # Relevant slice of background from the file


#imgp = imgf*0.777567 # Physical distances in kpc

#print(imgf)

#Center of cluster in pixels:
#cx = 712 # filth
#cy = 507 # filth
cx = 1189 #1177.9903  # A1763
cy = 1882 #1861.2992  # A1763 

#Center of cluster in physical distance(kpc):
#cx_phy = 4028 # filth
#cy_phy = 4214 # filth
cx_phy = 3759 #3747.9903  # A1763
cy_phy = 4198 #4177.2992  # A1763

#Input angles
alpha = 30 #90 # Angle of the region
beta = 0 #45 # Angle of the region from the origin


boxsize = 2000 #1000     # Size of region for which map will be created (in img or phys pixels)
bs2 = boxsize/2 # Half of boxsize

xl = int(cx-bs2) # Length in the x direction
xh = int(cx+bs2) # Height in the x direction
yl = int(cy-bs2) # Length in the y direction
yh = int(cy+bs2) # Height in the y direction

img = imgf[yl:yh,xl:xh] # The frame of the foreground image
bgimg = imgbg[yl:yh,xl:xh] # The frame of the background image

boxmo = boxsize-1 # 
cx = bs2 #box center
cy = bs2 #box center
w, h = boxsize, boxsize; # Width and height of the region
mask = [[0 for x in range(w)] for y in range(h)] # Area of the mask

#FK5 Sexagesimal
#cx = ra = "13:35:18.6036"
#cy = dec = "+41:00:24.116"

obs_id = ['3591', '20590', '22130', '22136', '22137']



i = 0 # Iteration count for while loop

r0 = 0#*0.49/60 # Inner radii (arcsec)
r1 = 1#*0.49/60 # Outer radii (arcsec)
counts = 0 # Initialize foreground counts
bkg_counts = 0 # Initialize backgroundground counts
SNR = 0 # Initialize signal to noise ratio

specex_file = open(str(data_path)+"out/"+str(specex_filename)+str(specex_ext),"a") # Opening a file to write specextract code 

write_specex_file("punlearn specextract") # This string will be at the start of the file


############################################################################################################################
##-- Looping to find the radius in which the signal to noise ration is less than 40 --##

print("Start of big while loop")
while r1 < bs2:
  i += 1 # Will add 1 to each iteration, used for naming files "file1.reg, file2.reg,... fileN.reg"
  annuli_file = open(str(data_path)+"out/"+str(filename)+str(i)+str(file_ext),"w") # Opening a file to write each found annulus
  final_annuli_file = open(str(data_path)+"out/"+str(filename)+str(file_ext),"a") # Opening a file to write all found annuli 
  
  
  print("SNR at the start: "+ str(SNR))
  while SNR < 40: # While in the radius and the signal to noise ratio is less than 40

    print("r0 and r1 at the start: " + "r0= "+ str(r0*0.49/60) + ", " + "r1= " + str(r1*0.49/60))
    for j in range (0,boxmo): # All values in the x direction

     for k in range (0,boxmo): # All values in the y direction

      if ((j-cx)**2)+((k-cy)**2)<=r1**2: # If the values fall within the outer radius
       

       if ((j-cx)**2)+((k-cy)**2)>=r0**2: # if the values fall outside the inner radius
        

        #Get angle
        theta = (((np.arctan2(k-cy,j-cx)))*180/np.pi)
        #Adjust arctan so it is between 0 and 360
        if theta<0:
            theta = theta+360
        #Add if it is inside the slice
        if (theta>beta) & (theta<(alpha+beta)):
            #mask.append((j,k))

          mask[k][j] = 1 # Apply the mask
       #/end of if
      #/end of if
     #/end of for loop   
    #/end of for loop

    interio = np.multiply(img,mask) # The foreground values within the radius
    bg_interio = np.multiply(bgimg,mask) # The background values within the radius
     
    counts = np.sum(interio) # The total number of foreground counts within
    bkg_counts = np.sum(bg_interio) # The total number of background counts within

    SNR = counts/(((counts + bkg_counts)+0.0001)**0.5) # Signal to Noise ratio, avoid division by zero
  
    if SNR < 40 and r1 < bs2: # If the signal to noise ration is less than 40 and outter radius less than half the boxsize
     r1 = r1+5 # Then increase the outer radius by 1
    else: 
     print("r0 = "+str(r0*0.49/60)+"'"+", r1 = "+str(r1*0.49/60)+"'") # Print the values for the inner and outter radius
     print("r0 and r1 at the end: "+ "r0= "+str(r0*0.49/60)+"'" + ", " + "r1= " + str(r1*0.49/60)+"'")
     print("SNR at the end: " + str(SNR)+", "+"Counts at the end: " + str(counts))
     #CIAO: 
     #pie(cx_phy,cy_phy,r0,r1,angle_start,angle_stop), ex: pie(4028,4214,0,61,0,90)
     #ellipse(cx_phy,cy_phy,r0,r1), ex: ellipse(3248,4198,501,501,0)-ellipse(3248,4198,0,0,0)
     
     print("pie("+str("13:35:18.6036")+","+str("+41:00:24.116")+","+str(r0*0.49/60)+"'"+","+str(r1*0.49/60)+"'"+","+str(beta)+","+str(alpha+beta)+")"+"-"+"pie("+str("13:35:18.6036")+","+str("+41:00:24.116")+","+str(r0*0.49/60)+"'"+","+str(r0*0.49/60)+"'"+","+str(beta)+","+str(alpha+beta)+")")
     #print("ellipse("+str(cx_phy)+","+str(cy_phy)+","+str(r0)+","+str(r1)+")"+"-"+"ellipse("+str(cx_phy)+","+str(cy_phy)+","+str(r0)+","+str(r0)+")")
     
     #write_file("ellipse("+str(cx_phy)+","+str(cy_phy)+","+str(r1)+","+str(r1)+","+str(0)+")"+"-"+"ellipse("+str(cx_phy)+","+str(cy_phy)+","+str(r0)+","+str(r0)+","+str(0)+")")
     #ellipse(cx_phy,cy_phy,r0,r1,angle)

     write_file("pie("+str("13:35:18.6036")+","+str("+41:00:24.116")+","+str(r0*0.49/60)+"'"+","+str(r1*0.49/60)+"'"+","+str(beta)+","+str(alpha+beta)+")")
     #pie(cx_phy,cy_phy,r0,r1,angle_start,angle_stop)
     
     #write_big_file("ellipse("+str(cx_phy)+","+str(cy_phy)+","+str(r0)+","+str(r1)+")")
     #ellipse(cx_phy,cy_phy,r0,r1)
     
     write_big_file("pie("+str("13:35:18.6036")+","+str("+41:00:24.116")+","+str(r0*0.49/60)+"'"+","+str(r1*0.49/60)+"'"+","+str(beta)+","+str(alpha+beta)+")")
     #pie(cx_phy,cy_phy,r0,r1,angle_start,angle_stop)
     
     

     line1 = "#"+str(data_path)+str(i)+"\n"+"punlearn specextract"+"specextract infile="+'"'+str(obs_id[0])+'_evt2'+'.fits[sky=region('+str(filename)+str(i)+str(file_ext)+')]"'+" outroot="+str(obs_id[0])+"_ann"+str(i)+" bkgfile="+'"../bkgrnd/merge_bg_RP.fits[sky=region('+str(filename)+str(i)+str(file_ext)+'.reg)]"' + " grouptype=NUM_CTS binspec=20 bkgresp=no clobber=yes verbose=1"
     line2 = "punlearn specextract"+"specextract infile="+'"'+str(obs_id[1])+'_evt2'+'.fits[sky=region('+str(filename)+str(i)+str(file_ext)+')]"'+" outroot="+str(obs_id[1])+"_ann"+str(i)+" bkgfile="+'"../bkgrnd/merge_bg_RP.fits[sky=region('+str(filename)+str(i)+str(file_ext)+'.reg)]"' + " grouptype=NUM_CTS binspec=20 bkgresp=no clobber=yes verbose=1"
     line3 = "punlearn specextract"+"specextract infile="+'"'+str(obs_id[2])+'_evt2'+'.fits[sky=region('+str(filename)+str(i)+str(file_ext)+')]"'+" outroot="+str(obs_id[2])+"_ann"+str(i)+" bkgfile="+'"../bkgrnd/merge_bg_RP.fits[sky=region('+str(filename)+str(i)+str(file_ext)+'.reg)]"' + " grouptype=NUM_CTS binspec=20 bkgresp=no clobber=yes verbose=1"
     line4 = "punlearn specextract"+"specextract infile="+'"'+str(obs_id[3])+'_evt2'+'.fits[sky=region('+str(filename)+str(i)+str(file_ext)+')]"'+" outroot="+str(obs_id[3])+"_ann"+str(i)+" bkgfile="+'"../bkgrnd/merge_bg_RP.fits[sky=region('+str(filename)+str(i)+str(file_ext)+'.reg)]"' + " grouptype=NUM_CTS binspec=20 bkgresp=no clobber=yes verbose=1"
     line5 = "punlearn specextract"+"specextract infile="+'"'+str(obs_id[4])+'_evt2'+'.fits[sky=region('+str(filename)+str(i)+str(file_ext)+')]"'+" outroot="+str(obs_id[4])+"_ann"+str(i)+" bkgfile="+'"../bkgrnd/merge_bg_RP.fits[sky=region('+str(filename)+str(i)+str(file_ext)+'.reg)]"' + " grouptype=NUM_CTS binspec=20 bkgresp=no clobber=yes verbose=1"
     write_specex_file('{}\n{}\n{}\n{}\n{}\n'.format(line1,line2,line3,line4,line5))
     counts = 0 # Reset to find next set of foreground counts
     bkg_counts = 0 # Reset to find next set of background counts

     interio = np.multiply(0,interio) # Reset to find next of foreground values within the radius
     bg_interio = 0 # Reset to find next of background values within the radius

     mask = [[0 for x in range(w)] for y in range(h)] # Rest mask to zeros
     SNR = 0 # Reset signal to noise ratio for nest radius

     r0 = r1 # The new inner radius is equal to the previous outer radius to produce annuli
     r1 = 1+r0 # Reset to find the new r1
     break
    #end of if else 
  #/end of while loop
#/end of while loop
annuli_file.close() # Close file when complete
print("Outside big while loop")
final_annuli_file.close() # Close file when complete
specex_file.close() # Close file when complete


##


#rad = ((j-cx)**2)+((k-cy)**2)#

      #if rad<r1**2 and rad>r0**2:#
        #mask[k][j] = 1#
      
      #else:#
        #mask[k][j] = 0#
