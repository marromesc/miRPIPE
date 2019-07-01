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
  echo "Usage: sh batch_QUALITY /home/user/working_directory /path/to/SraRunTable.bat adapter_sequence mean_or_min_or_noMM Q"
  echo "Type 0 for mean analysis, 1 for min analysis or 2 for noMM=0"
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
ADAPTER_ASK=$( grep question_adap: $PARAM_FILE | awk '{print $2}' )

## Inicializamos el bucle que llevará a cabo la descarga de muestras y su
## preprocesamiento con java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar.

i=1
while [ $i -le $NUMBER_OF_SAMPLES ]
do
  name=$( cat $WORKING_DIR/$EXPERIMENT/logs/logs_SRA_names.txt | tr ' \s' '\n' | tail -n +$i | head -n 1 )
  ## En el caso de hacer el análisis con mean
  if [ $TYPE -eq 0 ]
  then
    if [ $ADAPTER_ASK -eq 0 ]
    then
      ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con mean
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/mean_$Q microRNA=hsa isoMiR=true plotMiR=false qualityType=mean minQ=$Q
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_mean_$Q/$name microRNA=hsa isoMiR=true plotMiR=false qualityType=mean minQ=$Q" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_mean_$Q$EXPERIMENT.bat
    elif [ $ADAPTER_ASK -eq 1 ]
    then
      ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con mean
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/mean_$Q microRNA=hsa isoMiR=true plotMiR=false qualityType=mean minQ=$Q
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_mean_$Q/$name guessAdapter=true microRNA=hsa isoMiR=true plotMiR=false qualityType=mean minQ=$Q" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_mean_$Q$EXPERIMENT.bat
    elif [ $ADAPTER_ASK -eq 2 ]
    then
      ADAPTER=$( grep adapter_sequence: $PARAM_FILE | awk '{print $2}' )
       ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con mean
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/mean_$Q microRNA=hsa isoMiR=true plotMiR=false qualityType=mean minQ=$Q
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_mean_$Q/$name adapter=$ADAPTER microRNA=hsa isoMiR=true plotMiR=false qualityType=mean minQ=$Q" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_mean_$Q$EXPERIMENT.bat
     fi
  ## En el caso de hacer el análisis con min
  elif [ $TYPE -eq 1 ]
  then
    if [ $ADAPTER_ASK -eq 0 ]
    then
      ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con mean
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/min_$Q microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=$Q
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_min_$Q/$name microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=$Q" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_min_$Q$EXPERIMENT.bat
    elif [ $ADAPTER_ASK -eq 1 ]
    then
      ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con mean
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/min_$Q microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=$Q
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_min_$Q/$name guessAdapter=true microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=$Q" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_min_$Q$EXPERIMENT.bat
    elif [ $ADAPTER_ASK -eq 2 ]
    then
      ADAPTER=$( grep adapter_sequence: $PARAM_FILE | awk '{print $2}' )
       ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con mean
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/min_$Q microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=$Q
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_min_$Q/$name adapter=$ADAPTER microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=$Q" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_min_$Q$EXPERIMENT.bat
     fi
  else
    if [ $ADAPTER_ASK -eq 0 ]
    then
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/noMM microRNA=hsa isoMiR=true plotMiR=false noMM=0
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name microRNA=hsa isoMiR=true plotMiR=false noMM=0" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_noMM_$Q$EXPERIMENT.bat
    elif [ $ADAPTER_ASK -eq 1 ]
    then
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/noMM microRNA=hsa isoMiR=true plotMiR=false noMM=0
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name guessAdapter=true microRNA=hsa isoMiR=true plotMiR=false noMM=0" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_noMM_$Q$EXPERIMENT.bat
    elif [ $ADAPTER_ASK -eq 2 ]
    then
      ADAPTER=$( grep adapter_sequence: $PARAM_FILE | awk '{print $2}' )
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/noMM microRNA=hsa isoMiR=true plotMiR=false noMM=0
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name adapter=$ADAPTER microRNA=hsa isoMiR=true plotMiR=false noMM=0" >> $WORKING_DIR/$EXPERIMENT/batch/batch_QUALITY_noMM_$Q$EXPERIMENT.bat
    fi
  fi
  i=$(($i+1))
done
