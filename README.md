# miRPIPE

This is my Master Thesis project at the University of Granada (UGR).

## miRPIPE program

In this miRPIPE directory there are scripts that you can run to reanalyze the data. Also feel free to use with your own data.

### Installation

1. Download the miRPIPE folder from https://github.com/marromesc/miRPIPE/tree/master/miRPIPE
2. Move it to your opt folder. *mv miRPIPE.zip /home/usr/opt/miRPIPE.zip*
3. Unzip *unzip miRPIPE.zip*
4. Run one by one for each script: *chmod +x script_name.sh*

### Scripts

Scripts create a working directory and batch files that you have to run to start the analysis.

**batch_prepro_bench.sh**

USAGE:

*batch_prepro_bench.sh /home/user/working_directory /path/to/SraRunTable.txt samples_downloaded adapter_ask adapter_sequence*

If you have already downloaded the samples type 1 in samples_downloaded. If not, type 0.
If adapter_ask is 0, it means that there is no adapter. Type 1 in adapter_ask to guess the adapter or 2 if there is an adapter.

OUTPUTS: 

**quality_creator.sh**

**batch_QUALITY.sh**

