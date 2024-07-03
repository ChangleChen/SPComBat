# SPComBat: image harmonization and characterization of inter-scanner variability in Matlab

<div id='id-section1'/>

## Installation and Prerequisites
To use this method, please download `pkg_spcombat` and add the directory to your Matlab path
```matlab
addpath('path/to/the/folder/pkg_spcombat');
```

Prerequisites: Please download [SPM12](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/) software and [CAT12](https://neuro-jena.github.io/cat/index.html#DOWNLOAD) toolbox and add them to your Matlab path as well.
```matlab
addpath('path/to/the/folder/spm12');
% put the CAT12 folder into /spm12/toolbox, and it will be automatically added to the search directories
```
The original environment for SPComBat development was using 
- MATLAB R2022a
- SPM12 (v7771)
- CAT12 (v12.8.2)

<div id='id-section2'/>

## Estimate inter-scanner variability using SPComBat
To estimate ComBat-derived parameters representing inter-scanner variation in T1-weighted images, please refer to the `SPComBat_script_estimate.m` script that contains step-by-step instructions to demonstrate how to run the code on an individual basis. You can also use the matched T1-weighted images provided in this directory to test the script.
