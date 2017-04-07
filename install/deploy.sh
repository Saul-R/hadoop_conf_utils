#!/bin/bash
function apply_template () {
  #No jinja? no problem
  TEMPLATED_FILE=$1
  VARIABLES=$2
  source $VARIABLES
  while read line; do
      eval echo "$line"
  done < ${TEMPLATED_FILE}
}

function print_message() {
  MESSAGE_FILE=$1
  printf "$(<${MESSAGES}/${MESSAGE_FILE})"
}

export PROJECT_ROOT="$0/.."
export DOCU_URL="http://dev.synergicpartners.com/srodriguez/conf_utils"
export DEFAULT_ENVIRONMENT="acens"
export SSH_USER_CONF="${HOME}/.ssh/config"
export CONF_FOLDER="${PROJECT_ROOT}/conf"
export PROXY_CONF_FILE="${CONF_FOLDER}/proxy_conf"
export ALIAS_CONF_FILE="${CONF_FOLDER}/alias_conf"
export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}_conf"
export SOURCE_ON_LOGIN="${HOME}/.bashrc"
export MESSAGES="${PROJECT_ROOT}/messages"

print_message start_message.txt

if [[ $# == 0 ]]; then
  echo "Using default envirnoment, ${DEFAULT_ENVIRONMENT}"
  export ENV=${DEFAULT_ENVIRONMENT}
elif [[ $# == 1 ]]; then
  export ENV=$1
  if [[! -f ${ENVIRONMENT_FILE} ]]; then
    print_message wrong_environment.txt
    exit 1
  fi
if grep -q "${PROXY_HOST}" ${SSH_USER_CONF}; then
  print_message already_installed.txt
else
  apply_template ${PROXY_CONF_FILE} ${ENVIRONMENT_FILE} >> ${SSH_USER_CONF}
  apply_template ${ALIAS_CONF_FILE} ${ENVIRONMENT_FILE} >> ${SOURCE_ON_LOGIN}
  if grep -q "PATH *=" ${SOURCE_ON_LOGIN}; then
      awk -v BINDIR=${PROJECT_ROOT}"/bin" '/PATH *=/ { print $0":"BINDIR }' ${SOURCE_ON_LOGIN}
  else
      echo "export PATH=\$PATH:${PROJECT_ROOT}/bin" >> ${SOURCE_ON_LOGIN}
  fi
  source ${SOURCE_ON_LOGIN}
fi

firefox ${DOCU_URL} || cat "${PROJECT_ROOT}/README.md"
