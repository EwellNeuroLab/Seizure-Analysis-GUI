# Seizure-Analysis-GUI

Download SeizureAnalysisEwellLab.mlapp and double-click on the file to run the GUI.


## Dependencies
Code was written in Matlab 2021b and R2022a. Necessary package(s):
* Signal Processing Toolbox

### Input data
The GUI is optimized for data acquired with our Bonsai workflow (https://github.com/EwellNeuroLab/Chronic-Recordings-Bonsai-Workflow).
GUI expects the user to select a working directory (see GUI guide section for details) with the following content:
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
Double-click on the SeizureAnalysisEwellLab.mlapp. Wait for MATLAB to open and then the GUI will pop up.

**Loading the working directory**
Press the *Choose Working Directory!* button. A small window will pop-up, where a user ID has to by typed in (such as initials). The ID will be appended to the output file name. Next, select the working directory where timestamp/voltage/video data + config.txt are.

**Selecting mouse and recording date**
The GUI loads the mouse names from the configuration file and recording dates from the file names. In the *Date* and *Mouse ID* dropdown menus, select the recording date and the mouse, then press the *Read Files* button. 

![image](https://user-images.githubusercontent.com/94412124/171508881-05b47dac-c882-4f8b-9a0a-fc3500d5ad95.png)

A green bar shows the progress of loading the data.

**Plot settings**
When the data is loaded, press the *Plot LFP button*. In default, every channel defined for this mouse in the config file are displayed in the LFP Viewer. 
Channel selection (top box): tick/untick channels to show/hide. Press *Plot LFP button* to refresh the LFP Viewer. 

![image](https://user-images.githubusercontent.com/94412124/171509478-5666a1f3-45ea-457a-8697-ae21b2ffdf06.png)

Sampling Rate field: set the sampling rate of LFP sampling in kilohertz.

TimeWindow(s): when the user clicks on the timeslider to timepoint T, LFP + video are displayed from T-TimeWindow to T+TimeWindow. Furthermore, during seizure scoring, seizures are displayed as TimeWindow (pre-seizure) - Seizure - TimeWindow (post-seizure). In this example, we set the TimeWindow to 10 s.

*Note: Since LFP displayed in a MATLAB figure, user can access a plot menu by bringing the cursor on the figure. In the menu, user can select a zoom in/out or hand tool to move along X-Y axis.*

**Video calibration**
To ensure that the video playback reflects real-time speed, a video calibration method is provided.
1) Click anywhere on the time slider in the bottom of the GUI. 
2) LFP and video are displayed, in the length of 2xTimeWindow, in this example 2x10 = 20 s.
3) In the end, on the video elapsed time is displayed. 
4.1) Video is replayed in real-time (elapsed time is close to 2x TimeWindow): no action is needed
4.2) Video is replayed faster (elapsed time << 2x TimeWindow): increase the Video lag variable to make the video display slower.
4.3) Video is replayed slower (elapsed time >> 2x TimeWindow): decrease the Video lag variable to make the video display faster. Note: at the very first video replay, it can happen that the first frames are 'stuck' and therefore resulting a slower overall replay speed. If this is observed, click on the time slider again and repeat the steps above.

This step is recommended when the GUI is used for the first time. Elapsed video time is displayed during seizure scoring as well, therefore replay speed can be adjusted anytime when it's necessary.

**Seizure detection**
Click on the *Seizure Detection* button. A detection window pops up where the user can set the followings. LFP is downsampled and filtered (parameters are displayed).

1) Channel: channel to use for seizure detection
2) Threshold: Amplitude threshold (N x std, where N can be set as integer)
3) Min Dur (s): minimum duration of a seizure

For setting the filtering/downsampling parameters:
4) DownSample (Hz): new (lower) sample rate for the LFP
5) BandPass (Hz): lower and upper boundaries of the bandpass filter
6) Press the *Apply Filter Settings* button 

When everything is set, press the *Run Detection* button. Detected seizures are displayed. Results can be accepted by the *Accept Results* button or can be rerun after modifying thresholding/filtering parameters.

Note 1: if seizure detection has already happened in this working directory, the GUI offers the user to load previous settings. 

**Scoring**
When detection result is accepted, the first seizure is shown in the LFP Viewer. By pressing the *Play Video* button, video-LFP of the first seizure are played. Scoring questions can be answered and saved by pressing the *Save* button.

![image](https://user-images.githubusercontent.com/94412124/171514298-5f96102d-8820-480b-a01e-13f2d44ba6a4.png)

User can toggle between seizures with the *Previous* and *Next* buttons.


**Output files**

**Warning and error messages**

## Editing the GUI

### Input data
### Channel labels
### Seizure detection
 
As a first step, you need to select a working directory where your data and a config.txt file live. An example for the config file can be found in this repository.

Editing the code. Open the file within MATLAB App Designer.
