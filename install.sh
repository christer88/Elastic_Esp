CURRENT_COUNTER=1
VERSION=8.7.0
LINE="-------------------------------------------------------------"
DOUBLE_LINE="============================================================"
ELASTIC_USERNAME=""
ELASTIC_PASSWORD=""
KIBANA_USERNAME=""
KIBANA_PASSWORD=""
SERVER_ADDRESS=""
MASK=""
LISTENING_INTERFACE=""

function get_inputs(){
	read -p 'Podaj nazwę użytkownika Elasticsearch: ' ELASTIC_USERNAME
	get_password "ELASTIC_PASSWORD"

	read -p 'Podaj nazwę użytkownika Kibany: ' KIBANA_USERNAME
	get_password "KIBANA_PASSWORD"

	read -p 'Podaj adres IP dla serwera: ' SERVER_ADDRESS
	read -p 'Maska podsieci (np. 24): ' MASK

	echo $LINE
	tcpdump --list-interfaces
	echo $LINE
	read -p 'Podaj interfejs z którego będzie nasłuchiwany ruch (np. eth0, local): ' LISTENING_INTERFACE
}

function get_password(){
    local temp=""
    local temp2="?"
    while [ ! "$temp" = "$temp2" ]; do
            read -sp 'Podaj hasło dla użytkownika: ' temp 
            echo
            read -sp 'Powtórz hasło: ' temp2
            echo
            if [ ! "$temp" = "$temp2" ]; then
                echo "Spróbuj jeszcze raz, hasła się nie zgadzają."
            fi
    done
    eval "$1"="$temp"
}

function execute_scripts(){
    for i in ${!SCRIPTS[@]};
    do
        echo $LINE
        echo [$CURRENT_COUNTER/${#SCRIPTS[@]}] ${TITLES[i]}
        echo $LINE
        if ! ${SCRIPTS[i]}; then
              if [ $i == 0 ]; then
                echo Skrypt został przerwany, ponieważ któregoś z zasobu nie ma na dysku, a link którym miał być pobrany nie działa. 
                echo Możesz spróbować edytować ten skrypt i ustawić wartość zmiennej VERSION na inną wersję elastica/kibany/filebeat. 
                echo Moża aktualnie wpisana wersja nie jest już dostępna.
                exit 1;
              fi
                
              echo PRZERWANIE SKRYPTU, PONIEWAŻ JEDEN Z WARUNKÓW NIE ZOSTAŁ SPEŁNIONY.
              exit 1;
        fi
        ((CURRENT_COUNTER++)) 
        echo $DOUBLE_LINE
    done
}

sudo chmod 777 install_elasticsearch.sh install_kibana.sh install_filebeat.sh install_suricata.sh install_zeek.sh install_arkime.sh get_requirements.sh clean.sh
get_inputs

SCRIPTS=(   "./get_requirements.sh $VERSION"
            "./install_elasticsearch.sh $VERSION $SERVER_ADDRESS $ELASTIC_USERNAME $ELASTIC_PASSWORD $KIBANA_USERNAME $KIBANA_PASSWORD"
            "./install_kibana.sh $VERSION $SERVER_ADDRESS $KIBANA_USERNAME $KIBANA_PASSWORD" 
            "./install_filebeat.sh $VERSION $SERVER_ADDRESS $ELASTIC_USERNAME $ELASTIC_PASSWORD"
            "./install_suricata.sh $SERVER_ADDRESS $MASK $LISTENING_INTERFACE"
            "./install_zeek.sh $SERVER_ADDRESS $LISTENING_PORT"
            "./install_arkime.sh $ELASTIC_USERNAME $ELASTIC_PASSWORD $SERVER_ADDRESS"
	          "./clean.sh" $VERSION
)

TITLES=(    "POBIERAM POTRZEBNE ZASOBY"
            "INSTALUJE ELASTICSEARCH"
            "INSTALUJE KIBANE"
            "INSTALUJE FILEBEAT"
            "INSTALUJE SURICATE"
            "INSTALUJE ZEEK"
            "INSATLUJE ARKIME"
      	    "SPRZĄTAM PO SOBIE"
) 

execute_scripts

echo [$CURRENT_COUNTER/${#SCRIPTS[@]}] KONIEC INSTALACJI
