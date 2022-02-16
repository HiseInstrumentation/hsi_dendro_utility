# hsi_dendro_utility
Utility scripts for handling HSI dendrometer data. 

## Setup

## Usage


### dbh_remove_jumps.r
Script will look for changes in channel data that exceed the specified threshold. Once this condition is met, the following data is adjusted by that difference. This logic is applied to the entire dataset. The before and after series are output to a plot and a new datafile is generated.

Parameters
1. filename of csv file
2. The threshold difference to remove the "jump"
3. Which channels to process 1, 2, 12

Usage
```
> Rscript dbh_remove_jumps.r source_data_file.csv jump_threshold channels
   source_data_file.csv should be standard HSI dendrometer datafile
   jump_threshold is the min jump value to trigger the correction
   channels should be 1,2 or 12
```
Example
```
> Rscript ./dbh_remove_jumps.r data\sample_dendro_data.csv 50 1
```

Notes
This utility was designed to be used with data files from the MiniFieldStation. If you are using a CSV file from another source, please read the comments in the script.
