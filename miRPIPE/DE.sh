#!/bin/bash

## Copyright 2019 Roman-Escorza M.

## This file is part of miRPIPE

## miRPIPE is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## miRPIPE is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with miRPIPE.  If not, see <http://www.gnu.org/licenses/>.

if [ $# -eq 0 ]
then
  echo "Usage: sh DE.sh /home/user/working_directory /path/to/SraRunTable.txt column"
  exit
fi

WORKING_DIR=$1
SRA_TABLE=$2
EXPERIMENT=$( grep -o -m 1 '\<SRP[0-9]*\>' $SRA_TABLE )
PARAM_FILE="$WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt"
COLUMN=$3
NUMBER_OF_SAMPLES=$( grep number_of_samples: $PARAM_FILE | awk '{print $2}' )
RunCol=$( grep run_column_number: $PARAM_FILE | awk '{print $2}' )

echo "phen_column_name:" $COLUMN >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

## Identificamos la columna con los fenotipos. Para ello con head
## se imprime la primera línea de la tabla. Con tr se cambian los tabuladores
## por saltos de línea. Con grep -B extraemos las cabeceras de las columnas
## que están antes de la columna Run. Con wc -l las contamos. Se guarda en
## la variable PhenCol
echo "Calculating Phenotypes column number" > $WORKING_DIR/$EXPERIMENT/logs/de_logs.txt
PhenCol=$( head -n 1 $SRA_TABLE | tr " \t" "\n" | grep -B 40 $COLUMN | wc -l )
echo "phen_column_number:" $PhenCol >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

## Guardamos la columna PhenCol de la tabla que corresponde a los fenotipos
## en la variable $PHENOTYPES sin la cabecera y sin repeticiones.
## Para ello ordenamos cortamos la columna de la tabla con cut, nos quedamos
## con las n últimas líneas (que serán todas menos la cabecera) y ordenamos
##  el fichero eliminando las líneas repetidas utilizando sort -u
PHENOTYPES=$( cut -f$PhenCol $SRA_TABLE | tail -n +2 | sort -u )

## Guardamos los fenotipos en un archivo .txt con echo
echo $PHENOTYPES > $WORKING_DIR/$EXPERIMENT/logs/logs_phenotypes_names.txt
echo "logs_phenotypes_names.txt created" >> $WORKING_DIR/$EXPERIMENT/logs/de_logs.txt

## Contamos el número de fenotipos que hay con wc:
echo "Calculating Phenotypes number" >> $WORKING_DIR/$EXPERIMENT/logs/de_logs.txt
PHEN_NUM=$( cut -f$PhenCol $SRA_TABLE | tail -n +2 | sort -u | wc -l)
echo "phenotypes_number:" $PHEN_NUM >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

## Creamos el diseño experimental y lo guardamos en la variable EXP_DESIGN que
## utilizaremos como grpDesc posteriormente en el sRNAde. Este utiliza una
## sintaxis concreta de mostrar todos los fenotipos separados por un hash #
echo "Creating experimental design" >> $WORKING_DIR/$EXPERIMENT/logs/de_logs.txt
i=1
while [ $i -le $PHEN_NUM ]
do
  ## Extraemos el nombre de cada fenotipo, que habíamos guardado previamente en
  ## logs_phenotypes_names.txt. Transformamos los espacios de ese archivo en
  ## saltos de línea con tr para poder extraer la i-ésima línea, que
  ## corresponderá al fenotipo i y lo almacenamos en PHEN_$i
  PHEN=$( cat $WORKING_DIR/$EXPERIMENT/logs/logs_phenotypes_names.txt | tr " \s" "\n" | tail -n +$i | head -n 1 )
  echo "phenotype_$i:" $PHEN >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt
  ## Actualizamos la variable EXP_DESIGN donde guardamos el grpDesc en cada
  ## vuelta del bucle con la variable PHEN_$i y el caracter hash #
  EXP_DESIGN="$EXP_DESIGN$PHEN#"
  i=$(($i+1))
done

## Eliminamos el último hash # de la variable EXP_DESIGN con sed
EXP_DESIGN=$( echo $EXP_DESIGN | sed 's/.$//g' )
echo "grpDesc:" $EXP_DESIGN >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

i=1
while [ $i -le $PHEN_NUM ]
do
  ## Extraemos el nombre de cada fenotipo, que habíamos guardado previamente en
  ## logs_phenotypes_names.txt. Transformamos los espacios de ese archivo en
  ## saltos de línea con tr para poder extraer la i-ésima línea, que
  ## corresponderá al fenotipo i y lo almacenamos en PHEN_$i
  PHEN=$( cat $WORKING_DIR/$EXPERIMENT/logs/logs_phenotypes_names.txt | tr " \s" "\n" | tail -n +$i | head -n 1 )
  ## Bucle para guardar los SRA de cada fenotipo en un archivo .txt
  ## El bucle irá desde $i que se inicializa en 2 para que no se lea la cabecera
  ## del $SRA_TABLE hasta $n que será el numero de líneas de la tabla, o lo que
  ## es lo mismo, el número de muestras + 1
  n=$(($NUMBER_OF_SAMPLES+1))
  j=2
  while [ $j -le $n ]
  do
    ## Nos quedamos con la línea $i de la columna donde están los fenotipos y la
    ## guardamos en la variable $PHEN_NAME
    PHEN_NAME=$( cut -f$PhenCol $SRA_TABLE | head -$j | tail -1 )
    ## Nos quedamos con la línea $i de la columna donde están los nombres SRA y la
    ## guardamos en la variable $PHEN_NAME
    NAME=$( cut -f$RunCol $SRA_TABLE | head -$j | tail -1 )
    if [ "$PHEN" = "$PHEN_NAME" ]
    then
      ## En casp de que sí que sean iguales, el nombre SRA de la línea $i de la
      ## tabla $SRA_TABLE se guarda en un archivo .txt específico para su fenotipo
      ## $PHEN
      echo $NAME >> $WORKING_DIR/$EXPERIMENT/logs/log_SRA_PHEN_$PHEN.txt
      echo $NAME "added to log_SRA_PHEN_"$PHEN".txt" >> $WORKING_DIR/$EXPERIMENT/logs/de_logs.txt
    fi
    j=$(($j+1))
  done
  i=$(($i+1))
done

## Guardamos la ruta de cada og_SRA_PHEN_*.txt en un archivo .txt
find $WORKING_DIR/$EXPERIMENT/logs/log_SRA_PHEN_*.txt > $WORKING_DIR/$EXPERIMENT/logs/log_SRA_ALL.txt
echo "log_SRA_ALL.txt created" >> $WORKING_DIR/$EXPERIMENT/logs/de_logs.txt

## Inicializamos el bucle que creará la cadena
k=1
while [ $k -le $PHEN_NUM ]
do
  ## Miramos en el .txt creado en el paso anterior la ruta del og_SRA_PHEN_*.Txt
  ## que contienen los SRA para cada fenotipo
  LOG=$( cat $WORKING_DIR/$EXPERIMENT/logs/log_SRA_ALL.txt | head -$k | tail -1 )
  ## Añadimos al principio de cada línea la palabra miRBase_name
  sed -i "s|^|miRBase_|g" $LOG
  ## Leemos el archivo cuya ruta hemos almacenado en $LOG y cambiamos los saltos
  ## de líneas por : para crear la cadena menos en el último que se elimina con sed
  miRBase_names=$( cat $LOG | tr "\n" ":" | sed 's/.$//g' )
  ## Actualizamos la cadena $miRBase_STRING añadiendo al final un hash #
  miRBase_STRING="$miRBase_STRING""$miRBase_names#"
  ## Cambiamos la palabra miRBase_ por miRGeneDB_
  sed -i "s/miRBase_/miRGeneDB_/g" $LOG
  ## Leemos el archivo $LOG modificado de nuevo
  miRGeneDB_names=$( cat $LOG | tr "\n" ":" | sed 's/.$//g' )
  ## Actualizamos la cadena $miRGeneDB_STRING añadiendo al final un hash #
  miRGeneDB_STRING="$miRGeneDB_STRING""$miRGeneDB_names#"
  k=$(($k+1))
done

## Quitamos los dos últimos caracteres de las dos cadenas, que será un # y :
miRBase_STRING=${miRBase_STRING%?}
miRGeneDB_STRING=${miRGeneDB_STRING%?}

echo "miRBase_grpString:" $miRBase_STRING >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt
echo "miRGeneDB_grpString:" $miRGeneDB_STRING >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

# Lanzamos el sRNAde para el análisis de la expresión diferencial.
java -jar /opt/sRNAtoolboxDB/exec/sRNAde.jar input=$WORKING_DIR/$EXPERIMENT/results grpString=$miRBase_STRING output=$WORKING_DIR/$EXPERIMENT/results/diffExpr_miRBase grpDesc=$EXP_DESIGN web=TRUE
java -jar /opt/sRNAtoolboxDB/exec/sRNAde.jar input=$WORKING_DIR/$EXPERIMENT/results grpString=$miRGeneDB_STRING output=$WORKING_DIR/$EXPERIMENT/results/diffExpr_miRGeneDB grpDesc=$EXP_DESIGN web=TRUE

echo "DIFFERENTIAL EXPPRESSION ANALYSIS DONE" >> $WORKING_DIR/$EXPERIMENT/logs/de_logs.txt
