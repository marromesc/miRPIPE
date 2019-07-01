#!/bin/bash

## Copyright 2019 Roman-Escorza M. This file is part of miRPIPE miRPIPE is free software: you can redistribute it and/or modify it under the
## terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option)
## any later version. miRPIPE is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a
## copy of the GNU General Public License along with miRPIPE.  If not, see <http://www.gnu.org/licenses/>.

if [ $# -eq 0 ]
then
  echo "Usage: sh batch_QUALITY.sh QUALITY_parameter_file.txt"
  echo "In parameter file, type 0 for mean analysis, 1 for min analysis or 2 for noMM=0"
  exit
fi

## Reading parameters from PARAM_FILE

QUALITY_PARAM_FILE=$1
WORKING_DIR=$( grep working_directory: $QUALITY_PARAM_FILE | awk '{print $2}' )
SRA_TABLE=$( grep sra_table: $QUALITY_PARAM_FILE | awk '{print $2}' )
EXPERIMENT=$( grep -o -m 1 '\<SRP[0-9]*\>' $SRA_TABLE )
PARAM_FILE="$WORKING_DIR/$EXPERIMENT/logs/parameters_file.txt"
NUMBER_OF_SAMPLES=$( grep number_of_samples: $PARAM_FILE | awk '{print $2}' )
NUMBER_OF_ANALYSIS=$( grep number_of_analysis: $QUALITY_PARAM_FILE | awk '{print $2}' )
ADAPTER=$( grep adapter_sequence: $PARAM_FILE | awk '{print $2}' )

i=1
while [ $i -le $NUMBER_OF_ANALYSIS ]
do
  TYPE=$( grep mean_or_min_or_noMM_$i: $QUALITY_PARAM_FILE | awk '{print $2}' )
  Q=$( grep q_number_$i: $QUALITY_PARAM_FILE | awk '{print $2}' )
  echo "sh /home/usr/opt/miRPIPE/batch_QUALITY.sh $WORKING_DIR $SRA_TABLE $ADAPTER $TYPE $Q" >> $WORKING_DIR/$EXPERIMENT/batch/quality_analysis_commands.bat
  i=$(($i+1))
done
