SERVER_ADDRESS=$1
LISTENING_INTERFACE=$2

if ! apt list --installed 2>/dev/null | grep -q zeek; then
        echo 'deb [trusted=yes] http://download.opensuse.org/repositories/security:/zeek/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
        curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null

        sudo apt update
        sudo apt -y install zeek-lts

        if ! apt list --installed 2>/dev/null | grep -q zeek; then
            echo Błąd przy installacji Zeek.
            exit 1;
        fi

        echo -------------------------------------------------------------
        echo ZAINSTALOWANO ZEEK
        echo -------------------------------------------------------------
fi

echo Konfiguruje.
sudo sed -i "s|host=localhost|host=$SERVER_ADDRESS|" /opt/zeek/etc/node.cfg
sudo sed -i "s|interface=eth0|interface=$LISTENING_INTERFACE|" /opt/zeek/etc/node.cfg
echo -------------------------------------------------------------
echo wprowadzić komendy w kolejności jak poniżej:
echo install
echo start
echo deploy
echo stop
echo exit
read -p 'Po włączeniu się nowego CLI należy podać kolejno komendy powyżej, naciśnij teraz [ENTER].' temp
/opt/zeek/bin/zeekctl
sudo cp zeek.yml /etc/filebeat/modules.d/
sudo filebeat setup -e
sudo systemctl restart filebeat.service
