#!/bin/bash

############################################################################
#
# Script to merge/push existing branch to the mainbranch:
# Usage:
#   ./scripts/merge.sh
#     - commit current branch
#     - merge to `main` branch
#     - push to remote origin `main` branch
#
#   ./scripts/merge.sh y
#     - Default yes to user validation
#
############################################################################

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHILAB_DIR="$( dirname ${SCRIPTS_DIR} )"
source ${SCRIPTS_DIR}/_utils.sh

main() {
  YES=0
  if [[ "$#" -eq 1 ]] && [[ "$1" = "y" ]]; then
    YES=1
  fi

  GIT_BRANCH=`git -C ${PHILAB_DIR} rev-parse --abbrev-ref HEAD`
  GIT_COMMIT=`git -C ${PHILAB_DIR} rev-parse HEAD`

  print_horizontal_line
  print_info_2 "PHILAB_DIR       : ${PHILAB_DIR}"
  print_info_2 "GIT_BRANCH       : ${GIT_BRANCH}"
  print_info_2 "GIT_COMMIT       : ${GIT_COMMIT}"
  print_info_2 "DATETIME         : $(date)"
  print_horizontal_line

  print_info_2 "Auto commiting all files in ${PHILAB_DIR}"
  if [[ ${YES} -ne 1 ]]; then
    space_to_continue
  fi
  git -C ${PHILAB_DIR} add .
  git -C ${PHILAB_DIR} commit -am "Auto commit at $(date)"

  print_info "Merging ${GIT_BRANCH} to main branch"
  git -C ${PHILAB_DIR} checkout main
  git -C ${PHILAB_DIR} merge --no-ff ${GIT_BRANCH}
  git -C ${PHILAB_DIR} push -f origin main
  print_info "philab pushed to main"
}

main "$@"
