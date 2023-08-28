SERVER_ADDRESS=$1
LISTENING_INTERFACE=$2

# Verificar si Zeek no está instalado y, si es así, instalarlo desde un repositorio externo
if ! apt list --installed 2>/dev/null | grep -q zeek; then
    echo 'deb [trusted=yes] http://download.opensuse.org/repositories/security:/zeek/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
    curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null

    sudo apt update
    sudo apt -y install zeek-lts

    if ! apt list --installed 2>/dev/null | grep -q zeek; then
        echo Error durante la instalación de Zeek.
        exit 1
    fi

    echo -------------------------------------------------------------
    echo ZEEK INSTALADO CON ÉXITO
    echo -------------------------------------------------------------
fi

# Configurar Zeek
echo Configurando Zeek.
sudo sed -i "s|host=localhost|host=$SERVER_ADDRESS|" /opt/zeek/etc/node.cfg
sudo sed -i "s|interface=eth0|interface=$LISTENING_INTERFACE|" /opt/zeek/etc/node.cfg
sudo /opt/zeek/bin/zeekctl install
sudo /opt/zeek/bin/zeekctl start
sudo /opt/zeek/bin/zeekctl deploy
sudo /opt/zeek/bin/zeekctl stop

# Configurar Filebeat para Zeek
sudo filebeat setup -e

# Reiniciar el servicio de Filebeat
sudo systemctl restart filebeat.service
