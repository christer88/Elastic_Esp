VERSION=$1
SERVER_ADDRESS=$2
ELASTIC_USERNAME=$3
ELASTIC_PASSWORD=$4

if ! apt list --installed 2>/dev/null | grep filebeat; then 
    sudo dpkg -i filebeat-$VERSION-amd64.deb

    if ! apt list --installed 2>/dev/null | grep filebeat; then
        echo Błąd przy instalacji Filebeat!
        exit 1;
    fi
        
    echo -------------------------------------------------------------
    echo ZAINSTALOWANO FILEBEAT
    echo -------------------------------------------------------------
fi

echo Zmieniam pliki konfiguracyjne Filebeat. 
sudo sed -i "s|#host: \"localhost:5601\"|host: \"$SERVER_ADDRESS:5601\"|" /etc/filebeat/filebeat.yml
sudo sed -i "s|hosts: \[\"localhost:9200\"\]|hosts: \[\"$SERVER_ADDRESS:9200\"\]|" /etc/filebeat/filebeat.yml
sudo sed -i "s|#protocol: \"https\"|protocol: \"https\"|" /etc/filebeat/filebeat.yml
sudo sed -i "s|#username: \"elastic\"|username: \"$ELASTIC_USERNAME\"|" /etc/filebeat/filebeat.yml
sudo sed -i "s|#password: \"changeme\"|password: \"$ELASTIC_PASSWORD\"|" /etc/filebeat/filebeat.yml
sudo sed -i "s|#ssl.certificate_authorities: \[\"/etc/pki/root/ca.pem\"\]|ssl.certificate_authorities: \[\"/etc/elasticsearch/certs/http_ca.crt\"\]|" /etc/filebeat/filebeat.yml
echo -------------------------------------------------------------
   
echo Uruchamiam usługę.
sudo systemctl daemon-reload
sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service
echo -------------------------------------------------------------
