#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
function ctrl_c(){
        echo -e "\n${yellowColour}[!]${endColour}${grayColour}Saliendo .....${endColour}\n"
        tput cnorm; exit 1
}

#Ctrl+c
trap ctrl_c INT

#Verificar que el archivo no exista
if [ -f ports.txt ]; then
        rm ports.txt
fi

#Crear el archivo
echo -e "\n${yellowColour}[+]${endColour}${grayColour} Creando el archivo ports.txt${endColour}"
touch ports.txt

#Obtener los puertos abiertos
echo -e "\n${yellowColour}[+]${endColour}${grayColour} Obteniendo los puertos abiertos...${endColour}\n"
sleep 0.5
tput civis
for port in $(seq 31000 32000); do
        #Mandar una cadena vacia a esa dirección con ese puerto para ver si el puerto está abierto
	(echo '' > /dev/tcp/127.0.0.1/$port) 2>/dev/null && echo -e "${yellowColour}[+]${endColour}${blueColour} $port${endColour}${grayColour} - OPEN${endColour}" && echo $port >> ports.txt
done;

#Obteniendo el id_rsa o sea la clave privada
echo -e "\n${yellowColour}[+]${endColour}${grayColour} Verificando puerto correcto${endColour}"
for port in $(cat ports.txt); do
        (timeout 1 bash -c "echo "kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx" | ncat --ssl localhost $port 2>/dev/null") >> password.txt
done

echo -e "\n${yellowColour}[+]${endColour}${grayColour} Obteniendo la clave privada del usuario${endColour}"
cat password.txt | awk "/-----BEGIN RSA PRIVATE KEY-----/,/-----END RSA PRIVATE KEY-----/" > id_rsa

sleep 1
echo -e "\n${yellowColour}[+]${endColour}${grayColour} Otorgando permisos que deben tener las claves privadas${endColour}"
chmod 600 id_rsa

#Eliminado archivos innecesarios
rm password.txt
rm ports.txt

tput cnorm
sleep 1

echo -e "\n${redColour}[!]Conectando al nuevo usuario....${endColour}\n"
sleep 1

ssh -i id_rsa bandit17@localhost -p 2220


