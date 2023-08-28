SERVER_ADDRESS=$1
MASK=$2
LISTENING_INTERFACE=$3

# Verificar si Suricata no está instalado y, si es así, instalarlo
if ! apt list --installed 2>/dev/null | grep -q suricata; then
    sudo add-apt-repository ppa:oisf/suricata-stable
    sudo apt -y install suricata

    if ! apt list --installed 2>/dev/null | grep -q suricata; then
        echo Error durante la instalación de Suricata.
        exit 1
    fi

    echo -------------------------------------------------------------
    echo SURICATA INSTALADO CON ÉXITO
    echo -------------------------------------------------------------
fi

# Habilitar y detener el servicio de Suricata
sudo systemctl enable suricata.service
sudo systemctl stop suricata.service

# Configurar Suricata
echo Configurando.
sudo sed -i "s|HOME_NET: \"\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12\]\"|HOME_NET: \"\[$SERVER_ADDRESS/$MASK\]\"|" /etc/suricata/suricata.yaml
sudo sed -i "s|- interface: eth0|- interface: $LISTENING_INTERFACE|" /etc/suricata/suricata.yaml

# Actualizar reglas de Suricata
sudo suricata-update
sudo suricata-update list-sources
sudo suricata -T -c /etc/suricata/suricata.yaml -v

# Iniciar el servicio de Suricata
sudo systemctl start suricata.service

# Copiar la configuración de Suricata para Filebeat
sudo cp suricata.yml /etc/filebeat/modules.d

echo -------------------------------------------------------------

# Reiniciar el servicio de Filebeat y configurar
echo Reiniciando el servicio de Filebeat y configurando.
sudo systemctl restart filebeat.service
filebeat setup -e
echo -------------------------------------------------------------
