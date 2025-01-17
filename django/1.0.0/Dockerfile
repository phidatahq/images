FROM agno/python:3.12
LABEL maintainer="Ashpreet Bedi <ashpreet@agno.com>"

# Define user and application directory
ARG USER=app
ARG APP_DIR=/home/${USER}/app
ENV APP_DIR=${APP_DIR}

# Add APP_DIR to PYTHONPATH
ENV PYTHONPATH="${APP_DIR}:${PYTHONPATH}"

# Create user and home directory
RUN groupadd -g 61000 ${USER} \
    && useradd -g 61000 -u 61000 -ms /bin/bash -d /home/${USER} ${USER}

# Update pip
RUN pip install --upgrade pip

# Copy pinned requirements
COPY requirements/requirements.txt /tmp/requirements.txt

# Install pinned requirements
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

# Create application directory and set permissions
RUN mkdir -p ${APP_DIR} \
    && chown -R ${USER}:${USER} ${APP_DIR}

# Switch to the app user
USER ${USER}

# Copy application source code
COPY --chown=${USER}:${USER} app ${APP_DIR}

# Copy entrypoint script
COPY --chown=${USER}:${USER} scripts /scripts
RUN chmod +x /scripts/entrypoint.sh

# Set working directory
WORKDIR ${APP_DIR}

# Expose the port Django runs on
EXPOSE 8000

# Run the entrypoint script
ENTRYPOINT ["/scripts/entrypoint.sh"]

# Default command to start Gunicorn
CMD ["gunicorn", "app.wsgi:application", "--bind", "0.0.0.0:8000"]