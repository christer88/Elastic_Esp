SERVER_ADDRESS=$1
MASK=$2
LISTENING_INTERFACE=$3

if ! apt list --installed 2>/dev/null | grep -q suricata; then
    sudo add-apt-repository ppa:oisf/suricata-stable
    sudo apt install suricata

    if ! apt list --installed 2>/dev/null | grep -q suricata; then
        echo Błąd instalacji Suricata!
        exit 1;
    fi

    echo -------------------------------------------------------------
    echo ZAINSTALOWANO SURICATE
    echo -------------------------------------------------------------
fi

sudo systemctl enable suricata.service
sudo systemctl stop suricata.service

echo Konfiguruje.
sudo sed -i "s|HOME_NET: \"\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12\]\"|HOME_NET: \"\[$SERVER_ADDRESS/$MASK\]\"|" /etc/suricata/suricata.yaml
sudo sed -i "s|- interface: eth0|- interface: $LISTENING_INTERFACE|" /etc/suricata/suricata.yaml

sudo suricata-update
sudo suricata-update list-sources
sudo suricata -T -c /etc/suricata/suricata.yaml -v
sudo systemctl start suricata.service
sudo cp suricata.yml /etc/filebeat/modules.d
echo -------------------------------------------------------------

echo Uruchamiam usługę.
sudo systemctl restart filbeat.service
filebeat setup -e
echo -------------------------------------------------------------
