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
Skrypt należy uruchomić jako root!!!!

_sudo su -
chmod u+x install.sh
./install.sh_

Przed uruchomieniem należy zmienić wersję oprogramowania która będzie instalowana 
(może też zostać ta którą podałem, sprawdzona i działa), tyczy się to Elasticsearch, 
Kibana i Filebeat - powinny być w tej samej wersji. Przed zmianą należy sprawdzić czy 
wszyskie te programy są dostępne w tej samej wersji.

## INSTALL_ZEEK.SH
W czasie instalacji uruchomi się cli zeek-a, wówczas należy wpisać kolejno:
- install
- start
- deploy
- stop
- exit

## INSTALL_ARKIME.SH
**WAŻNE!**
Przy instalacji ARKIME przy pytaniu w którym należy podać adres elasticsearch 
należy podać sam adres np. jeżeli adres na którym działa elasticsearch 
to _https://192.168.1.1:9200_, to podajemy wtedy tylko _192.168.1.1_. 
Nie ma to znaczenia dla późniejszego działania programu, ponieważ dane zostaną 
podmienione po instalacji arkime do końca – jednakże są to dane ważne dla skryptu, 
który lokalizuje pewne dane do podmiany.
