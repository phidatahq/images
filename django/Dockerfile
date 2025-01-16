FROM phidata/python:3.11.5
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Create user and home directory
ARG USER=app
ARG APP_DIR=${USER_LOCAL_DIR}/${USER}
ENV APP_DIR=${APP_DIR}
# Add APP_DIR to PYTHONPATH
ENV PYTHONPATH="${APP_DIR}:${PYTHONPATH}"

# Create user and home directory
RUN groupadd -g 61000 ${USER} \
    && useradd -g 61000 -u 61000 -ms /bin/bash -d ${APP_DIR} ${USER}

# Update pip
RUN pip install --upgrade pip

# Copy pinned requirements
COPY requirements/requirements.txt /requirements.txt

# Install pinned requirements
RUN pip install -r /requirements.txt

# Copy Django app files
COPY app ${APP_DIR}

# Copy entrypoint script
COPY scripts /scripts

# Set working directory
WORKDIR ${APP_DIR}

# Expose the port Django runs on
EXPOSE 8000

# Run the entrypoint script
ENTRYPOINT ["/scripts/entrypoint.sh"]

# Default command to run migrations and start Django server
CMD ["gunicorn", "app.wsgi:application", "--bind", "0.0.0.0:8000"]