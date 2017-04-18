#!/bin/bash
#set -x

export PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source $PROJECT_ROOT"/conf/global_conf"

if [[ $# == 0 ]]; then
  echo "Introduzca como parámetro el entorno a desinstalar."
  exit 1
elif [[ $# == 1 ]]; then
  export ENV=$1
  export ENVIRONMENT_FILE="${PROJECT_ROOT}/envs/${ENV}"
  if [[ ! -f ${ENVIRONMENT_FILE} ]]; then
    exit 1	
  else
    source ${ENVIRONMENT_FILE}
    source "${ENVIRONMENT_FILE}_user"
  fi
fi

#Borramos las lineas que tengan que ver con el entorno solicitado del fichero CONFIG

sed -i "/${ENV}/d" ${HOME}/.ssh/config
sed -i "/${ENV_IP}/d" ${HOME}/.ssh/config
sed -i "/${SSH_PORT}/d" ${HOME}/.ssh/config
sed -i "/${USER_NAME}/d" ${HOME}/.ssh/config
#Borramos las lineas que tengan que ver con el entorno solicitado del fichero ALIAS
sed -i "/${ENV}/d" ${HOME}/.conf_utils

rm "${ENVIRONMENT_FILE}_user"
