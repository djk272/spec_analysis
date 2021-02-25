FROM python:latest

WORKDIR /usr/src/astro

#COPY A1763_img5_exp.fits .
#COPY A1763_bg5_exp.fits .
COPY v2fits.py .
COPY dependencies.txt .

RUN pip install --upgrade pip
RUN pip install -r dependencies.txt
COPY ciao-install .
RUN bash ciao-install 
#CMD ["python", "./v2fits.py"]
