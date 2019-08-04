# miRPIPE

This is my Master Thesis project at the University of Granada (UGR).

## miRPIPE program

Simple programs to parallelize the analysis of miRNA in human samples with sRNAtoolbox (https://bioinfo2.ugr.es/srnatoolbox/). 

Feel free to parallelize your own projects.

### Installation

1. Download the miRPIPE folder from https://github.com/marromesc/miRPIPE/tree/master/miRPIPE
2. Move it to your opt folder. *mv miRPIPE.zip /home/usr/opt/miRPIPE.zip*
3. Unzip *unzip miRPIPE.zip*
4. Run one by one for each script: *chmod +x script_name.sh*

### Scripts

**1. batch_prepro_bench.sh**

1. Creating working directory with these folders: 
- data for the downloaded samples
- logs for the log files that you can check if there is any error
- batch for the batch files in .bat format
- results for the results

2. Creating batch file for sRNAbench analysis.

USAGE:

*batch_prepro_bench.sh /home/user/working_directory /path/to/SraRunTable.txt samples_downloaded adapter_ask adapter_sequence*

If you have already downloaded the samples type 1 in samples_downloaded. If not, type 0.
If adapter_ask is 0, it means that there is no adapter. Type 1 in adapter_ask to guess the adapter or 2 if there is an adapter.

OUTPUTS: 

- */home/user/working_directory/experiment/batch/prepro.bat*. An optionally batch file output. Running it you will download the samples parallely if you have not done before. 
- */home/user/working_directory/experiment/batch/bench.bat*. Runnng it you will perfom sRNAbench analysis. 
- */home/user/working_directory/experiment/logs/parameter_file.txt*. Samples report. It will be used by other scripts.

**2. DE.sh**

Creates a batch file that you can run to analyze the differential expression of your data.

USAGE: 

*sh DE.sh /home/user/working_directory /path/to/SraRunTable.txt column*

In column, type the name of the SRA Table's column where it is the phenotypes conditions.

OUTPUT:

*/home/user/working_directory/experiment/batch/DE.bat*. Running it you will also run parallely both miRBase and miRGeneDB differential expression analysis.

**3. quality_creator.sh**

A simple script to parallelize quality sRNAbench analysis.

USAGE:

*Usage: sh batch_QUALITY.sh QUALITY_parameter_file.txt*

In parameter file, type 0 for mean analysis, 1 for min analysis or 2 for noMM=0. You have a QUALITY_parameter_file.txt example in the documentation.

OUTPUTS:

- */home/user/working_directory/experiment/batch/quality_analysis_commands.bat*. Running it you will also run parallely BATCH QUALITY for all the analysis indicated before.
- */home/user/working_directory/experiment/batch/quality_boxplot_commands.bat*. Running it you will also run parallely BATCH QUALITY BOXPLOT for all the analysis indicated before.

**4. batch_QUALITY.sh**

Creates a batch file for quality sRNAbench analysis parallely.

USAGE:

*sh batch_QUALITY /home/user/working_directory /path/to/SraRunTable.bat mean_or_min_or_noMM Q*

Type 0 for mean analysis, 1 for min analysis or 2 for noMM=0

OUTPUTS: 

The output will be generated in the batch folder. Example: */working_dir/experiment/batch/batch_QUALITY_type_20SRP049635.bat*. Running it you will run BATCH_QUALITY script parallely for all the analysis indicated in the parameter file.

**5. input_ggplot_quality.sh**

Create the input to generate a boxplot to visualize the quality in the isoMiRs profiles with ggplot package in R.

USAGE: 

*sh batch_ggplot_quality.sh /home/user/working_directory /path/to/SraRunTable.batt folder_output_name*

OUTPUTS:

The output will be generated in the logs folder. Example: */working_dir/experiment/logs/folder_output/input_+.txt*.

**6. ggplot_quality.R**

Visualization of the quality impact in isomiRs and other variants with ggplot package in R.

USAGE: 

*Rscript ggplot_quality.R results_directory path_to_input*

OUTPUTS:

The output will be generated in the results_directory that you have to create previously. 

