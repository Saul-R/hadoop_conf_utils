#!/bin/bash

function apply_template () {
  #No jinja? no problem
  TEMPLATED_FILE=$1
  VARIABLES=$2
  source $VARIABLES
  envsubst < "${TEMPLATED_FILE}"
}

function print_message() {
  MESSAGE_FILE=$1
  printf "$(<${MESSAGES}/${MESSAGE_FILE})"
}

export PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source $PROJECT_ROOT"/conf/global_conf"

print_message start_message.txt

if [[ $# == 0 ]]; then
  echo "Using default environment: ${DEFAULT_ENVIRONMENT}"
  export ENV=${DEFAULT_ENVIRONMENT}
  export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}"
elif [[ $# == 1 ]]; then
  export ENV=$1
  export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}"
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
  #if grep -q "PATH *=" ${SOURCE_ON_LOGIN}; then
  #    NEW_PATH_ENTRY=$(awk -v BINDIR=${PROJECT_ROOT}"/bin" '/PATH *=/ { print $0":"BINDIR }' ${SOURCE_ON_LOGIN})
  #    sed -i.bak "s@(PATH *=.*$)@$1:${PROJECT_ROOT}/bin@"
  #    sed "s@(PATH *=.*$)@$1:${PROJECT_ROOT}/bin@"
  #else
  #    echo "# Generated with conf_utils:" >> ${SOURCE_ON_LOGIN}
  #    echo "export PATH=\$PATH:${PROJECT_ROOT}/bin" >> ${SOURCE_ON_LOGIN}
  #fi
  if grep -q "Generated with conf_utils" ${SOURCE_ON_LOGIN}; then
    echo "PATH already updated"
  else
    echo "# Generated with conf_utils:" >> ${SOURCE_ON_LOGIN}
    echo "export PATH=\$PATH:${PROJECT_ROOT}/bin" >> ${SOURCE_ON_LOGIN}
  fi
  source ${SOURCE_ON_LOGIN}
fi

print_message execution_finished.txt
#firefox ${DOCU_URL} 2&>1 >/dev/null || cat "${PROJECT_ROOT}/README.md"
