FROM phidata/python:3.9.12
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

ARG USER=app
ARG HOME_DIR=${USER_LOCAL_DIR}/${USER}
ENV HOME_DIR=${HOME_DIR}
# Add HOME_DIR to PYTHONPATH
ENV PYTHONPATH="${HOME_DIR}:${PYTHONPATH}"

# Create user and home directory
RUN groupadd -g 61000 ${USER} \
  && useradd -g 61000 -u 61000 -ms /bin/bash -d ${HOME_DIR} ${USER}

COPY ./requirements /requirements
RUN pip install -r /requirements/requirements-base.txt

USER ${USER}
WORKDIR ${HOME_DIR}
COPY scripts /scripts
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]