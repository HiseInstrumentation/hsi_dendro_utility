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
channels = "1"

if(length(args) == 0) {
  message("Usage\nRscript dbh_remove_jumps.r source_data_file.csv jump_threshold channels\n\tsource_data_file.csv should be standard HSI dendrometer datafile\n\tjump_threshold is the min jump value to trigger the correction\n\tchannels should be 1,2 or 12\n")
} else {
  jump_threshold = strtoi(args[2])
  channels = args[3]

  
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
    if(channels == "1") {
      message("Processing Channel 1")
    } else if (channels == "12") {
      message("Processing Channel 1 and 2")
    } else {
      message("Processing Channel 2")
    }
    
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
      
      if (channels == "1" || channels == "12") { 
        message(paste("Converting ",d_data[i, 4]," to ", new_value_1))
      }
      
      if (channels == "2" || channels == "12") {
        message(paste("Converting ",d_data[i, 5]," to ", new_value_2))
      }
      
      
      output_data[i,1] = d_data[i,1]
      output_data[i,2] = d_data[i,2]
      output_data[i,3] = d_data[i,3]
      output_data[i,4] = new_value_1
      output_data[i,5] = new_value_2
      
      last_d_1 = d_data[i,4]
      last_d_2 = d_data[i,5]
      
    }

    print(output_data)
   
    
    
    if(channels == "1") {
      png(filename = "dend_proc_1.png", width = 625, height = 400)
      
      plot(d_data$Channel_1, type="l",col="red",
           main = "Raw Dendrometer Data Ch 1")
      points(d_data$Channel_1, col="blue")
      axis(4,col="red",ylim=c(0,max(d_data$Channel_1)), lwd=2)
      
      par(new=T)
      plot(output_data$Channel_1, type="l",col="blue")
      points(output_data$Channel_1, col="blue")
      axis(4,col="blue",ylim=c(0,max(output_data$Channel_1)), lwd=2)
      
      
    }
    
    if(channels == "2") {
      png(filename = "dend_proc_2.png", width = 625, height = 400)
      plot(d_data$Channel_2, type="l",col="red",
           main = "Raw Dendrometer Data Ch 2")
      points(output_data$Channel_2, col="blue")
    }
    
    
  
    dev.off()
    
     
  } else {
    print("File does not exist!")
  }
  
}
