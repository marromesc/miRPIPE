#! /bin/bash

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
  echo "Usage: sh batch_boxplot_quality.sh /home/user/working_directory /path/to/SraRunTable.batt mean_or_min_or_noMM Q"
  exit
fi

# Parameters
WORKING_DIR=$1
SRA_TABLE=$2
TYPE=$3
Q=$4

EXPERIMENT=$( grep -o -m 1 '\<SRP[0-9]*\>' $SRA_TABLE )
PARAM_FILE="$WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt"
NUMBER_OF_SAMPLES=$( grep number_of_samples: $PARAM_FILE | awk '{print $2}' )

## Entrar en la carpeta stat de los resultados de cada muestra y leer el fichero
## isomiR_NTA.txt

mkdir $WORKING_DIR/$EXPERIMENT/logs/quality_boxplotting

j=1
while [ $j -le $NUMBER_OF_SAMPLES ]
do
  name=$( cat $WORKING_DIR/$EXPERIMENT/logs/logs_SRA_names.txt | tr ' \s' '\n' | tail -n $j | head -n 1 )
  ## En el caso de hacer el análisis con mean
  if [ $TYPE -eq 0 ]
  then
    a=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_mean_$Q/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_mean_$Q/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_mean_$Q/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_mean_$Q/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    echo $EXPERIMENT"_mean"$Q" \t "$a" \t "$t" \t "$c" \t "$g >> $WORKING_DIR/$EXPERIMENT/logs/quality_boxplotting/$name.txt
  ## En el caso de hacer el análisis con min
  elif [ $TYPE -eq 1 ]
  then
    ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con min
    ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/min_$Q microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=$Q
    a=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_min_$Q/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_min_$Q/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_min_$Q/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_min_$Q/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    echo $EXPERIMENT"_min"$Q" \t "$a" \t "$t" \t "$c" \t "$g >> $WORKING_DIR/$EXPERIMENT/logs/quality_boxplotting/$name.txt
  ## En el caso de hacer el análisis con noMM
  elif [ $TYPE -eq 2 ]
  then
    a=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g=$( cut -f3 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    echo $EXPERIMENT"_noMM"" \t "$a" \t "$t" \t "$c" \t "$g >> $WORKING_DIR/$EXPERIMENT/logs/quality_boxplotting/$name.txt
  fi
  j=$(($j+1))
done
