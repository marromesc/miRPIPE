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
  echo "Usage: sh ggplot_quality.sh /home/user/working_directory /path/to/SraRunTable.batt folder_output_name"
  echo "The output folder will be created in /home/user/working_dir/experiment/logs"
  echo "The analysis will be for mean Q=20 and Q=30; min Q=10, Q=20 and Q=30; normal; and noMM"
  exit
fi

# Parameters
WORKING_DIR=$1
SRA_TABLE=$2
FOLDER=$3

EXPERIMENT=$( grep -o -m 1 '\<SRP[0-9]*\>' $SRA_TABLE )
PARAM_FILE="$WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt"
NUMBER_OF_SAMPLES=$( grep number_of_samples: $PARAM_FILE | awk '{print $2}' )

mkdir $WORKING_DIR/$EXPERIMENT/logs/$FOLDER
## Fijando la cabecera
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
echo "name"" \t ""ratio"" \t ""condition" > $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt

j=1
while [ $j -le $NUMBER_OF_SAMPLES ]
do
  name=$( cat $WORKING_DIR/$EXPERIMENT/logs/logs_SRA_names.txt | tr ' \s' '\n' | tail -n $j | head -n 1 )
  ## En el caso de hacer el análisis con mean 20
    ## Entrar en la carpeta stat de los resultados de cada muestra y leer el fichero
    ## isomiR_NTA.txt
    a_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv3p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_20/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    echo $name" \t "$a_wMean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
    echo $name" \t "$t_wMean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
    echo $name" \t "$c_wMean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
    echo $name" \t "$g_wMean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
    echo $name" \t "$lv5p_wMean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
    echo $name" \t "$lv3p_wMean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
    echo $name" \t "$a_mean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
    echo $name" \t "$t_mean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
    echo $name" \t "$c_mean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt
    echo $name" \t "$g_mean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
    echo $name" \t "$lv5p_mean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
    echo $name" \t "$lv3p_mean" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
    echo $name" \t "$a_stdDev" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
    echo $name" \t "$t_stdDev" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
    echo $name" \t "$c_stdDev" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
    echo $name" \t "$g_stdDev" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
    echo $name" \t "$lv5p_stdDev" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
    echo $name" \t "$lv3p_stdDev" \t ""mean_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt

    ## En el caso de hacer el análisis con mean 30
      ## Entrar en la carpeta stat de los resultados de cada muestra y leer el fichero
      ## isomiR_NTA.txt
      a_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
      t_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
      c_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
      g_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
      lv3p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
      a_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
      t_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
      c_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
      g_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
      lv5p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
      lv3p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
      a_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
      t_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
      c_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
      g_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
      lv5p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
      lv3p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_mean_30/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
      echo $name" \t "$a_wMean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
      echo $name" \t "$t_wMean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
      echo $name" \t "$c_wMean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
      echo $name" \t "$g_wMean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
      echo $name" \t "$lv5p_wMean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
      echo $name" \t "$lv3p_wMean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
      echo $name" \t "$a_mean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
      echo $name" \t "$t_mean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
      echo $name" \t "$c_mean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt
      echo $name" \t "$g_mean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
      echo $name" \t "$lv5p_mean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
      echo $name" \t "$lv3p_mean" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
      echo $name" \t "$a_stdDev" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
      echo $name" \t "$t_stdDev" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
      echo $name" \t "$c_stdDev" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
      echo $name" \t "$g_stdDev" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
      echo $name" \t "$lv5p_stdDev" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
      echo $name" \t "$lv3p_stdDev" \t ""mean_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt

      ## En el caso de hacer el análisis con min 10
        ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con min
        ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/min_20 microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=20
        a_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
        t_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
        c_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
        g_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
        lv5p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
        lv3p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
        a_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
        t_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
        c_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
        g_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
        lv5p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
        lv3p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
        a_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
        t_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
        c_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
        g_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
        lv5p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
        lv3p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_10/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
        echo $name" \t "$a_wMean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
        echo $name" \t "$t_wMean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
        echo $name" \t "$c_wMean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
        echo $name" \t "$g_wMean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
        echo $name" \t "$lv5p_wMean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
        echo $name" \t "$lv3p_wMean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
        echo $name" \t "$a_mean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
        echo $name" \t "$t_mean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
        echo $name" \t "$c_mean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt
        echo $name" \t "$g_mean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
        echo $name" \t "$lv5p_mean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
        echo $name" \t "$lv3p_mean" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
        echo $name" \t "$a_stdDev" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
        echo $name" \t "$t_stdDev" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
        echo $name" \t "$c_stdDev" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
        echo $name" \t "$g_stdDev" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
        echo $name" \t "$lv5p_stdDev" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
        echo $name" \t "$lv3p_stdDev" \t ""min_"10 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt


  ## En el caso de hacer el análisis con min 20
    ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con min
    ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/min_20 microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=20
    a_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_20/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    echo $name" \t "$a_wMean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
    echo $name" \t "$t_wMean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
    echo $name" \t "$c_wMean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
    echo $name" \t "$g_wMean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
    echo $name" \t "$lv5p_wMean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
    echo $name" \t "$lv3p_wMean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
    echo $name" \t "$a_mean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
    echo $name" \t "$t_mean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
    echo $name" \t "$c_mean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt
    echo $name" \t "$g_mean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
    echo $name" \t "$lv5p_mean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
    echo $name" \t "$lv3p_mean" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
    echo $name" \t "$a_stdDev" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
    echo $name" \t "$t_stdDev" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
    echo $name" \t "$c_stdDev" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
    echo $name" \t "$g_stdDev" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
    echo $name" \t "$lv5p_stdDev" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
    echo $name" \t "$lv3p_stdDev" \t ""min_"20 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt

    ## En el caso de hacer el análisis con min 30
      ## Lanzamos el java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar para el análisis de la calidad con min
      ## java -jar /opt/sRNAtoolboxDB/exec/sRNAbench.jar input=$INPUT output=$WORKING_DIR/$EXPERIMENT/results/min_20 microRNA=hsa isoMiR=true plotMiR=false qualityType=min minQ=20
      a_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
      t_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
      c_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
      g_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
      lv5p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
      lv3p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
      a_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
      t_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
      c_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
      g_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
      lv5p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
      lv3p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
      a_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
      t_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
      c_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
      g_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
      lv5p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
      lv3p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_min_30/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
      echo $name" \t "$a_wMean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
      echo $name" \t "$t_wMean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
      echo $name" \t "$c_wMean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
      echo $name" \t "$g_wMean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
      echo $name" \t "$lv5p_wMean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
      echo $name" \t "$lv3p_wMean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
      echo $name" \t "$a_mean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
      echo $name" \t "$t_mean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
      echo $name" \t "$c_mean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt
      echo $name" \t "$g_mean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
      echo $name" \t "$lv5p_mean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
      echo $name" \t "$lv3p_mean" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
      echo $name" \t "$a_stdDev" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
      echo $name" \t "$t_stdDev" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
      echo $name" \t "$c_stdDev" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
      echo $name" \t "$g_stdDev" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
      echo $name" \t "$lv5p_stdDev" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
      echo $name" \t "$lv3p_stdDev" \t ""min_"30 >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt

  ## En el caso de hacer el análisis con noMM
    a_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/quality_noMM/$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    echo $name" \t "$a_wMean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
    echo $name" \t "$t_wMean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
    echo $name" \t "$c_wMean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
    echo $name" \t "$g_wMean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
    echo $name" \t "$lv5p_wMean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
    echo $name" \t "$lv3p_wMean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
    echo $name" \t "$a_mean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
    echo $name" \t "$t_mean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
    echo $name" \t "$c_mean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt
    echo $name" \t "$g_mean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
    echo $name" \t "$lv5p_mean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
    echo $name" \t "$lv3p_mean" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
    echo $name" \t "$a_stdDev" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
    echo $name" \t "$c_stdDev" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
    echo $name" \t "$t_stdDev" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
    echo $name" \t "$g_stdDev" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
    echo $name" \t "$lv5p_stdDev" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
    echo $name" \t "$lv3p_stdDev" \t ""noMM" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt
    ## En el caso de las muestras normales
    a_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_wMean=$( cut -f4 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_mean=$( cut -f5 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    a_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -2 | tail -1 )
    t_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -3 | tail -1 )
    c_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -4 | tail -1 )
    g_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_NTA.txt | head -5 | tail -1 )
    lv5p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_otherVariants.txt | head -2 | tail -1 )
    lv3p_stdDev=$( cut -f6 $WORKING_DIR/$EXPERIMENT/results/miRBase_$name/stat/isomiR_otherVariants.txt | head -5 | tail -1 )
    echo $name" \t "$a_wMean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_A.txt
    echo $name" \t "$t_wMean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_U.txt
    echo $name" \t "$c_wMean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_C.txt
    echo $name" \t "$g_wMean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_G.txt
    echo $name" \t "$lv5p_wMean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv5p.txt
    echo $name" \t "$lv3p_wMean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_wMean_lv3p.txt
    echo $name" \t "$a_mean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_A.txt
    echo $name" \t "$t_mean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_U.txt
    echo $name" \t "$c_mean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_C.txt
    echo $name" \t "$g_mean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_G.txt
    echo $name" \t "$lv5p_mean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv5p.txt
    echo $name" \t "$lv3p_mean" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_mean_lv3p.txt
    echo $name" \t "$a_stdDev" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_A.txt
    echo $name" \t "$t_stdDev" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_U.txt
    echo $name" \t "$c_stdDev" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_C.txt
    echo $name" \t "$g_stdDev" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_G.txt
    echo $name" \t "$lv5p_stdDev" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv5p.txt
    echo $name" \t "$lv3p_stdDev" \t ""normal" >> $WORKING_DIR/$EXPERIMENT/logs/$FOLDER/input_stdDev_lv3p.txt
  j=$(($j+1))
done
