VERSION=$1

if ! ls | grep -q elasticsearch-$VERSION-amd64.deb; then
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$VERSION-amd64.deb
    if ! ls | grep -q elasticsearch-$VERSION-amd64.deb; then
      exit 1;
    fi
fi

if ! ls | grep -q kibana-$VERSION-amd64.deb; then
    wget https://artifacts.elastic.co/downloads/kibana/kibana-$VERSION-amd64.deb
    if ! ls | grep -q kibana-$VERSION-amd64.deb; then
      exit 1;
    fi
fi

if ! ls | grep -q filebeat-$VERSION-amd64.deb; then
    curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$VERSION-amd64.deb
    if ! ls | grep -q filebeat-$VERSION-amd64.deb; then
      exit 1;
    fi
fi

if ! ls | grep -q arkime_4.1.0-1_amd64.deb; then
    wget https://s3.amazonaws.com/files.molo.ch/builds/ubuntu-22.04/arkime_4.1.0-1_amd64.deb
    if ! ls | grep -q arkime_4.1.0-1_amd64.deb; then
      exit 1;
    fi
fi

if ! dpkg -s net-tools | grep -q "install ok installed"; then
    sudo apt install net-tools
    if ! dpkg -s net-tools | grep -q "install ok installed"; then
      exit 1;
    fi
fi
