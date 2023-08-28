#!/bin/bash

CURRENT_COUNTER=1
VERSION=8.7.0
LINE="-------------------------------------------------------------"
DOUBLE_LINE="============================================================"
ELASTIC_USERNAME=""
ELASTIC_PASSWORD=""
KIBANA_USERNAME=""
KIBANA_PASSWORD=""
SERVER_ADDRESS=""
MASK=""
LISTENING_INTERFACE=""

function obtener_entradas() {
    read -p 'Ingrese el nombre de usuario de Elasticsearch: ' ELASTIC_USERNAME
    obtener_contraseña "ELASTIC_PASSWORD"

    read -p 'Ingrese el nombre de usuario de Kibana: ' KIBANA_USERNAME
    obtener_contraseña "KIBANA_PASSWORD"

    read -p 'Ingrese la dirección IP del servidor: ' SERVER_ADDRESS
    read -p 'Máscara de subred (por ejemplo, 24): ' MASK

    echo $LINE
    tcpdump --list-interfaces
    echo $LINE
    read -p 'Ingrese la interfaz desde la cual se escuchará el tráfico (por ejemplo, eth0, local): ' LISTENING_INTERFACE
}

function obtener_contraseña() {
    local temp=""
    local temp2="?"
    while [ ! "$temp" = "$temp2" ]; do
        read -sp 'Ingrese la contraseña para el usuario: ' temp
        echo
        read -sp 'Repita la contraseña: ' temp2
        echo
        if [ ! "$temp" = "$temp2" ]; then
            echo "Inténtelo de nuevo, las contraseñas no coinciden."
        fi
    done
    eval "$1"="$temp"
}

function ejecutar_scripts() {
    for i in ${!SCRIPTS[@]}; do
        echo $LINE
        echo [$CURRENT_COUNTER/${#SCRIPTS[@]}] ${TITLES[i]}
        echo $LINE
        if ! ${SCRIPTS[i]}; then
            if [ $i == 0 ]; then
                echo "El script se detuvo porque uno de los recursos no existe en el disco o el enlace para descargarlo no funciona."
                echo "Puede intentar editar este script y configurar el valor de la variable VERSION a otra versión de Elasticsearch/Kibana/Filebeat."
                echo "La versión actual especificada puede que ya no esté disponible."
                exit 1
            fi

            echo "INTERRUPCIÓN DEL SCRIPT, YA QUE UNA DE LAS CONDICIONES NO SE CUMPLIÓ."
            exit 1
        fi
        ((CURRENT_COUNTER++))
        echo $DOUBLE_LINE
    done
}

sudo chmod 777 install_elasticsearch.sh install_kibana.sh install_filebeat.sh install_suricata.sh install_zeek.sh install_arkime.sh get_requirements.sh clean.sh
obtener_entradas

SCRIPTS=(
    "./get_requirements.sh $VERSION"
    "./install_elasticsearch.sh $VERSION $SERVER_ADDRESS $ELASTIC_USERNAME $ELASTIC_PASSWORD $KIBANA_USERNAME $KIBANA_PASSWORD"
    "./install_kibana.sh $VERSION $SERVER_ADDRESS $KIBANA_USERNAME $KIBANA_PASSWORD"
    "./install_filebeat.sh $VERSION $SERVER_ADDRESS $ELASTIC_USERNAME $ELASTIC_PASSWORD"
    "./install_suricata.sh $SERVER_ADDRESS $MASK $LISTENING_INTERFACE"
    "./install_zeek.sh $SERVER_ADDRESS $LISTENING_INTERFACE"
    "./install_arkime.sh $ELASTIC_USERNAME $ELASTIC_PASSWORD $SERVER_ADDRESS"
    "./clean.sh $VERSION"
)

TITLES=(
    "DESCARGANDO RECURSOS NECESARIOS"
    "INSTALANDO ELASTICSEARCH"
    "INSTALANDO KIBANA"
    "INSTALANDO FILEBEAT"
    "INSTALANDO SURICATA"
    "INSTALANDO ZEEK"
    "INSTALANDO ARKIME"
    "LIMPIANDO DESPUÉS DE LA INSTALACIÓN"
)

ejecutar_scripts

echo "INSTALACIÓN COMPLETADA"
