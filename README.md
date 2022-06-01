# Seizure-Analysis-GUI

Download SeizureAnalysisEwellLab.mlapp and double-click on the file to run the GUI.


## Dependencies
Code was written in Matlab 2021b and R2022a. Necessary package(s):
* Signal Processing Toolbox

The GUI is optimized for data acquired with our Bonsai workflow (https://github.com/EwellNeuroLab/Chronic-Recordings-Bonsai-Workflow).


## Input data

GUI expects the user to select a working directory (see GUI guide section for details) where the following files exist:
* Timestamp files: uint32 binary files, contains video & LFP timestamps
* Voltage data files: uint16 binary files, contains data from every selected channels in the Bonsai workflow
* Video files: avi video files
**Important. The GUI expects specific file names: 'ts+timestamp', 'amplifier+timestamp', 'vid+timestamp'. See more detail in the README in https://github.com/EwellNeuroLab/Chronic-Recordings-Bonsai-Workflow**

* Configuration file: a .txt file with a specific structure, containing important information about the experiment.

![image](https://user-images.githubusercontent.com/94412124/171504438-0c74d0d1-0907-4b4d-8e1d-5315f0ca0abe.png)

Line 1 - any comment can be added here, but only here.


## GUI guide

## Editing the GUI
 
As a first step, you need to select a working directory where your data and a config.txt file live. An example for the config file can be found in this repository.

Editing the code. Open the file within MATLAB App Designer.
