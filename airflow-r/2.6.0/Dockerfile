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
RUN R -e "install.packages('tidyverse', dependencies = TRUE)"
RUN R -e "install.packages('Rglpk', dependencies = TRUE)"

RUN R -e "IRkernel::installspec(user = FALSE)"
