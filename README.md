# Brain Tumor Image Compression using Verilog (RLE-Based)

This project implements an image compression system using Run-Length Encoding (RLE) in Verilog for grayscale MRI brain tumor images. It simulates compression and decompression of pixel data using ModelSim and verifies the accuracy against the original image using a testbench.

## Features

- Compresses grayscale MRI images using RLE.
- Decompresses and reconstructs the original pixel stream.
- Validates compression accuracy by comparing original and decoded data.
- Supports automated simulation for 40 images using a TCL script.

## Dataset

The project uses a Brain Tumor MRI Dataset categorized into four classes:
- Glioma
- Meningioma
- Pituitary
- No Tumor

Each class contains 10 grayscale images, preprocessed into `.mem` files.

## Tools Used

- Verilog for design and simulation
- ModelSim - Intel FPGA Edition for running simulations
- MATLAB for preprocessing images and generating `.mem` files

## How to Run

1. Open ModelSim.
2. Navigate to the Verilog folder where the Verilog files and TCL script are saved. Example:
3. Run the automation TCL script:
   do simulate_all_mem.tcl
4. The script will simulate each `.mem` file one by one and display compression results and accuracy after each simulation.

## Requirements

- ModelSim - Intel FPGA Starter Edition (Quartus Prime 20.1)
- MATLAB (for preprocessing images)
- Brain Tumor MRI dataset (from Kaggle or similar)

## License

This project is intended for academic and educational purposes only.
