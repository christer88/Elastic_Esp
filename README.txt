# Instalador para Elasticsearch, Kibana, Filebeat, Suricata, Zeek y Arkime

## ACERCA DE

Este script se utiliza para instalar, en orden, las siguientes herramientas:
- Elasticsearch
- Kibana
- Filebeat
- Suricata
- Zeek
- Arkime

El script está dividido en 9 partes. Cada una de ellas se puede ejecutar de forma independiente proporcionando los argumentos requeridos al ejecutar cada script. Puedes verificar los argumentos necesarios viendo el contenido de cada script. En las primeras líneas de cada archivo, se asignan variables necesarias para su correcto funcionamiento.

## INSTALL.SH

Debes ejecutar este script como superusuario (root) y darle permisos de ejecución. Puedes hacerlo de la siguiente manera:

- _sudo su -_
- _chmod u+x install.sh_
- _./install.sh_

Antes de ejecutarlo, debes modificar la versión del software que se instalará (puede ser la versión proporcionada, probada y funcionando). Esto se aplica a Elasticsearch, Kibana y Filebeat; todos deben tener la misma versión. Asegúrate de verificar que todas estas herramientas estén disponibles en la misma versión antes de hacer cambios.

## GET_REQUIREMENTS.SH

El enlace en este script para Arkime está configurado para Ubuntu 22.04. Si estás ejecutando el script en un sistema diferente, debes reemplazar el enlace de donde se descargará Arkime.

## INSTALL_ELASTIC.SH

### [AYUDA](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)

### DEPURACIÓN
- _/etc/elasticsearch/elasticsearch.yml_ - archivo de configuración
- _systemctl status elasticsearch_
- _/var/log/elasticsearch/_ - registros de Elasticsearch

## INSTALL_KIBANA.SH

### [AYUDA](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)

### DEPURACIÓN
- _/etc/kibana/kibana.yml_ - archivo de configuración
- _systemctl status kibana_
- _/var/log/kibana/kibana.log_ - registros de Kibana

## INSTALL_FILEBEAT.SH

### [AYUDA](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html)

### DEPURACIÓN
- _systemctl status filebeat.service_
- _/etc/filebeat/filebeat.yml_ - archivo de configuración

## INSTALL_SURICATA.SH

### [AYUDA](https://www.digitalocean.com/community/tutorials/how-to-install-suricata-on-ubuntu-20-04)

### DEPURACIÓN
- _systemctl status suricata.service_
- _/etc/suricata/suricata.yml_ - archivo de configuración
- _/var/log/suricata/suricata.log_ - registros de Suricata (útil con _tail -f_)

## INSTALL_ZEEK.SH

Durante la instalación de Zeek, se abrirá la línea de comandos de Zeek. En ese momento, debes ejecutar los siguientes comandos en secuencia:
- install
- start
- deploy
- stop
- exit

### [AYUDA](https://docs.zeek.org/en/master/quickstart.html)

### DEPURACIÓN
- _/opt/zeek/etc/node.cfg_ - archivo de configuración
- _/etc/filebeat/modules.d/zeek.yml_ - archivo de configuración

## INSTALL_ARKIME.SH

### **IMPORTANTE**
Cuando instales Arkime y se te pida la dirección de Elasticsearch, debes proporcionar solo la dirección IP, por ejemplo, si la dirección de Elasticsearch es _https://192.168.1.1:9200_, solo debes ingresar _192.168.1.1_. Esto no afectará el funcionamiento posterior del programa, ya que los datos se reemplazarán después de la instalación de Arkime. Sin embargo, es importante para el script, que busca ciertos datos para reemplazarlos.

### [AYUDA](https://kifarunix.com/install-arkime-moloch-full-packet-capture-tool-on-ubuntu/)

### DEPURACIÓN
- _/opt/arkime/etc/config.ini_ - archivo de configuración
- _systemctl status arkimeviewer arkimecapture_

En resumen, este script es una guía completa para instalar y configurar un conjunto de herramientas para la monitorización de la red y análisis de registros en un servidor Ubuntu. Asegúrate de seguir las instrucciones detalladas y ajustar las versiones y configuraciones según sea necesario antes de ejecutarlo.