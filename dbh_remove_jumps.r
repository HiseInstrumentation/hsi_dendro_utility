# dbh_remove_jumps.r Script for removing large jumps in HSI point dendrometer data
# Copyright (C) 2022 Hise Scientific Instrumentation

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Should be run from parent directory
args <- commandArgs(trailingOnly = TRUE)
jump_threshold = 50

if(length(args) == 0) {
  print("Usage\nRscript dbh_remove_jumps.r source_data_file.csv jump_threshold")
} else {
  if(length(args) == 2) {
    jump_threshold = strtoi(args[2])
  }
  source_filename = args[1]
  output_filename = "output.csv"
  
  if(file.exists(source_filename)) {
    current_diff_ch1 = 0
    current_diff_ch2 = 0
    
    d_data = read.csv(source_filename)

    message("Starting Script")
    message(paste("Source File: ", source_filename))
    message(paste("Output File: ", output_filename))
    message(paste("Jump Threshold: ", jump_threshold))
    
    output_data <- d_data
    
    output_data <- d_data[FALSE,]
    
    
    # Loop through data
    for(i in 1:nrow(d_data)) {
      if(i == 1) {
        last_d_1 = d_data[i,4]
        last_d_2 = d_data[i,5]
      }
      
      if((d_data[i,4] - last_d_1) > jump_threshold) {
        current_diff_ch1 = current_diff_ch1 + (d_data[i,4] - last_d_1)
      }

      if((d_data[i,5] - last_d_2) > jump_threshold) {
        current_diff_ch2 = current_diff_ch2 + (d_data[i,5] - last_d_2)
      }
      
      new_value_1 = d_data[i, 4] - current_diff_ch1
      new_value_2 = d_data[i, 5] - current_diff_ch2
      
      print(paste(d_data[i, 4], ":",current_diff_ch1, new_value_1))
      print(paste(d_data[i, 5], ":",current_diff_ch2, new_value_2))
      
      output_data[i,1] = d_data[i,1]
      output_data[i,2] = d_data[i,2]
      output_data[i,3] = d_data[i,3]
      output_data[i,4] = new_value_1
      output_data[i,5] = new_value_2
      
      last_d_1 = d_data[i,4]
      last_d_2 = d_data[i,5]
      
    }
    
    print(output_data)
    
  } else {
    print("File does not exist!")
  }
}
