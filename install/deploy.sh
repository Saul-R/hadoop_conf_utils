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

export PROJECT_ROOT="$(dirname $0)/.."
source $PROJECT_ROOT"/conf/global_conf"

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
fi

if grep -q "${PROXY_HOST}" ${SSH_USER_CONF}; then
  print_message already_installed.txt
else
  mkdir -p `dirname ${SSH_USER_CONF}`
  apply_template ${PROXY_CONF_FILE} ${ENVIRONMENT_FILE} >> ${SSH_USER_CONF}
  apply_template ${ALIAS_CONF_FILE} ${ENVIRONMENT_FILE} >> ${SOURCE_ON_LOGIN}
  if grep -q "PATH *=" ${SOURCE_ON_LOGIN}; then
      awk -v BINDIR=${PROJECT_ROOT}"/bin" '/PATH *=/ { print $0":"BINDIR }' ${SOURCE_ON_LOGIN}
  else
      echo "export PATH=\$PATH:${PROJECT_ROOT}/bin" >> ${SOURCE_ON_LOGIN}
  fi
  source ${SOURCE_ON_LOGIN}
fi

firefox ${DOCU_URL} 2&>1 >/dev/null || cat "${PROJECT_ROOT}/README.md"
