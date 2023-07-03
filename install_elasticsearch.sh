VERSION=$1
SERVER_ADDRESS=$2
ELASTIC_USERNAME=$3
ELASTIC_PASSWORD=$4
KIBANA_USERNAME=$5
KIBANA_PASSWORD=$6

if ! apt list --installed 2>/dev/null | grep -q elasticsearch; then
    sudo dpkg -i elasticsearch-$VERSION-amd64.deb

    if ! apt list --installed 2>/dev/null | grep elasticsearch; then
        exit 1;
    fi
    
    echo -------------------------------------------------------------
    echo ZAINSTALOWANO ELASTICSEARCH
    echo -------------------------------------------------------------
fi

if ! ls /etc/elasticsearch/ | grep -q elasticsearch.yml; then
  echo BRAK PLIKU KONFIGURACYJNEGO elasticsearch.yml
  echo Jeżeli instalujesz kolejny raz na tej samej maszynie elasticsearch, a wcześniej usunąłeś elasticsearch. 
  echo To spróbuj wykonać komendę apt purge elasticsearch.
  exit 1;
fi

sudo sed -i "s|#node.name: node-1|node.name: node-1" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|#network.host: 192.168.0.1|network.host: $SERVER_ADDRESS|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|#http.port: 9200|http.port: 9200|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|#discovery.seed_hosts: \[\"host1\", \"host2\"\]|discovery.seed_hosts: \[\"host1\"\]\ndiscovery.type: single-node|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|http.host: 0.0.0.0|http.host: $SERVER_ADDRESS|" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|cluster.initial_master_nodes: \[\"$HOSTNAME\"\]|# cluster.initial_master_nodes: \[\"$HOSTNAME\"\]|" /etc/elasticsearch/elasticsearch.yml

echo Uruchamiam usługę.
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
echo -------------------------------------------------------------

echo Tworzę użytkowników.
if sudo /usr/share/elasticsearch/bin/elasticsearch-users list | grep -w "$ELASTIC_USERNAME"; then
    sudo /usr/share/elasticsearch/bin/elasticsearch-users userdel $ELASTIC_USERNAME;
fi 

if sudo /usr/share/elasticsearch/bin/elasticsearch-users list | grep -w "$KIBANA_USERNAME"; then
    sudo /usr/share/elasticsearch/bin/elasticsearch-users userdel $KIBANA_USERNAME;
fi

sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd $ELASTIC_USERNAME -p $ELASTIC_PASSWORD -r superuser;
sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd $KIBANA_USERNAME -p $KIBANA_PASSWORD -r kibana_system;
echo -------------------------------------------------------------

echo Udostępniam certyfikaty dla innych usług.
sudo chmod 777 /etc/elasticsearch   
sudo chmod 777 /etc/elasticsearch/certs
sudo chmod 777 /etc/elasticsearch/certs/http_ca.crt
echo -------------------------------------------------------------

