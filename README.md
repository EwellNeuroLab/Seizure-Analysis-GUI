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

![image](https://user-images.githubusercontent.com/94412124/171505253-4e66b020-8f70-4900-aad7-9faa65492c1b.png)

Line 1 - any comment can be added here, but only here.

Line 2 - information about the first mouse. I. Open Ephys port (A,B,C or D) II. mouse's name/ID (arbitrary, M15 here) III. list of channels belonging to this mouse (8 23). Make sure to put comma between port,id,channels. Channel number should be separated by space.

Line 3-5 - information about the other 3 mice. Each mouse should be in a separate row


## GUI guide

## Editing the GUI
 
As a first step, you need to select a working directory where your data and a config.txt file live. An example for the config file can be found in this repository.

Editing the code. Open the file within MATLAB App Designer.
