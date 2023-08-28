ELASTIC_USERNAME=$1
ELASTIC_PASSWORD=$2
SERVER_ADDRESS=$3

# Verificar si Arkime no está instalado y, si es así, instalarlo
if ! apt list --installed 2>/dev/null | grep -q arkime; then
    sudo apt -y install ./arkime_4.1.0-1_amd64.deb

    if ! apt list --installed | grep -q arkime; then
        echo Error durante la instalación de Arkime.
        exit 1
    fi

    echo -------------------------------------------------------------
    echo ARKIME INSTALADO CON ÉXITO
    echo -------------------------------------------------------------
fi

echo Configurando Arkime
/opt/arkime/bin/Configure
sudo sed -i "s|elasticsearch=$SERVER_ADDRESS|elasticsearch=https://$ELASTIC_USERNAME:$ELASTIC_PASSWORD@$SERVER_ADDRESS:9200|" /opt/arkime/etc/config.ini
sudo sed -i "s|passwordSecret=password|passwordSecret=$ELASTIC_PASSWORD|" /opt/arkime/etc/config.ini
sudo sed -i "s|# certFile=/opt/arkime/etc/arkime.cert|certFile=/etc/elasticsearch/certs/http_ca.crt|" /opt/arkime/etc/config.ini
sudo sed -i "s|# caTrustFile=/opt/arkime/etc/roots.cert|caTrustFile=/etc/elasticsearch/certs/http_ca.crt|" /opt/arkime/etc/config.ini
sudo sed -i "s|rirFile=/opt/arkime/etc/ipv4-address-space.csv|# rirFile=/opt/arkime/etc/ipv4-address-space.csv" /opt/arkime/etc/config.ini
sudo sed -i "s|ouiFile=/opt/arkime/etc/oui.txt|# ouiFile=/opt/arkime/etc/oui.txt|" /opt/arkime/etc/config.ini

/opt/arkime/db/db.pl --insecure https://$ELASTIC_USERNAME:$ELASTIC_PASSWORD@$SERVER_ADDRESS:9200 init
echo -------------------------------------------------------------

echo Agregando usuario
/opt/arkime/bin/arkime_add_user.sh $ELASTIC_USERNAME "SuperAdmin" $ELASTIC_PASSWORD --admin
echo -------------------------------------------------------------

echo Reiniciando servicios
sudo systemctl daemon-reload
sudo systemctl enable --now arkimecapture
sudo systemctl enable --now arkimeviewer
echo -------------------------------------------------------------

echo Cambiando configuración de archivos
sudo sed -i 's/network.target/network.target elasticsearch.service/' /etc/systemd/system/arkimecapture.service /etc/systemd/system/arkimeviewer.service
sudo sed -i '/After=/a Requires=network.target elasticsearch.service' /etc/systemd/system/arkimecapture.service /etc/systemd/system/arkimeviewer.service
echo -------------------------------------------------------------

echo Reiniciando servicio
sudo systemctl daemon-reload
sudo systemctl restart arkimeviewer arkimecapture
echo -------------------------------------------------------------
