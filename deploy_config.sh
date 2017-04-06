#!/bin/bash

export PROJECT_ROOT="$0/.."
export DEFAULT_ENVIRONMENT="acens"
export CONF_FOLDER="${PROJECT_ROOT}/conf"
export MESSAGES="${PROJECT_ROOT}/messages"
export PROXY_CONF_FILE="${CONF_FOLDER}/proxy_conf"
export ALIAS_CONF_FILE="${CONF_FOLDER}/alias_conf"
export SOURCE_ON_LOGIN="${HOME}/.bashrc"
export SSH_USER_CONF="${HOME}/.ssh/config"

function apply_template () {
  #No jinja? no problem
  VARIABLES=$1
  TEMPLATED_FILE=$2
  source $VARIABLES
  envsubstr < $TEMPLATED_FILE
}

printf "${STARTUP_MESSAGE}/start_message.txt"

if [[ $# == 0 ]]; then
  echo "Using default envirnoment, ${DEFAULT_ENVIRONMENT}"
  export ENV=${DEFAULT_ENVIRONMENT}
elif [[ $# == 1 ]]; then
  export ENV=$1
  if [[! -f ${ENVIRONMENT_FILE} ]]; then
    printf "${STARTUP_MESSAGE}/wrong_environment.txt"
  fi
fi
export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}_conf"

if grep -q "${PROXY_HOST}" ${SSH_USER_CONF}; then
  echo -e "${MESSAGES}/already_installed.txt"
else
  apply_template ${ENVIRONMENT_FILE} ${CONF_FOLDER}/proxy_conf >> ${SSH_USER_CONF}
  apply_template ${ENVIRONMENT_FILE} ${CONF_FOLDER}/alias_conf >> ${SOURCE_ON_LOGIN}
fi

firefox ${DOCU_URL} || cat "${PROJECT_ROOT}/README.md"
