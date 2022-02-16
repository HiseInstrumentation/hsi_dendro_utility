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

# TODO:
# 
# User Notes:
# Your column names must be Channel_1 and Channel_2 for raw values
# You must change the COL definitiions below. The default values work with
# current Mini Field Station data files.
# If you want to disable a channel, chnage the value to 0
# If you only have 1 raw data column, change CHANNEL_2_COL to be the same as
# CHANNEL_1_COL.

DATETIME_COL = 1
DEVICE_ID_COL = 2
BATTERY_COL = 3
CHANNEL_1_COL = 4
CHANNEL_2_COL = 5

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
  
  output_filename = "processed.csv"
  
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
        last_d_1 = d_data[i,CHANNEL_1_COL]
        last_d_2 = d_data[i,CHANNEL_2_COL]
      }
      
      if((d_data[i,CHANNEL_1_COL] - last_d_1) > jump_threshold) {
        current_diff_ch1 = current_diff_ch1 + (d_data[i,CHANNEL_1_COL] - last_d_1)
      }
      
      if((last_d_1 - d_data[i,CHANNEL_1_COL]) > jump_threshold) {
        current_diff_ch1 = current_diff_ch1 - (last_d_1 - d_data[i,CHANNEL_1_COL])
      }


      if((d_data[i,CHANNEL_2_COL] - last_d_2) > jump_threshold) {
        current_diff_ch2 = current_diff_ch2 + (d_data[i,CHANNEL_2_COL] - last_d_2)
      }

      if((last_d_2 - d_data[i,CHANNEL_2_COL]) > jump_threshold) {
        current_diff_ch2 = current_diff_ch2 - (last_d_2 - d_data[i,CHANNEL_2_COL])
      }
      
            
      new_value_1 = d_data[i, CHANNEL_1_COL] - current_diff_ch1
      new_value_2 = d_data[i, CHANNEL_2_COL] - current_diff_ch2
      
      if (channels == "1" || channels == "12") { 
        message(paste("Converting ",d_data[i, CHANNEL_1_COL]," to ", new_value_1))
      }
      
      if (channels == "2" || channels == "12") {
        message(paste("Converting ",d_data[i, CHANNEL_2_COL]," to ", new_value_2))
      }
          
      if(DATETIME_COL > 0) {
        output_data[i,DATETIME_COL] = d_data[i,DATETIME_COL]
      }
    
      if(DEVICE_ID_COL > 0) {
        output_data[i,DEVICE_ID_COL] = d_data[i,DEVICE_ID_COL]
      }
      if(BATTERY_COL > 0) {
        output_data[i,BATTERY_COL] = d_data[i,BATTERY_COL]
      }
      
      if(CHANNEL_1_COL > 0) { 
        output_data[i,CHANNEL_1_COL] = new_value_1
        last_d_1 = d_data[i,CHANNEL_1_COL]
      }
      if(CHANNEL_2_COL > 0) {
        output_data[i,CHANNEL_2_COL] = new_value_2
        last_d_2 = d_data[i,CHANNEL_2_COL]
      }
      
    }

    print(output_data)
   
    
    
    if(channels == "1") {
      png(filename = "dend_proc_1.png", width = 725, height = 400)
      par(mar=c(5, 12, 4, 4) + 0.1)
      plot(d_data$Channel_1, axes=F, type="l",col="red",xlab="", ylab="",
           main = paste(source_filename, "Channel 1 Raw"))

      mtext(2,text="Channel 1",line=2)
      axis(2, ylim=c(0,max(max(d_data$Channel_1)),col="red",lwd=2))

      par(new=T)
      plot(output_data$Channel_1, type="l",axes=F, xlab="", ylab="",
           col="blue",)
      axis(4,col="blue",ylim=c(0,max(output_data$Channel_1)), lwd=2)
      mtext(side=4,text="Channel 1 Processed",line=2)
      
      legend("topleft", inset = 0.0, c("Unprocessed", "Processed"), 
             lty = 1, col = c("red", "blue"))
      
    }
    
    if(channels == "2") {
      png(filename = "dend_proc_2.png", width = 625, height = 400)
      plot(d_data$Channel_2, type="l",col="red",
           main = "Raw Dendrometer Data Ch 2")
      points(output_data$Channel_2, col="blue")
    }
  
    dev.off()
    
    
    write.csv(output_data, "processed.csv")
    
     
  } else {
    print("File does not exist!")
  }
  
}
