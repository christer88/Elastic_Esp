# Instalator Elasticsearch, Kibana, Filebeat, Suricata, Zeek, Arkime

## ABOUT
Skrypt służy do instalacji kolejno:
- Elasticsearch
- Kibana
- Filebeat
- Suricata
- Zeek
- Arkime

Skrypt jest podzielony na 9 części. Każdy z nich można uruchomić indywidualnie 
podając przy uruchomieniu wymagane argumenty dla każdego skryptu. Potrzebne 
argumenty można sprawdzić wyświetlając zawartość skryptu. W pierwszych linijkach 
każdego pliku są przypisane zmienne potrzebne do poprawnego jego działania.

## INSTALL.SH
Skrypt należy uruchomić jako root i należy nadać mu prawa do wykonywania, można 
to zrobić przykładowo tak jak poniżej:

- _sudo su -_
- _chmod u+x install.sh_
- _./install.sh_

Przed uruchomieniem należy zmienić wersję oprogramowania która będzie instalowana 
(może też zostać tą którą podałem, sprawdzona i działa), tyczy się to Elasticsearch, 
Kibana i Filebeat - powinny być w tej samej wersji. Przed zmianą należy sprawdzić czy 
wszyskie te programy są dostępne w tej samej wersji.

## INSTALL_ELASTIC.SH

### [HELP](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)

### DEBUG
- _/etc/elasticsearch/elasticsearch.yml_ - plik konfiguracyjny
- _systemctl status elasticsearch
- _/var/log/elastic_ - logi elasticsearcha

## INSTALL_KIBANA.SH

### [HELP](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)

### DEBUG 
- _/etc/kibana/kibana.yml_ - plik konfiguracyjny
- _systemctl status kibana_
- _/va/log/kibana/kibana.log_ - logi kibany

## INSTALL_FILEBEAT.SH

### [HELP](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html)

### DEBUG
- _systemctl status filebeat.service_
- _/etc/filebeat/filebeat.yml_ - plik konfiguracyjny

## INSTALL_SURICATA.SH

### [HELP](https://www.digitalocean.com/community/tutorials/how-to-install-suricata-on-ubuntu-20-04)

### DEBUG
- _systemctl status suricata.service_
- _/etc/suricata/suricata.yml_ - plik konfiguracyjny
- _/var/log/suricata/suricata.log_ - logi suricaty (warto zastoswać z _tail -f_)

## INSTALL_ZEEK.SH
W czasie instalacji uruchomi się cli zeek-a, wówczas należy wpisać kolejno:
- install
- start
- deploy
- stop
- exit

### [HELP](https://docs.zeek.org/en/master/quickstart.html)

### DEBUG
- _/opt/zeek/etc/node.cfg_ - plik konfiguracyjny
- _/etc/fileat/modules.d/zeek.yml_ - plik konfiguracyjny

## INSTALL_ARKIME.SH
### **WAŻNE!**
Przy instalacji ARKIME przy pytaniu w którym należy podać adres elasticsearch 
należy podać sam adres np. jeżeli adres na którym działa elasticsearch 
to _https://192.168.1.1:9200_, to podajemy wtedy tylko 192.168.1.1_. 
Nie ma to znaczenia dla późniejszego działania programu, ponieważ dane zostaną 
podmienione po instalacji arkime do końca – jednakże są to dane ważne dla skryptu, 
który lokalizuje pewne dane do podmiany.

### [HELP](https://kifarunix.com/install-arkime-moloch-full-packet-capture-tool-on-ubuntu/)

### DEBUG
- _/opt/arkime/etc/config.ini_ - plik konfiguracyjny
- _systemctl status arkimeviewer arkimecapture_

