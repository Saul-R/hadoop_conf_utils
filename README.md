# Utilidades para configuracion de las conexiones
> Facilitador de buenas practicas en las conexiones.

## Install 

Para instalar:

`install/deploy.sh <env>`

Donde `<env>` es la configuración del entorno que se quiere instalar. Este `<env>` debe existir en la ruta `envs/<env>`. Por ejemplo:

`install/deploy.sh acens`

Ha de existir el archivo `envs/acens`. Este archivo tiene que contener las variables correspondientes al entorno.


Objetivos primarios:

+ Proyecto independiente del entorno remoto. Se debería poder pasar un parametro con el nombre del entorno, que hemos de tener configurado en `envs/<nombre_entorno>`
+ Conexion SSH fácil (config)
+ Trivializacion de la creacion de Tunel (alias + config)
+ Trivializacion de la subida por HttpFS (alias)

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


Actualmente el proceso hace accesible una utilidad
