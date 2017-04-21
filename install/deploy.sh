#!/bin/bash


function apply_template () {
  #No jinja? no problem
  TEMPLATED_FILE=$1
  VARIABLES=$2
  source $VARIABLES
  # DEBE EXISTIR ESTE FICHERO "environment_user", en teoria lo crea el deploy
  source $VARIABLES"_user"
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
  echo "Using default environment: ${DEFAULT_ENVIRONMENT}"
  export ENV=${DEFAULT_ENVIRONMENT}
  export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}"
  export ENVIRONMENT_USER_FILE="${ENVIRONMENT_FILE}_user"
  export USER_NAME=`whoami`
  echo "export USER_NAME=`whoami`" > ${ENVIRONMENT_USER_FILE}
  echo "Connecting whith the user `whoami`"
  source ${ENVIRONMENT_FILE}
elif [[ $# == 1 ]]; then
  export ENV=$1
  export USER_NAME=`whoami`
  echo "Connecting whith the user `whoami` to the environment ${ENV}"
  export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}"
  export ENVIRONMENT_USER_FILE="${ENVIRONMENT_FILE}_user"
  echo "export USER_NAME=`whoami`" > ${ENVIRONMENT_USER_FILE}
  if [[ ! -f ${ENVIRONMENT_FILE} ]]; then
    print_message wrong_environment.txt
    exit 1
  else
    source ${ENVIRONMENT_FILE}
  fi
elif [[ $# == 2 ]]; then
  export ENV=$1
  export USER_NAME=$2
  echo "Connecting whith the user ${USER_NAME} to environment ${ENV}"
  export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}"
  export ENVIRONMENT_USER_FILE="${ENVIRONMENT_FILE}_user"
  echo "export USER_NAME=${USER_NAME}" > ${ENVIRONMENT_USER_FILE}
  if [[ ! -f ${ENVIRONMENT_FILE} ]]; then
    print_message wrong_environment.txt
    exit 1
  else
    source ${ENVIRONMENT_FILE}
  fi
else
  print_message usage_install.txt
  exit 1
fi

if [[ ! -f ${SSH_USER_CONF} ]]; then
 mkdir -p $(dirname ${SSH_USER_CONF})
 touch ${SSH_USER_CONF}
 chmod 644 ${SSH_USER_CONF}
fi

if [[ ! -f ${SOURCE_ON_LOGIN} ]]; then
 touch ${SOURCE_ON_LOGIN}
fi

if grep -q "${PROXY_HOST}" ${SSH_USER_CONF}; then
  print_message already_installed.txt
else
  mkdir -p `dirname ${SSH_USER_CONF}`
  apply_template ${PROXY_CONF_FILE} ${ENVIRONMENT_FILE} >> ${SSH_USER_CONF}
  apply_template ${ALIAS_CONF_FILE} ${ENVIRONMENT_FILE} >> ${SOURCE_ON_LOGIN}
  if grep -q "Generated with conf_utils" ${SOURCE_ON_LOGIN}; then
    echo "PATH already updated"
  else
    echo "# Generated with conf_utils:" >> ${SOURCE_ON_LOGIN}
    echo "export PATH=\$PATH:${PROJECT_ROOT}/bin" >> ${SOURCE_ON_LOGIN}
  fi
  for element in $CONSOLE; do
    CONSOLE_SOURCE=${HOME}"/."${element}"rc"
    if [[ -f ${CONSOLE_SOURCE} ]] && ! grep -q "conf_utils installed" ${CONSOLE_SOURCE} ; then
      echo "Installing version for ${element}"
      echo "# conf_utils installed" >> ${CONSOLE_SOURCE}
      echo "source ${SOURCE_ON_LOGIN}" >> ${CONSOLE_SOURCE}
      if [[ ${element} == "bash" ]]; then
        echo "Sourcing bash profile:"
        source ${CONSOLE_SOURCE}
      else
        echo "Reload your ${CONSOLE_SOURCE} file"
      fi
      echo
    fi
  done
fi

print_message execution_finished.txt
#firefox ${DOCU_URL} 2&>1 >/dev/null || cat "${PROJECT_ROOT}/README.md"
