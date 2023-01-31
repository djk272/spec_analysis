FROM python:ubuntu

RUN	mkdir -p /usr/src/astro/spec_analysis/test &&\
	pip install --upgrade pip 

WORKDIR /astro/spec_analysis/test

#COPY requirements.txt .
COPY ciao-install .
COPY run_ciao.sh .

RUN pip install -r requirements.txt

CMD ["bash", "run_ciao.sh"]



##docker-compose up --build -d , will make the container

##docker run , will run container

## docker run -it --rm container_name , will run container in interactive mode to use the terminal manually and will remove itself when we exit