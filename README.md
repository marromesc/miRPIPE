# miRPIPE

This is my Master Thesis project. 

## miRPIPE program

In this miRPIPE directory there are scripts that you can run to reanalyze the data. Also feel free to use with your own data.

The scripts create a working directory and batch files that you have to run if you want to analyze the samples.

To install the scripts you can run one by one:
*chmod +x script_name.sh*

### batch_prepro_bench.sh

**Usage:** *batch_prepro_bench.sh /home/user/working_directory /path/to/SraRunTable.txt samples_downloaded adapter_ask adapter_sequence*
If adapter_ask is 0, it means that there is no adapter. Type 1 in adapter_ask to guess the adapter or 2 if there is an adapter.
If you have already downloaded the samples type 1 in samples_downloaded.


