FROM python:latest

RUN mkdir -p /usr/src/astro/spec_analysis/tools
RUN mkdir -p /usr/src/astro/spec_analysis/data

WORKDIR /usr/src/astro/spec_analysis/tools

COPY /data/A1763_img5_exp.fits .
COPY /data/A1763_bg5_exp.fits .
COPY ./tools .
COPY ./data .
COPY requirements.txt .


RUN pip install --upgrade pip
RUN pip install -r requirements.txt
COPY /tools/ciao-install .
CMD ["ciao-install"]
#CMD ["bash", "/data_prep/data_prep.sh"]
CMD ["python", "./v2fits.py"]
#CMD ["bash", "specextract"]
#CMD ["bash", "spec.sh"]
#CMD ["bash", "xspec" "- A1763.xcm"]


##Docker is not using my changes when updating my cwd path why? Causing the fits file not to be found