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

# Install R
RUN set -x \
  && apt-get update \
  && apt-get install -y \
  r-base \
  r-base-dev \
  r-recommended

# Install R libraries
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('e1071')"
RUN R -e "install.packages('forecast')"
RUN R -e "install.packages('hexbin')"
RUN R -e "install.packages('irkernel')"
RUN R -e "install.packages('randomforest')"
RUN R -e "install.packages('rcurl')"
RUN R -e "install.packages('rmarkdown')"
RUN R -e "install.packages('rodbc')"
RUN R -e "install.packages('rsqlite')"
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('tidyverse')"
