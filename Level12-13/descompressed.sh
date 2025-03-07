#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "\n\n${yellowColour}[+]${endColour}${grayColour} Saliendo ....${endColour}\n"
	tput cnorm ;exit 1
	
}

#CTRL+C
trap ctrl_c INT

#Declarar variable de validación
declare -i parameter_counter=0

function helpPanel(){
	echo -e "\n${yellowColour}[+]${endColour} Uso: ${grayColour}${endColour}"
	echo -e "\t${purpleColour}d)${endColour}${grayColour} Descomprimir archivo recursivamente (Se debe pasar la ruta absoluta del archivo si no está en la carpeta actual) .${endColour}"
	echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar este panel de ayuda${endColour}"
}

function decompressed(){
	tput civis

	#Asignando ruta del archivo
	file_name="$1"

	#Proceso inverso de conversion a decimal.
	echo -e "\n${yellowColour}[!]${endColour}${grayColour} Procesando $file_name${endColour}"
	sleep 1
	echo -e "\n${yellowColour}[!]${endColour}${grayColour} Aplicando proceso inverso de hexadecimal${endColour}"
	sleep 1
	(cat $file_name | xxd -r) > data.gz 

	#Obtener el archivo a descomprimir
	decompressed_file="$(7z l data.gz | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"

	7z x data.gz &>/dev/null

	#Descomprimir los archivos
	echo -e "\n${yellowColour}[!]${endColour}${grayColour} Comenzando a descomprimir los archivos.${endColour}"
	sleep 2
	while [ $decompressed_file ]; do
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se ha descomprimido el achivo: ${endColour}${purpleColour}$decompressed_file${endColour}"
		7z x $decompressed_file &>/dev/null
		password=$decompressed_file
		decompressed_file="$(7z l $decompressed_file 2>/dev/null | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"
		sleep 0.5
	done

	mv "$PWD"/$password "$PWD"/password.bin

	#Eliminar archivos innecesarios.
	rm data*
	echo -e "\n${yellowColour}[!]${endColour}${redColour} Eliminando archivos innecesarios...${endColour}"
	sleep 1

	echo -e "\n${yellowColour}[+]${endColour}${greenColour} Tarea Finalizada..${endColour}"

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} La contraseña es: ${endColour}${blueColour}$(cat password.bin | awk 'NF{print $NF}')${endColour}"

	tput cnorm
}


while getopts "d:h" arg; do
        case $arg in
                d)file_name=$OPTARG; let parameter_counter+=1;;
                h);;
        esac
done

if [ $parameter_counter -eq 1 ]; then
	decompressed $file_name
else
	helpPanel
fi


