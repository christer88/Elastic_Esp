VERSION=$1

# Eliminar archivos de paquetes específicos
rm elasticsearch-$VERSION-amd64.deb kibana-$VERSION-amd64.deb filebeat-$VERSION-amd64.deb arkime_4.1.0-1_amd64.deb

# Eliminar archivos de configuración
rm suricata.yml zeek.yml

# Eliminar scripts de instalación y desinstalación
rm install_elasticsearch.sh install_kibana.sh install_filebeat.sh install_suricata.sh install_zeek.sh install_arkime.sh install.sh get_requirements.sh uninstall.sh clean.sh
