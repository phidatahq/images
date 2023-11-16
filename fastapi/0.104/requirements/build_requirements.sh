#!/bin/bash

############################################################################
# Build requirements file. Run this inside a virtual env.
############################################################################

set -e

REQUIREMENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CUSTOM_COMPILE_COMMAND="./requirements/build_requirements.sh" \
    pip-compile --upgrade --no-annotate --pip-args "--no-cache-dir" \
    -o ${REQUIREMENTS_DIR}/requirements.txt \
    ${REQUIREMENTS_DIR}/requirements.in
