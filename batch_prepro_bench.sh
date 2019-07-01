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
   echo "Usage: batch_prepro_bench.sh /home/user/working_directory /path/to/SraRunTable.txt samples_downloaded adapter_ask adapter_sequence"
   echo "If adapter_ask is 0, it means that there is no adapter. Type 1 in adapter_ask to guess the adapter or 2 if there is an adapter"
   echo "If you have already downloaded the samples type 1 in samples_downloaded"
   exit
fi

## Parameters

WORKING_DIR=$1
SRA_TABLE=$2
DOWNLOADED=$3
ADAPTER_ASK=$4
ADAPTER=$5

## Busca en el archivo SraRunTable tan solo la parte de la línea que coincide
## con el patrón (-o) de la primera coincidencia (-m 1) que encuentra para
## palabras que empiecen por SRP seguidos de un número. Ese nombre es asignado
## a la variable $EXPERIMENT

EXPERIMENT=$( grep -o -m 1 '\<SRP[0-9]*\>' $SRA_TABLE )

echo "working_dir:" $WORKING_DIR > $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt
echo "sra_table:" $SRA_TABLE >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt
echo "adapter:ask:" $ADAPTER >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt
echo "adapter:" $ADAPTER_ASK >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt
echo "experiment:" $EXPERIMENT >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt
echo "samples_downloaded:" $DOWNLOADED >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

## Creating working directory

cd $WORKING_DIR
mkdir $EXPERIMENT
cd $EXPERIMENT
mkdir data results logs batch

echo "Working directory created" > $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt

## SAMPLE PROCESSING

## Calculate number of samples

## Identificamos la columna que contiene las lecturas Run. Para ello con head
## se imprime la primera línea de la tabla. Con tr se cambian los tabuladores
## por saltos de línea. Con grep -B extraemos las cabeceras de las columnas
## que están antes de la columna Run. Con wc -l las contamos.

RunCol=$( head -n 1 $SRA_TABLE | tr " \t" "\n" | grep -B 40 Run | wc -l )

## Guardamos la variable n para el próximo bucle, que será el número de líneas
## de la columna 5 de la tabla. Esto servirá para finalizar el bucle.

echo "run_column_number:" $RunCol >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

NUMBER_OF_SAMPLES=$( cut -f$RunCol $SRA_TABLE | wc -l )
NUMBER_OF_SAMPLES=$(($NUMBER_OF_SAMPLES-1))

echo "number_of_samples:" $NUMBER_OF_SAMPLES >> $WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt

## Guardamos la columna 5 de la tabla que corresponde a los SRA en la variable
## SRA_NAMES sin la cabecera. Usamos el comando tail que con la opción -n coge
## las últimas $n líneas.

SRA_NAMES=$( cut -f$RunCol $SRA_TABLE | tail -n $NUMBER_OF_SAMPLES )

echo $SRA_NAMES > $WORKING_DIR/$EXPERIMENT/logs/logs_SRA_names.txt

## Downloading samples

## Fijamos el índice en dos para que se salte la cabecera de la columna 5

i=1
while [ $i -le $NUMBER_OF_SAMPLES ]
do
  name=$( cat $WORKING_DIR/$EXPERIMENT/logs/logs_SRA_names.txt | tr " \s" "\n" | tail -n +$i | head -n 1 )
  if [[ $DOWNLOADED -eq 0 ]]
  then
    echo "fastq-dump --outdir $WORKING_DIR/$EXPERIMENT/data/ --gzip $name" >> $WORKING_DIR/$EXPERIMENT/batch/prepro.bat
    echo $name "downloaded:" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
    if [[ $ADAPTER_ASK -eq 0 ]]
    then
      ## Adapter trimming
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/$name graphics=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name graphics=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "pre-processed by java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar whithout adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of MiRBase MicroRNAs
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name graphics=true microRNA=hsa isoMiR=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name graphics=true microRNA=hsa isoMiR=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of MiRBase MicroRNAs whithout adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of other MicroRNA references
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of other MicroRNA references whithout adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
    elif [[ $ADAPTER_ASK -eq 1 ]]
    then
      ## Adapter trimming
      ##  java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name guessAdapter=true graphics=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name guessAdapter=true graphics=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "pre-processed by java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of MiRBase MicroRNAs
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name guessAdapter=true graphics=true microRNA=hsa isoMiR=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name guessAdapter=true graphics=true microRNA=hsa isoMiR=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of MiRBase MicroRNAs guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of other MicroRNA references
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name guessAdapter=true graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name guessAdapter=true graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of other MicroRNA references guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile MicroRNA Expression in Genome Mode
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_genome_$name guessAdapter=true graphics=true microRNA=hsa isoMiR=true species=GRCh38_p10_mp
      ## echo $name "Profile MicroRNA Expression in Genome Mode guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/logs.txt
      ## En el caso de que haya adaptador indicado como parámetro $ADAPTER:
    elif [[ $ADAPTER_ASK -eq 2 ]]
    then
       ## Adapter trimming
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name adapter=$ADAPTER graphics=true
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name adapter=$ADAPTER graphics=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
       echo $name "pre-processed by java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar with adapter" $ADAPTER >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
       ## Profile the Expression of MiRBase MicroRNAs
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name adapter=$ADAPTER graphics=true microRNA=hsa isoMiR=true
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name adapter=$ADAPTER graphics=true microRNA=hsa isoMiR=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
       echo $name "Profile the Expression of MiRBase MicroRNAs" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
       ## Profile the Expression of other MicroRNA references
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name adapter=$ADAPTER graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name adapter=$ADAPTER graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
       echo $name "Profile the Expression of other MicroRNA references" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
       ## Profile MicroRNA Expression in Genome Mode
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_genome_$name adapter=$ADAPTER graphics=true microRNA=hsa isoMiR=true species=GRCh38_p10_mp
       ## echo $name "Profile MicroRNA Expression in Genome Mode" >> $WORKING_DIR/$EXPERIMENT/logs/logs.txt
     fi
  elif [[ $DOWNLOADED -eq 1 ]]
  then
    if [[ $ADAPTER_ASK -eq 0 ]]
    then
      ## Adapter trimming
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/$name graphics=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name graphics=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "pre-processed by java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar whithout adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of MiRBase MicroRNAs
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name graphics=true microRNA=hsa isoMiR=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name graphics=true microRNA=hsa isoMiR=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of MiRBase MicroRNAs whithout adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of other MicroRNA references
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of other MicroRNA references whithout adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
    elif [[ $ADAPTER_ASK -eq 1 ]]
    then
      ## Adapter trimming
      ##  java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name guessAdapter=true graphics=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name guessAdapter=true graphics=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "pre-processed by java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of MiRBase MicroRNAs
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name guessAdapter=true graphics=true microRNA=hsa isoMiR=true
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name guessAdapter=true graphics=true microRNA=hsa isoMiR=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of MiRBase MicroRNAs guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile the Expression of other MicroRNA references
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name guessAdapter=true graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa
      echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name guessAdapter=true graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
      echo $name "Profile the Expression of other MicroRNA references guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
      ## Profile MicroRNA Expression in Genome Mode
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_genome_$name guessAdapter=true graphics=true microRNA=hsa isoMiR=true species=GRCh38_p10_mp
      ## echo $name "Profile MicroRNA Expression in Genome Mode guessing the adapter" >> $WORKING_DIR/$EXPERIMENT/logs/logs.txt
      ## En el caso de que haya adaptador indicado como parámetro $ADAPTER:
    elif [[ $ADAPTER_ASK -eq 2 ]]
    then
       ## Adapter trimming
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name adapter=$ADAPTER graphics=true
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/$name adapter=$ADAPTER graphics=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
       echo $name "pre-processed by java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar with adapter" $ADAPTER >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
       ## Profile the Expression of MiRBase MicroRNAs
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name adapter=$ADAPTER graphics=true microRNA=hsa isoMiR=true
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_$name adapter=$ADAPTER graphics=true microRNA=hsa isoMiR=true" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
       echo $name "Profile the Expression of MiRBase MicroRNAs" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.tx       ## Profile the Expression of other MicroRNA references
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name adapter=$ADAPTER graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa
       echo "java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRGeneDB_$name adapter=$ADAPTER graphics=true microRNA=Hsa isoMiR=true mature=miRGeneDB_mature.fa hairpin=miRGeneDB_pre.fa" >> $WORKING_DIR/$EXPERIMENT/batch/bench.bat
       echo $name "Profile the Expression of other MicroRNA references" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
       ## Profile MicroRNA Expression in Genome Mode
       ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$WORKING_DIR/$EXPERIMENT/data/$name.fastq.gz output=$WORKING_DIR/$EXPERIMENT/results/miRBase_genome_$name adapter=$ADAPTER graphics=true microRNA=hsa isoMiR=true species=GRCh38_p10_mp
       ## echo $name "Profile MicroRNA Expression in Genome Mode" >> $WORKING_DIR/$EXPERIMENT/logs/logs.txt
     fi
  fi
  i=$(($i+1))
done

echo "BATCH FILES FOR PREPROCESSING AND BENCH CREATED" >> $WORKING_DIR/$EXPERIMENT/logs/batch_prepro_logs.txt
