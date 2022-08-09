# Seizure-Analysis-GUI

### If you use this code, please cite https://doi.org/10.1101/2022.07.14.500102

SeizureAnalysisEwellLab.mlapp - download and double-click on the file to run the GUI.
app_icon.png - icon for the GUI, can be run without it
config.txt - an example for configuration file (see details below)
readLFP_Bonsai.m - a script that reads the Bonsai output files into MATLAB
ReadScoringFiles.m - a script to make easier to summarize the outputs of the scoring results


### Dependencies
Code was written in Matlab 2021b and R2022a. Necessary package(s):
* Signal Processing Toolbox

### GUI update
See GUIVersions.txt for details when and what kind of changes occured on the GUI.

## Input data
The GUI is optimized for data acquired with our Bonsai workflow (https://github.com/EwellNeuroLab/Chronic-Recordings-Bonsai-Workflow).
GUI expects a working directory with the following content:
* Timestamp files: uint32 binary files, contains video & LFP timestamps
* Voltage data files: uint16 binary files, contains data from every selected channels in the Bonsai workflow
* Video files: avi video files

**Important. The GUI expects specific file names: 'ts+timestamp', 'amplifier+timestamp', 'vid+timestamp'. See more detail in the README on https://github.com/EwellNeuroLab/Chronic-Recordings-Bonsai-Workflow**

* Configuration file: a .txt file with a specific structure, containing important information about the experiment.

![image](https://user-images.githubusercontent.com/94412124/171505253-4e66b020-8f70-4900-aad7-9faa65492c1b.png)

Line 1 - any comment can be added here, but only here.

Line 2 - information about the first mouse. I. Open Ephys port (A,B,C or D), II. mouse's name/ID (arbitrary, M15 here), III. list of channels belonging to this mouse (8 23). Make sure to put comma between port,id,channels. Channel numbers should be separated by space.

Line 3-5 - information about the other 3 mice. Each mouse should be in a separate row

*Note: the GUI can handle up to 32 channels for each mouse. If more is needed, some modification is needed (see Editing the GUI section for details)*


## GUI guide
Double-click on the SeizureAnalysisEwellLab.mlapp. Wait for MATLAB to open and then the GUI will pop up.

**_Loading the working directory_**

Press the *Choose Working Directory!* button. A small window will pop-up, where a user ID has to by typed in (such as initials). The ID will be appended to the output file name. Next, select the working directory where timestamp/voltage/video data + config.txt are.

**_Selecting mouse and recording date_**

The GUI loads the mouse names from the configuration file and recording dates from the file names. In the *Date* and *Mouse ID* dropdown menus, select the recording date and the mouse, then press the *Read Files* button. 

![image](https://user-images.githubusercontent.com/94412124/171508881-05b47dac-c882-4f8b-9a0a-fc3500d5ad95.png)

A green bar shows the progress of loading the data.

**_Plot settings_**

When the data is loaded, press the *Plot LFP button*. In default, every channel defined for this mouse in the config file are displayed in the LFP Viewer. 
Channel selection (top box): tick/untick channels to show/hide. Press *Plot LFP button* to refresh the LFP Viewer. 

Sampling Rate: set the sampling rate of LFP sampling in kilohertz.

TimeWindow(s): when the user clicks on the timeslider to timepoint T, LFP + video are displayed from T-TimeWindow to T+TimeWindow. Furthermore, during seizure scoring, seizures are displayed as TimeWindow (pre-seizure) - Seizure - TimeWindow (post-seizure). In this example, we set the TimeWindow to 10 s.

*Note: Since LFP displayed in a MATLAB figure, user can access a plot menu by bringing the cursor on the figure. In the menu, user can select zoom in/out tool or hand tool to move along X-Y axis.*

![image](https://user-images.githubusercontent.com/94412124/171509478-5666a1f3-45ea-457a-8697-ae21b2ffdf06.png)


**_Video calibration_**

To ensure that the video playback reflects real-time speed, a video calibration method is provided.
1) Click anywhere on the time slider in the bottom of the GUI. 
2) LFP and video are displayed, in the length of 2xTimeWindow, in this example 2x10 = 20 s.
3) When the video replay ends, elapsed time is displayed. 
4) Video is replayed in real-time (elapsed time is close to 2x TimeWindow): no action is needed
5) Video is replayed faster (elapsed time << 2x TimeWindow): increase the *Video lag* variable to make the video display slower.
6) Video is replayed slower (elapsed time >> 2x TimeWindow): decrease the *Video lag* variable to make the video display faster. Note: at the very first video replay, it can happen that the first frames are 'stuck' and therefore resulting a slower overall replay speed. If this is observed, click on the time slider again and repeat the steps above.

This step is recommended when the GUI is used for the first time. Elapsed video time is displayed during seizure scoring as well, therefore replay speed can be adjusted anytime when it's necessary.

**_Seizure detection_**

The built-in seizure detection algorithm is a thresholding on a bandpass-filtered LFP. Detect peaks are merged within a certain time window and considered as seizure when they are longer than a user-defined time.
Moreover, a second algorithm is provided that takes the FFT of the downsampled LFP in small windows and averages it out in the 4-40 Hz frequency range. The resulting trace is thresholded and the detected points are merged within a certain time window and considered as seizure when they are longer than a user-defined time 

Click on the *Seizure Detection* button. A detection window pops up where the user can set the followings. 

1) When the checkbox is clicked, the custom-written algorithm is used (in this case, the FFT-based algorithm).
2) Channel: channel to use for seizure detection
3) Threshold: Amplitude threshold (N x std, where N can be set as integer)
4) Min Dur (s): minimum duration of a seizure
5) Merge Bursts (s): the time-window within detected bursts are merged to form seizure candidates

By default, LFP is downsampled (500 Hz) and filtered (3-50 Hz). In the same window, these parameters can be adjusted.

1) DownSample (Hz): new (lower) sample rate for the LFP
2) FreqRange (Hz): lower and upper boundaries of the bandpass filter/ frequency band where the mean is calculated in the case of the 2nd algorithm
3) Press the *Apply Filter Settings* button 

When everything is set, press the *Run Detection* button. Detected seizures are displayed. Results can be accepted by the *Accept Results* button or can be rerun after modifying thresholding/filtering parameters.

*Note: if seizure detection has already happened in this working directory, the GUI offers the user to load previous settings.* 

**_Custom-written seizure detection_**

The user may use their own algorithm to detect seizures. In order to demonstrate how to do this, we added a second, spectral-based algorithm. The algorithm is wrapped up in the CustomSeizureDetection() function and contains the following features:

1)  Input of any custom-written detection algorithm - the LFP read by the GUI
2)  Incorporate the input fields, such as FreqRange and Channel to provide user settings for any kind of algorithm (optional) 
3)  Output - Seizure Onset, Seizure Offset and Duration vectors measured in seconds (N events means N long vectors) - that are crucial to ensure that the scoring works well! Moreover, an output mat file where any information about the seizure can be saved.

When the user wishes to use their own algorithm, the content of this function needs to be replaced to any arbitrary algorithm. 


**_Scoring_**

When detection result is accepted, the first seizure is shown in the LFP Viewer. By pressing the *Play Video* button, video for the first seizure is played. Scoring questions can be answered and saved by pressing the *Save* button. User can toggle between seizures with the *Previous* and *Next* buttons.


**_Output files_**
Most important information can be found in the Scoring file.
Within the working directory, a Seizure Detection Output folder is created. In this folder, 3 files are created for individual detection & scoring.

Settings file: channel # for detection, amplitude threshold, signed multiplier (-1 if flipped, +1 if not flipped),  required minimum duration. Once it's created, it can be loaded into the GUI and used as a template for further detections.

*Scoring file*: Mouse name, recording date, user ID, onset,offset, duration, LFP and behavioral scoring answers and comments for each event. 
*Note: the n variable is a counter in the GUI that does not always reflects the number of seizures. Use the length of a vector (i.e onset vector) to determine number of seizures.*

Detection Results file: # of detected events, a time vector for each event, onset,offset and duration for each event, applied amplitude threshold, filtering and downsampling settings.

*Output file names*: each output file has a specific 
* mouse ID
* user ID
* recording date
* scoring date

This way the same mouse/same hour can be scored by more than one person, moreover the scoring date ensures that the same person can finish scoring of one dataset in different times (resulting in more than one files.) 

*Note: ReadScoringFiles.m script to organize and merge the output files is provided.*

**_Warning and error messages_**

**No configuration file was found!** 

Happens when the working directory does not have. Add the configuration file and press the *Choose Working Directory!* button again. 

**There are X more data point in timestamp file. Data was chunked to match amp file, but consider double-checking your data.**

or

**There are X more data point in amp file. Data was chunked to match timestamp file, but consider double-checking your data.**

Sometimes it can happen that the timestamp or the amplifier file has less data, usually with one data packet (X = 256) and therefore not requires user action. However, if X is a high number, double-check your data!


## Editing the GUI
In order to edit the GUI, open MATLAB (R2021b or newer). Go to APPS -> Design App. Open the SeizureAnalysisEwellLab.mlapp file. Go to Code View.


**_Modifying channel labels_**
In our experiments, two channels were used for each mouse. Therefore only two labels are defined in the GUI - left and right. In order to modify/add more label do the following: 
Go to line 736-737 to edit the existing labels. Add more labels by changing the index of app.ChannelLabel vector (such as app.ChannelLabel(3) = " (3rd channel)"; app.ChannelLabel(4) = " (4th channel)";)

**_Modifying the number of maximum channels_**
The GUI is set to a maximum number of 32 channels. If more than 32 is needed:
Go to line 733-734 and change the 32 to any number in the zeros() and strings() function.

**_Replacing the seizure detection algorithm_**
 Go to line 225 and replace the SeizureDetection_EwellLabV2 function. This function is called in line 362, make sure you change it to the function you are using.
 

