FROM python:latest #getting most current python image

RUN mkdir /usr/src/astro

WORKDIR /usr/src/astro

#COPY A1763_img5_exp.fits .
#COPY A1763_bg5_exp.fits .
COPY ./tools/v2fits.py .
COPY requirements.txt .
COPY ./tools/fl_cha_repro.sh .
COPY ./tools/fl_lightcurve.sh .
COPY ./tools/fl_back7.sh .
COPY ./tools/fl_fluximage_new.sh .
COPY ./tools/fl_bkchipreg77.sh .
COPY ./tools/fl_fluximage_ccd_hard.sh .    
COPY ./tools/fl_hard_cornorm.sh .
COPY ./tools/fl_imgall_new.sh .
COPY ./tools/fl_wavedetect_new.sh .
COPY ./tools/python fl_dmfilth.py .
COPY ./tools/fl_dmfilth.sh .
COPY ./tools/data_prep.sh .

RUN pip install --upgrade pip
RUN pip install -r dependencies.txt
COPY ciao-install .
RUN ciao-install 
RUN data_prep.sh
CMD ["python", "./v2fits.py"]
