VERSION=$1
SERVER_ADDRESS=$2
ELASTIC_USERNAME=$3
ELASTIC_PASSWORD=$4
KIBANA_USERNAME=$5
KIBANA_PASSWORD=$6

# Verificar si Elasticsearch no está instalado y, si es así, instalarlo
if ! apt list --installed 2>/dev/null | grep -q elasticsearch; then
    sudo dpkg -i elasticsearch-$VERSION-amd64.deb

    if ! apt list --installed 2>/dev/null | grep elasticsearch; then
        exit 1
    fi

    echo -------------------------------------------------------------
    echo ELASTICSEARCH INSTALADO CON ÉXITO
    echo -------------------------------------------------------------
fi

# Verificar si el archivo de configuración elasticsearch.yml está presente
if ! ls /etc/elasticsearch/ | grep -q elasticsearch.yml; then
    echo FALTA EL ARCHIVO DE CONFIGURACIÓN elasticsearch.yml
    echo Si está instalando Elasticsearch nuevamente en la misma máquina y eliminó Elasticsearch anteriormente,
    echo intente ejecutar el comando 'apt purge elasticsearch'.
    exit 1
fi

# Configurar el archivo de configuración elasticsearch.yml
sudo sed -i "s|#node.name: node-1|node.name: node-1" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|#network.host: 192.168.0.1|network.host: $SERVER_ADDRESS|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|#http.port: 9200|http.port: 9200|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|#discovery.seed_hosts: \[\"host1\", \"host2\"\]|discovery.seed_hosts: \[\"host1\"\]\ndiscovery.type: single-node|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|http.host: 0.0.0.0|http.host: $SERVER_ADDRESS|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|cluster.initial_master_nodes: \[\"$HOSTNAME\"\]|# cluster.initial_master_nodes: \[\"$HOSTNAME\"\]|" /etc/elasticsearch/elasticsearch.yml

# Iniciar el servicio de Elasticsearch
echo Iniciando el servicio.
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
echo -------------------------------------------------------------

# Crear usuarios en Elasticsearch
echo Creando usuarios.
if sudo /usr/share/elasticsearch/bin/elasticsearch-users list | grep -w "$ELASTIC_USERNAME"; then
    sudo /usr/share/elasticsearch/bin/elasticsearch-users userdel $ELASTIC_USERNAME;
fi

if sudo /usr/share/elasticsearch/bin/elasticsearch-users list | grep -w "$KIBANA_USERNAME"; then
    sudo /usr/share/elasticsearch/bin/elasticsearch-users userdel $KIBANA_USERNAME;
fi

sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd $ELASTIC_USERNAME -p $ELASTIC_PASSWORD -r superuser;
sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd $KIBANA_USERNAME -p $KIBANA_PASSWORD -r kibana_system;
echo -------------------------------------------------------------

# Dar permisos a los certificados para otros servicios
sudo chmod 777 /etc/elasticsearch
sudo chmod 777 /etc/elasticsearch/certs
sudo chmod 777 /etc/elasticsearch/certs/http_ca.crt
echo -------------------------------------------------------------
