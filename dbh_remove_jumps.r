# Should be run from parent directory
args <- commandArgs(trailingOnly = TRUE)

if(length(args) == 0) {
  print("Please specify a file")
} else {
  if(file.exists(args[1])) {
    current_diff_ch1 = 0
    current_diff_ch2 = 0
    
    d_data = read.csv(args[1])
    View(d_data)
    print(nrow(d_data));
    print(ncol(d_data));
    print(colnames(d_data))
    str(d_data)
  
    # Loop through data
    # Remember last ch_1
    # If current ch_1 is a lot different than the last one, record difference.
    # Write to new dataset, subtracting any current difference
    
  
  } else {
    print("File does not exist!")
  }
}
