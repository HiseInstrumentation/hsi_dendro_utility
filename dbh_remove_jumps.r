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
  print("Please specify a file")
} else {
  if(length(args) == 2) {
    jump_threshold = strtoi(args[2])
  }
  if(file.exists(args[1])) {
    current_diff_ch1 = 0
    current_diff_ch2 = 0
    
    d_data = read.csv(args[1])

    print(paste("JT:", jump_threshold))
    
    # Loop through data
    for(i in 1:nrow(d_data)) {
      if(i == 1) {
        last_d = d_data[i,4]
      }
      
      if((d_data[i,4] - last_d) > jump_threshold) {
        current_diff_ch1 = current_diff_ch1 + (d_data[i,4] - last_d)
      }
      
      new_value = d_data[i, 4] - current_diff_ch1
      
      print(paste(d_data[i, 4], ":",current_diff_ch1, new_value))
      
      last_d = d_data[i,4]
      
    }
  } else {
    print("File does not exist!")
  }
}
