#!/bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"

benchmarkDir="result"
CSV_FILE_NAME="$benchmarkDir"/result.csv
#Création du dossier contenant les résultats
if [ ! -d "$benchmarkDir" ];then
	mkdir "$benchmarkDir";
fi

#Initialisation du fichier csv
echo -e "Nombre de logs injectés,Nombre de workers,Moyenne,Variance,Execution 1,Execution 2,Execution 3,Execution 4,Execution 5	Execution 6,Execution 7,Execution 8,Execution 9,Execution 10" > "$CSV_FILE_NAME"

#On initialise les variables
NB_EXEC=10
declare -a NB_LOGS=(50 100 500 2000);
declare -a NB_WORKERS=(1 3);
result=0

#Pour tous les nombres de machines possibles
for nb_worker in ${NB_WORKERS[@]}
do
	#Pour chaque nombre de logs à injecter
	for nb_log in ${NB_LOGS[@]}
	do
	echo "Execution avec $nb_worker worker et $nb_log logs."
#TODO : Recompiler le client à chaque fois qu'on change le nombre de logs injectés (client.java ligne 311)
		echo -e "$nb_log,$nb_worker,MOYENNE,VARIANCE,\c" >> "$CSV_FILE_NAME"
		declare -a results=();
		#On execute $NB_EXEC fois le benchmark
		for ((i=0 ; $NB_EXEC-$i ; i++))
		do 
#TODO : Calculer le vrai résultat
			result=$i
			let "results[$i]=$result"
			echo -e "$result,\c" >> "$CSV_FILE_NAME"
		done
		#Calcul de la moyenne
		tot=0
		for result in ${results[@]}; do
		  let "tot+=$result"
		done
		moyenne=$(echo "$tot/$NB_EXEC" | bc -l)
		
		#Calcul de la variance
		sum=0
		for result in ${results[@]}; do
		  sum=$(echo "$sum+($result-$moyenne)*($result-$moyenne)" | bc -l )
		done
		variance=$(echo "$sum/$NB_EXEC" |bc -l)

		#On ajoute la moyenne et la variance dans le fichier Excel
		sed -i -e "s/MOYENNE/$moyenne/g" "$CSV_FILE_NAME"
		sed -i -e "s/VARIANCE/$variance/g" "$CSV_FILE_NAME"

		echo "Total: $tot, moyenne : $moyenne, variance : $variance"
		echo -e "" >> "$CSV_FILE_NAME"	
	done
done


