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
echo -e "Nombre de logs injectés,Moyenne,Variance,Execution 1,Execution 2,Execution 3,Execution 4,Execution 5,Execution 6,Execution 7,Execution 8,Execution 9,Execution 10" > "$CSV_FILE_NAME"

#On initialise les variables
NB_EXEC=10
LOG_START=1500000
declare -a NB_LOGS=(50 100 500);
result=0.0

#Pour chaque nombre de logs à injecter
for nb_log in ${NB_LOGS[@]}
do
echo "Execution de $nb_log logs."
	echo -e "$nb_log,MOYENNE,VARIANCE,\c" >> "$CSV_FILE_NAME"
	declare -a results=()
	#On execute $NB_EXEC fois le benchmark
	for ((i=0 ; $NB_EXEC-$i ; i++))
	do
		# Injecte les logs à partir du client zookeeper 
		# Mesure le temps d'execution réel en secondes (float)
		# Enregistre le résultat dans un fichier temporaire
		# N'affiche pas le résultat de l'exécution
		machines="server-1:2181" #,server-2:2181,server-3:2181"
		/usr/bin/time -f "%e" -o /tmp/bench sh /home/xnet/resources/run_benchmark.sh $machines $LOG_START $nb_log
		result=$(cat /tmp/bench)
		results[$i]=$result
		echo -e "$result,\c" >> "$CSV_FILE_NAME"
		sleep $nb_log #wait for the end of iddle
	done
	#Calcul de la moyenne
	tot=0.0
	for result in ${results[@]}; do
	  tot=$(perl -e "print $result + $tot")
	done
	moyenne=$(perl -e "print $tot/$NB_EXEC")
	
	#Calcul de la variance
	sum=0
	for result in ${results[@]}; do
	  sum=$(perl -e "print $sum+($result-$moyenne)*($result-$moyenne)")
	done
	variance=$(perl -e "print $sum/$NB_EXEC")

	#On ajoute la moyenne et la variance dans le fichier Excel
	sed -i -e "s/MOYENNE/$moyenne/g" "$CSV_FILE_NAME"
	sed -i -e "s/VARIANCE/$variance/g" "$CSV_FILE_NAME"

	echo "Total: $tot, moyenne : $moyenne, variance : $variance"
	echo -e "" >> "$CSV_FILE_NAME"	
done


