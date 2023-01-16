FROM phidata/jupyter:3.5.2
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Install r pre-requisites
RUN set -x \
  && apt-get update \
  && apt-get -y install \
  r-cran-rodbc

# Install R packages including IRKernel
# r-e1071: dependency of the caret R package
RUN mamba install --quiet --yes \
  'r-base' \
  'r-caret' \
  'r-crayon' \
  'r-devtools' \
  'r-e1071' \
  'r-forecast' \
  'r-hexbin' \
  'r-htmltools' \
  'r-htmlwidgets' \
  'r-irkernel' \
  'r-nycflights13' \
  'r-randomforest' \
  'r-rcurl' \
  'r-rmarkdown' \
  'r-rodbc' \
  'r-rsqlite' \
  'r-shiny' \
  'r-tidyverse' \
  'unixodbc' && \
  mamba clean --all -f -y

# Clean
RUN apt-get autoremove -y --purge \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/* \
  /usr/share/man \
  /usr/share/doc \
  /usr/share/doc-base \
  && mamba clean --all -f -y \
  && npm cache clean --force \
  && jupyter lab clean
