FROM python:latest

RUN mkdir -p /usr/src/astro/spec_analysis/tools

WORKDIR /usr/src/astro/spec_analysis/tools

#COPY A1763_img5_exp.fits .
#COPY A1763_bg5_exp.fits .
COPY ./tools .
COPY requirements.txt .


RUN pip install --upgrade pip
RUN pip install -r requirements.txt
#COPY /tools/ciao-install .
CMD ["ciao-install"]
CMD ["data_prep.sh"]
CMD ["python", "./v2fits.py"]


#Docker is not using my changes when updating my cwd path why? Causing the fits file not to be found