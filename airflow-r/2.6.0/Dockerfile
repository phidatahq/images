FROM phidata/airflow:2.6.0
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

ENV DEBIAN_FRONTEND=noninteractive

# Install the dependencies necessary to add a new repository
RUN set -x \
  && apt-get update \
  && apt-get install -y \
  dirmngr apt-transport-https ca-certificates software-properties-common gnupg2

# Enable the CRAN repository and add the CRAN GPG key
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran40/'

# Install base libraries
RUN set -x \
  && apt-get update \
  && apt-get install -y \
  r-base \
  r-base-dev \
  r-recommended \
  gcc \
  gfortran \
  nodejs \
  npm \
  # - pandoc is used to convert notebooks to html files
  #   it's not present in aarch64 ubuntu image, so we install it here
  pandoc \
  postgresql-client \
  unixodbc \
  unixodbc-dev \
  libglpk-dev \
  yarn \
  && pip install -U pip pip-tools setuptools wheel fsspec

# Install jupyterlab
ARG JUPYTERLAB_VERSION=3.5.2
ENV JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION}
RUN pip install jupyterlab==${JUPYTERLAB_VERSION}

# Install jupyter notebooks
ARG NOTEBOOK_VERSION=6.5.2
ENV NOTEBOOK_VERSION=${NOTEBOOK_VERSION}
RUN pip install notebook==${NOTEBOOK_VERSION}

# Install R libraries
RUN R -e "install.packages('devtools', dependencies = TRUE)"
RUN R -e "install.packages('e1071', dependencies = TRUE)"
RUN R -e "install.packages('forecast', dependencies = TRUE)"
RUN R -e "install.packages('hexbin', dependencies = TRUE)"
RUN R -e "install.packages('IRkernel', dependencies = TRUE)"
RUN R -e "install.packages('randomforest', dependencies = TRUE)"
RUN R -e "install.packages('rcurl', dependencies = TRUE)"
RUN R -e "install.packages('rmarkdown', dependencies = TRUE)"
RUN R -e "install.packages('rodbc', dependencies = TRUE)"
RUN R -e "install.packages('rsqlite', dependencies = TRUE)"
RUN R -e "install.packages('shiny', dependencies = TRUE)"
RUN R -e "install.packages('Rglpk', dependencies = TRUE)"

RUN R -e "IRkernel::installspec(user = FALSE)"
