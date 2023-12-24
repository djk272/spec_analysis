# Dockerfile for "a la carte" HEASoft downloads

FROM ubuntu:22.04

ARG version=6.32.1
ENV HEASOFT_VERSION=${version}

LABEL version="${version}" \
      description="HEASoft ${version} https://heasarc.gsfc.nasa.gov/lheasoft/" \
      maintainer="NASA/GSFC/HEASARC https://heasarc.gsfc.nasa.gov/cgi-bin/ftoolshelp"

# Install HEASoft prerequisites
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y install \
	gcc \
	gfortran \
	g++ \
	libcurl4 \
	libcurl4-gnutls-dev \
	libncurses5-dev \
	libreadline6-dev \
	make \
	ncurses-dev \
	perl-modules \
	python3-dev \
	python3-pip \
	python3-setuptools \
	python-is-python3 \
	tcsh \
	wget \
	xorg-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd heasoft && useradd -r -m -g heasoft heasoft \
 && mkdir -p /opt/heasoft/caldb \
 && chown -R heasoft:heasoft /opt/heasoft

USER heasoft
WORKDIR /home/heasoft

# Copy contents of the "a la carte" download into the container:
RUN mkdir -p heasoft-${version}
COPY --chown=heasoft:heasoft heasoft-${version} /home/heasoft/heasoft-${version}/
COPY --chown=heasoft:heasoft heasoft-${version}/Docker/caldb.config /opt/heasoft/caldb/
COPY --chown=heasoft:heasoft heasoft-${version}/Docker/alias_config.fits /opt/heasoft/caldb/

# Configure, make, install, clean up, and create symlinks....
RUN cd ${HOME}/heasoft-${HEASOFT_VERSION}/BUILD_DIR/ \
 && echo "Installing prerequisite Python packages..." \
 && pip3 install --only-binary=:all: astropy numpy scipy matplotlib \
 && echo "Configuring heasoft..." \
 && ./configure --prefix=/opt/heasoft 2>&1 | tee ${HOME}/configure.log \
 && echo "Building heasoft..." \
 && make 2>&1 | tee ${HOME}/build.log \
 && echo "Installing heasoft..." \
 && make install 2>&1 | tee ${HOME}/install.log \
 && echo "Cleaning heasoft..." \
 && make clean 2>&1 \
 && gzip -9 ${HOME}/*.log \
 && cp -p ${HOME}/heasoft-${HEASOFT_VERSION}/Release_Notes* /opt/heasoft/ \
 && /bin/bash -c 'cd /opt/heasoft/; for loop in x86_64*/*; do ln -sf $loop; done' \
 && /bin/bash -c 'cd /opt/heasoft/bin; if test -f ${HOME}/heasoft-${HEASOFT_VERSION}/Xspec/BUILD_DIR/hmakerc; then cp ${HOME}/heasoft-${HEASOFT_VERSION}/Xspec/BUILD_DIR/hmakerc .; fi' \
 && /bin/bash -c 'if test -f ${HOME}/heasoft-${HEASOFT_VERSION}/Xspec/src/spectral; then rm -rf ${HOME}/heasoft-${HEASOFT_VERSION}/Xspec/src/spectral; fi' \
 && cd /opt/heasoft/bin \
 && ln -sf ../BUILD_DIR/Makefile-std

# Configure shells...
RUN /bin/echo >> /home/heasoft/.bashrc \
 && /bin/echo '# Initialize HEASoft environment' >> /home/heasoft/.bashrc \
 && /bin/echo 'export HEADAS=/opt/heasoft' >> /home/heasoft/.bashrc \
 && /bin/echo '. $HEADAS/headas-init.sh' >> /home/heasoft/.bashrc \
 && /bin/echo >> /home/heasoft/.bashrc \
 && /bin/echo '# Initialize environment for CALDB' >> /home/heasoft/.bashrc \
 && /bin/echo 'export CALDB=https://heasarc.gsfc.nasa.gov/FTP/caldb' >> /home/heasoft/.bashrc \
 && /bin/echo 'export CALDBCONFIG=/opt/heasoft/caldb/caldb.config' >> /home/heasoft/.bashrc \
 && /bin/echo 'export CALDBALIAS=/opt/heasoft/caldb/alias_config.fits' >> /home/heasoft/.bashrc \
 && /bin/echo >> /home/heasoft/.profile \
 && /bin/echo '# Initialize HEASoft environment' >> /home/heasoft/.profile \
 && /bin/echo 'export HEADAS=/opt/heasoft' >> /home/heasoft/.profile \
 && /bin/echo '. $HEADAS/headas-init.sh' >> /home/heasoft/.profile \
 && /bin/echo >> /home/heasoft/.profile \
 && /bin/echo '# Initialize environment for CALDB' >> /home/heasoft/.profile \
 && /bin/echo 'export CALDB=https://heasarc.gsfc.nasa.gov/FTP/caldb' >> /home/heasoft/.profile \
 && /bin/echo 'export CALDBCONFIG=/opt/heasoft/caldb/caldb.config' >> /home/heasoft/.profile \
 && /bin/echo 'export CALDBALIAS=/opt/heasoft/caldb/alias_config.fits' >> /home/heasoft/.profile \
 && /bin/echo '# Initialize HEASoft environment' >> /home/heasoft/.cshrc \
 && /bin/echo 'setenv HEADAS /opt/heasoft' >> /home/heasoft/.cshrc \
 && /bin/echo 'source $HEADAS/headas-init.csh' >> /home/heasoft/.cshrc \
 && /bin/echo >> /home/heasoft/.cshrc \
 && /bin/echo '# Initialize environment for CALDB' >> /home/heasoft/.cshrc \
 && /bin/echo 'setenv CALDB https://heasarc.gsfc.nasa.gov/FTP/caldb' >> /home/heasoft/.cshrc \
 && /bin/echo 'setenv CALDBCONFIG /opt/heasoft/caldb/caldb.config' >> /home/heasoft/.cshrc \
 && /bin/echo 'setenv CALDBALIAS /opt/heasoft/caldb/alias_config.fits' >> /home/heasoft/.cshrc

ENV CC=/usr/bin/gcc \
    CXX=/usr/bin/g++ \
    FC=/usr/bin/gfortran \
    PERL=/usr/bin/perl \
    PERLLIB=/opt/heasoft/lib/perl \
    PERL5LIB=/opt/heasoft/lib/perl \
    PYTHON=/usr/bin/python \
    PYTHONPATH=/opt/heasoft/lib/python:/opt/heasoft/lib \
    PATH=/opt/heasoft/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    HEADAS=/opt/heasoft \
    LHEASOFT=/opt/heasoft \
    FTOOLS=/opt/heasoft \
    LD_LIBRARY_PATH=/opt/heasoft/lib \
    LHEAPERL=/usr/bin/perl \
    PFCLOBBER=1 \
    PFILES=/home/heasoft/pfiles;/opt/heasoft/syspfiles \
    FTOOLSINPUT=stdin \
    FTOOLSOUTPUT=stdout \
    LHEA_DATA=/opt/heasoft/refdata \
    LHEA_HELP=/opt/heasoft/help \
    EXT=lnx \
    PGPLOT_FONT=/opt/heasoft/lib/grfont.dat \
    PGPLOT_RGB=/opt/heasoft/lib/rgb.txt \
    PGPLOT_DIR=/opt/heasoft/lib \
    POW_LIBRARY=/opt/heasoft/lib/pow \
    XRDEFAULTS=/opt/heasoft/xrdefaults \
    TCLRL_LIBDIR=/opt/heasoft/lib \
    XANADU=/opt/heasoft \
    XANBIN=/opt/heasoft \
    CALDB=https://heasarc.gsfc.nasa.gov/FTP/caldb \
    CALDBCONFIG=/opt/heasoft/caldb/caldb.config \
    CALDBALIAS=/opt/heasoft/caldb/alias_config.fits

CMD [ "fversion" ]
