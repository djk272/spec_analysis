##################
# fl_dmfilth.py
#
# to reun this type python fl_dmfilth.py
#
#this python program creates region files to be used as sample backfround regions to be used by dmfilth.sh
#
#
#
#
##################


from pylab import *
from numpy import loadtxt
import math
import matplotlib.pyplot as plt
import os

obs  = np.loadtxt("flares.dat",dtype="str",skiprows=0)
print(obs[0])


for j in range (0,5):

	os.chdir("/home/heasoft/spec_analysis/data_prep/"+str(obs[j])+"/repro/flux/") #os.chdir("/Users/edmund/clusters/"+str(obs[j])+"/repro/flux/")

	dataR  = np.loadtxt(str(obs[j])+"_src.reg",dtype="str",delimiter=",",skiprows=0)
	x0=dataR[:,0]
	y0=dataR[:,1]	
	major=dataR[:,2]
	minor=dataR[:,3]
	deg=dataR[:,4]

	most=len(x0)

	major15 = [0 for x in range(most)] 
	minor15 = [0 for x in range(most)] 

	major3 = [0 for x in range(most)] 
	minor3 = [0 for x in range(most)] 


	for i in range(0,most):

		major15[i]=1.0*float(major[i])
		minor15[i]=1.0*float(minor[i])


	for i in range(0,most):
	
		major3[i]=1.5*float(major15[i])
		minor3[i]=1.5*float(minor15[i])


	line=str(x0)+","+str(y0)+","+str(major3)+","+str(minor3)+","+str(deg)+"-"+str(x0)+","+str(y0)+","+str(major15)+","+str(minor15)+","+str(deg)

	file=open(str(obs[j])+"_src.reg","w")

	for i in range(0,most):
		file.write(str(x0[i])+","+str(y0[i])+","+str(major15[i])+","+str(minor15[i])+","+str(deg[i])+"\n")

	file.close()


	file=open(str(obs[j])+"_src_bkg.reg","w")

	for i in range(0,most):
		file.write(str(x0[i])+","+str(y0[i])+","+str(major3[i])+","+str(minor3[i])+","+str(deg[i])+"-"+str(x0[i])+","+str(y0[i])+","+str(major15[i])+","+str(minor15[i])+","+str(deg[i])+"\n")

	file.close()




	print("      ")
	print("      ")
	print("SO YOU KNOW, "+str(most)+" REGIONS GOT BACKGROUNDED IN "+str(obs[j])+".")
	print("      ")
	print("      ")
