# Set tumor classes and file paths
set classes {Glioma Meningioma Pituitary NonTumor}
set basePath "D:/VITC/Assignments/Semester_6/FPGA PROJECT/Verilog_Input"
set outputPath "D:/VITC/Assignments/Semester_6/FPGA PROJECT/Results_Verilog"

# Create results directory if it doesn't exist
if {![file exists $outputPath]} {
    file mkdir $outputPath
}

# Create simulation library if it doesn't exist
if {![file exists work]} {
    vlib work
    vmap work work
}

# Compile all Verilog files once
vlog *.v

# Initialize summary report
set summary_file [open "$outputPath/compression_summary.csv" w]
puts $summary_file "Class,Image,Original Size (bytes),Compressed Size (bytes),Compression Ratio,Successful"

# Loop through each class and image file
foreach class $classes {
    # Create class directory for results
    if {![file exists "$outputPath/$class"]} {
        file mkdir "$outputPath/$class"
    }
    
    for {set i 1} {$i <= 10} {incr i} {
        set filename "$basePath/$class/image_$i.mem"
        puts "\n====================================================="
        puts "Processing: $class - image_$i.mem"
        puts "====================================================="
        
        # Check if the .mem file exists
        if {![file exists $filename]} {
            puts "ERROR: File not found: $filename"
            puts $summary_file "$class,$i,0,0,0.00,No (file not found)"
            continue
        }
        
        # Copy the file to the simulation directory
        file copy -force $filename image_pixels.mem
        
        # Run simulation and capture output
        puts "Starting simulation..."
        set sim_output [exec vsim -c work.tb_image_compression -do "run -all; quit"]
        
        # Save detailed output to log file
        set log_file [open "$outputPath/$class/image_${i}_results.log" w]
        puts $log_file $sim_output
        close $log_file
        
        # Extract compression statistics
        set original_size 0
        set compressed_size 0
        set ratio 0.00
        set success "No"
        
        # Parse simulation output for compression statistics
        if {[regexp {Original data size:\s+(\d+) bytes} $sim_output -> original_size] && 
            [regexp {Compressed data size:\s+(\d+) bytes} $sim_output -> compressed_size]} {
            if {$compressed_size > 0} {
                set ratio [expr {double($original_size) / double($compressed_size)}]
                set success "Yes"
            }
        }
        
        # Add to summary report
        puts $summary_file "$class,$i,$original_size,$compressed_size,[format "%.2f" $ratio],$success"
        
        # Display results for this image
        puts "Results for $class/image_$i.mem:"
        puts "  Original size:    $original_size bytes"
        puts "  Compressed size:  $compressed_size bytes"
        puts "  Compression ratio: [format "%.2f" $ratio]"
        puts "  Successful: $success"
    }
}

close $summary_file

# Generate summary visualization
puts "\n====================================================="
puts "Generating summary visualization..."
puts "====================================================="

# Could add code here to create a visualization of the results (e.g., with Tcl/Tk)
# For example, create a histogram of compression ratios by class

puts "\nCompression testing completed."
puts "Summary report saved to: $outputPath/compression_summary.csv"