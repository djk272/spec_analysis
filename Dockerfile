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
