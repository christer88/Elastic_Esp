#Instalator Elasticsearch, Kibana, Filbeat, Suricata, Zeek, Arkime

##ABOUT
Skrypt służy do instalacji kolejno:
- Elasticsearch
- Kibana
- Filbeat
- Suricata
- Zeek
- Arkime

Skrypt jest podzielony na 9 części. Każdy z nich można uruchomić indywidualnie 
podając przy uruchomieniu wymagane argumenty dla każdego skryptu. Potrzebne 
argumenty można sprawdzić wyświetlając zawartość skryptu. W pierwszych linijkach 
każdego pliku są przypisane zmienne potrzebne do poprawnego jego działania.

##INSTALL.SH
Przed uruchomieniem należy zmienić wersję oprogramowania która będzie installowana,
tyczy się to Elasticsearch, Kibana i Filbeat - powinny być w tej samej wersji. 
Przed zmianą należy sprawdzić czy wszyskie te programy są dostępne w tej samej
wersji.

##INSTALL_ARKIME.SH
**WAŻNE!**
Przy instalacji ARKIME przy pytaniu w którym należy podać adres elasticsearch 
należy podać sam adres np. jeżeli adres na którym działa elasticsearch 
to __https://192.168.1.1:9200__, to podajemy wtedy tylko __192.168.1.1__. 
Nie ma to znaczenia dla późniejszego działania programu, ponieważ dane zostaną 
podmienione po instalacji arkime do końca – jednakże są to dane ważne dla skryptu, 
który lokalizuje pewne dane do podmiany. Reszte danych należy podać zgodnie z 
