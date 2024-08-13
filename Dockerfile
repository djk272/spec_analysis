FROM fjebaker/heasoft:6.32.1-amd64
# dustpancake/heasoft:6.30.1-aarch64
RUN mkdir spec_analysis/
WORKDIR spec_analysis/
COPY --chown=heasoft ./entrypoint.sh .
COPY --chown=heasoft ./tools .
COPY --chown=heasoft requirements.txt .
RUN ./ciao-install #installing CIAO

#WORKDIR spec_analysis/tools/funtools/
#RUN ./configure  #installing FUNTOOLS site-specific configuration
#RUN make			# build the software
#RUN make install	# install FUNTOOLS
#RUN make clean		# clean up unneeded temp files
#WORKDIR spec_analysis/

#RUN pip install --upgrade pip
#RUN pip install -r requirements.txt
ENTRYPOINT ["./entrypoint.sh"]

##For every change to this file you must 
#docker rm --force <ContainerName>
#Make (rebuilds image to reflect changes)

#to run lastest docker img with mounted volume: docker run -v /Users/davidkelly/spec_analysis/data:/home/heasoft/spec_analysis/data -it spectral_analysis:1.0.0 tcsh

#to start running Ciao: source ~/spec_analysis/ciao-4.12/bin/ciao.csh