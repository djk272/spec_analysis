FROM fjebaker/heasoft:6.32.1-amd64
RUN mkdir spec_analysis/
WORKDIR spec_analysis/
COPY --chown=heasoft ./entrypoint.sh .
COPY --chown=heasoft ./tools .
COPY --chown=heasoft requirements.txt .
RUN ./ciao-install

#RUN pip install --upgrade pip
#RUN pip install -r requirements.txt
ENTRYPOINT ["./entrypoint.sh"]
#to run docker img with mounted volume: docker run -v /Users/davidkelly/spec_analysis/data:/home/heasoft/spec_analysis/data -it spectral_analysis:1.0.0 tcsh
#to start running Ciao: source ~/spec_analysis/ciao-4.12/bin/ciao.csh