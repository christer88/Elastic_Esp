VERSION=$1
SERVER_ADDRESS=$2
KIBANA_USERNAME=$3
KIBANA_PASSWORD=$4

if ! apt list --installed 2>/dev/null | grep kibana; then
    sudo dpkg -i kibana-$VERSION-amd64.deb

    if ! apt list --installed 2>/dev/null | grep kibana; then
        echo Błąd przy instalacji Kiabny.
        exit 1;
    fi

    echo -------------------------------------------------------------
    echo ZAINSTALOWANO KIBANE
    echo -------------------------------------------------------------
fi

if ! ls /etc/kibana/kibana.yml; then
  echo BRAK PLIKU KONFIGURACYJNEGO kibana.yml
  echo Jeżeli instalujesz kolejny raz na tej samej maszynie elasticsearch, a wcześniej usunąłeś elasticsearch. 
  echo To spróbuj wykonać komendę \"apt purge kibana\".
  exit 1;

fi

echo Wprowadzam zmiany w pliku konfiguracyjnym. 
sudo sed -i "s|#server.port: 5601|server.port: 5601|" /etc/kibana/kibana.yml
sudo sed -i "s|#server.host: \"localhost\"|server.host: \"$SERVER_ADDRESS\"|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.hosts: \[\"http://localhost:9200\"\]|elasticsearch.hosts: \[\"https://$SERVER_ADDRESS:9200\"\]|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.username: \"kibana_system\"|elasticsearch.username: \"$KIBANA_USERNAME\"|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.password: \"pass\"|elasticsearch.password: \"$KIBANA_PASSWORD\"|" /etc/kibana/kibana.yml
sudo sed -i "s|#elasticsearch.ssl.certificateAuthorities: \[ \"/path/to/your/CA.pem\" \]|elasticsearch.ssl.certificateAuthorities: \[ \"/etc/elasticsearch/certs/http_ca.crt\" \]|" /etc/kibana/kibana.yml
echo -------------------------------------------------------------

echo Uruchamiam ponownie usługę.
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service
echo -------------------------------------------------------------
