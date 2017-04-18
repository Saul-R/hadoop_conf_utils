# Utilidades para configuracion de las conexiones
> Facilitador de buenas practicas en las conexiones.

## Install 

Para instalar:

`install/deploy.sh <env>`

Donde `<env>` es la configuración del entorno que se quiere instalar. Este `<env>` debe existir en la ruta `envs/<env>`. Por ejemplo:

`install/deploy.sh acens`

Ha de existir el archivo `envs/acens`. Este archivo tiene que contener las variables correspondientes al entorno.

## Update

Para poder actualizar:

`install/update.sh <env>`

Donde `<env>` es el entorno que queremos actualizar. Este `<env>` tiene que estar en la ruta `envs/<env>`. Por ejemplo:

`install/update.sh <env>`

## Uninstall

Para desinstalar:

`install/uninstall.sh <env>`

Donde `<env>` es el entorno que queremos desinstalar. Este `<env>` tiene que estar en la ruta `envs/<env>`. Por ejemplo:

`install/uninstall.sh <env>`.

Al ejecutar este script, lo que hacemos es borrar la configuración que tenía el entorno indicado en los siguientes ficheros de configuración:

+ ~/.ssh/config
+ ~/.config_utils

## Ficheros de configuración

Los ficheros de configuración se encuentran bajo la ruta `~/conf_utils/conf/` son los siguientes:

+ `alias_conf`: Utilizado para poder crear los alias que serán utilizados para:
    + `proxy_up_<env>`: Levantará un túnel para poder conectarse directamente al entorno especificado con `<env>`.
    + `httpfs_test_<env>`: Creará una conexión httpfs de prueba para ver si podemos llegar con nuestro usuario al entorno.
+ `global_conf`: Se encuentran las variables de configuración que utilizarán los scripts a la hora de ejecutarse. Algunas de ellas son:
    + Nombre de usuario.
    + Entorno por defecto (se utiliza acens).
    + Rutas donde se alojan los ficheros de configuración dentro del sistema.
    + Tipos de consola que tiene instalado el usuario en su máquina.
+ `proxy_conf`: Fichero de configuración, que creará en la configuración local, las variables necesarias para poder establecer la conexión con el entorno deseado.

## Configuración de entornos

Para poder crear un entorno, lo que se necesita es crear un fichero con el nombre deseado en la ruta `~/config_utils/envs`. La estructura del fichero tiene que ser la siguiente:

---------------------------------

|Variable|Descripción|
|----|----|
|`export PROXY_HOST="PROXY"`                                         | Se tiene que cambiar "PROXY", por el alias que queramos darle al nuevo entorno. |
|`export ENV_IP="IP"`                                                | Se tiene que sustituir "IP" por el valor de la IP del entorno que necesitemos acceder.|
|`export SSH_PORT=PORT`                                              | Se tiene que sustituir "PORT" por el valor del puerto por el que necesitemos acceder al entorno.|
|`export PROXY_PORT=PORT`                                            | Se tiene que sustituir "PORT" por el valor del puerto que se utilizará para realizar el proxy.|
|`export ALIAS_HOST="ALIAS"`                                         | Se tiene que susutituir la palabra "ALIAS" por el valor del alias que tiene el entorno asignado.|
|`export HTTPFS_IP=IP`                                               | Se tiene que sustituir la palabra "IP" por el valor de la IP que tenga instalado el servicio httpfs.|
|`export HTTPFS_PORT=PORT`                                           | Se tiene que sustituir el valor "PORT" por el puerto en el que se encuentre el servicio httpfs en el entorno. |
|`export HTTPFS_URL="http://${HTTPFS_IP}:${HTTPFS_PORT}/webhdfs/v1"` | Se tiene que añadir esta línea, que será la encargada de crear la URL para generar la llamada a httpfs.|


### Objetivos primarios:

+ Proyecto independiente del entorno remoto. Se debería poder pasar un parámetro con el nombre del entorno, que hemos de tener configurado en `envs/<nombre_entorno>`
+ Conexión SSH fácil (config)
+ Trivialización de la creación de Túnel (alias + config)
+ Trivialización de la subida por HttpFS (alias)

Estructura:

```{bash}
install
└── <DESPLIEGUE / INSTALACION>
bin
└── <SCRIPTS AUXILIARES PARA INCLUIR EN $PATH>
conf
├── <CONFIGURACION_GLOBAL_SERVICIO1>
└── <CONFIGURACION_GLOBAL_SERVICIO2>
envs
├── <CONFIGURACION_ENTORNO1>
└── <CONFIGURACION_ENTORNO2>
messages
├── <COSAS QUE LLAMO CON PRINTF Y QUE ENGUARRARIAN EL CODIGO EG.>
├── start_message.txt
└── wrong_environment.txt
README.md <DOCUMENTACION>

```

### Release v1.0

Utilidades de esta release:
+ Deploy + Uninstall + Update
+ Httpfs a entorno remoto
  + Put: `httpfs_put <env> <fichero_local> <ruta HDFS>`
  + Test: `httpfs_test_<env>`
+ Configuracion para conexión sencilla a entornos `ssh <env>`.
+ Configuracion para tunel en modo demonio sencillo `proxy_up_<env>`



