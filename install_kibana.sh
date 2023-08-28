VERSION=$1
SERVER_ADDRESS=$2
KIBANA_USERNAME=$3
KIBANA_PASSWORD=$4

# Verificar si Kibana no está instalado y, si es así, instalarlo
if ! apt list --installed 2>/dev/null | grep kibana; then
    sudo dpkg -i kibana-$VERSION-amd64.deb

    if ! apt list --installed 2>/dev/null | grep kibana; then
        echo Error durante la instalación de Kibana.
        exit 1
    fi

    echo -------------------------------------------------------------
    echo KIBANA INSTALADO CON ÉXITO
    echo -------------------------------------------------------------
fi

# Verificar si el archivo de configuración kibana.yml está presente
if ! ls /etc/kibana/kibana.yml; then
    echo FALTA EL ARCHIVO DE CONFIGURACIÓN kibana.yml
    echo Si está instalando Kibana nuevamente en la misma máquina y eliminó Kibana anteriormente,
    echo intente ejecutar el comando 'apt purge kibana'.
    exit 1
fi

# Configurar el archivo de configuración kibana.yml
echo Realizando cambios en el archivo de configuración.
sudo sed -i "s|#server.port: 5601|server.port: 5601|" /etc/kibana/kibana.yml
sudo sed -i "s|#server.host: \"localhost\"|server.host: \"$SERVER_ADDRESS\"|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.hosts: \[\"http://localhost:9200\"\]|elasticsearch.hosts: \[\"https://$SERVER_ADDRESS:9200\"\]|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.username: \"kibana_system\"|elasticsearch.username: \"$KIBANA_USERNAME\"|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.password: \"pass\"|elasticsearch.password: \"$KIBANA_PASSWORD\"|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.ssl.certificateAuthorities: \[ \"/path/to/your/CA.pem\" \]|elasticsearch.ssl.certificateAuthorities: \[ \"/etc/elasticsearch/certs/http_ca.crt\" \]|" /etc/kibana/kibana.yml
echo -------------------------------------------------------------

# Reiniciar el servicio de Kibana
echo Reiniciando el servicio.
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service
echo -------------------------------------------------------------
