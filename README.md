# Utilidades para configuracion de las conexiones
>Buenas practicas hechas codigo

Objetivos primarios:

+ Proyecto independiente del entorno remoto. Se debería poder pasar un parametro con el nombre del entorno, que hemos de tener configurado en `envs/<nombre_entorno>`
+ Conexion SSH fácil (config)
+ Trivializacion de la creacion de Tunel (alias + config)
+ Trivializacion de la subida por HttpFS (alias)

Estructura a respetar:

```{bash}
bin
└── <ARCHIVOS BINARIOS>
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
README.md <DOCUMENTACION ES CRUCIAL PARA LA ADOPCION>

```
