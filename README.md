# SETUP
First you need to get setup!

REQUIREMENTS:
- Windows PC ( This guide is written for a windows user, unfortunately I don't use Linux or MacOS so i can't help you there)
- CUDA-Capable GPU ( which should be most modern nvidia GPUs)

## 0. Install latest CUDA Toolkit supported by Pytorch:
### 0.1 Check out the pytorch website first to see which cuda toolkit is supported:
https://pytorch.org/get-started/locally/
![image](https://github.com/user-attachments/assets/d66ff804-7bb1-4cac-b9e6-9b5961b3c310)
if the latest toolkit is cuda 12.8; then install that:
https://developer.nvidia.com/cuda-12-8-0-download-archive 

if this changes in the future; do a google search and install the appropriate one!

## 1. Install Miniconda:
https://docs.anaconda.com/free/miniconda/index.html
After installation, verify that you've conda available:

Open up command prompt, verify install by typing in ```where conda```, it should show the path to the conda exe.

## 2. Install Git
https://git-scm.com/download/win

You'd need Git in order to clone the repo! 

## 3. Clone this repository locally:
- ```git clone https://github.com/blewClue215/RVM_ON_SEGMENTS.git```
  
Move into the repo root folder
  - ```cd RVM_ON_SEGMENTS ```

## 4. Setup the python conda environment that these scripts will use!
4.1 Open Command Prompt
- Make sure (base) is not active if it is then: ```conda deactivate ```
- ```conda create --name rvm python==3.9``` Currently latest pytorch needs python 3.9 minimum... subject to changes
- ```conda activate rvm```


4.2 Install Pytorch
- To check what's the actual cuda toolkit version you have, run this in the command prompt:
- ``` nvcc --version ```
- Use the command you'd have retrieved from that website based on the cuda toolkit version you have:
https://pytorch.org/get-started/locally/
- ```pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128```

This installs the core dependency of pytorch that this whole project requires!

4.3. Once this is done make sure you're still in the project root folder (/RVM_ON_SEGMENTS)
  - ```pip install -r requirements_inference.txt```


## 5. Install FFMPEG:
https://phoenixnap.com/kb/ffmpeg-windows
We need this to split up the segments, and recombine them after


# PRE-INFERENCE

Before you start inferencing you need to split up long-form videos into segments!
- This makes the overall inference process more reliable as you wouldn't block the whole inference process due to one small decoding problem
- Becomes less of a memory hog, it can eat up a lot of memory or even run out of memory trying to infer on a 15 minutes 8K video!
- Plus you can stop the process at any time and restart the inference on remaining video segments because the inferenceCustom.py script is designed for it. 

## 1. Drag and Drop the video:
<img width="762" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/e569651f-f52f-42f6-965c-a288bb1f6a8a">


## 2. Specify how long each segment should be:
<img width="867" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/2b30f8b9-148a-413a-8451-ffb99839b024">

The shorter the segment, the more matting pops you will see when the video is combined but it also drastically reduces the amount of memory hog and improves reliability of the whole inference process (I like to go with 15 seconds here)

## 3. After the process is done, confirm that the output is good!
<img width="1158" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/343c31fc-c38c-4a8f-ad0a-162afa3650d7">
There should be a folder named the same as the video but with a suffix of "_segments"
There should be segmented mp4 here + a file_list.txt


# INFERENCING

Inferencing is the act of "inferring" data from the input using the model that has been trained; in this case we want the segments to be used to infer alpha mattes from the model ( rvm_mobilenetv3.pth )

That's handled by inferenceCustom.py!

All you need to do is to:
## 1. Drag and Drop Segments folder
<img width="729" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/59b8a54e-95bc-416c-a8e6-e5f59dd4eb9c">

## 2. Decide if you want to shutdown the computer after inference is done:
<img width="865" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/ffa553c6-504c-405d-8aaf-efd499b7b343">

I added this because sometimes the inference can run for up to 40 hours on 40 minutes of footage, so i prefer to let it shutdown itself after it's done to save power.

## 3. Once Inference is done, go into the "_matted" folder and look at the processed.json
<img width="1154" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/d04f6dd4-ed98-4211-b2bc-a9c47ce8e70a">

Ensure it is all True ( which means all the segments were processed successfully)!

Note: At any point you can stop or restart the inference process!

Restarting is simply dragging-and-dropping the segment folder onto the script again at which point the inference will be restarted for any file that is "False" in this .json, but you might want to check out why the video segment failed by playing it in the "segments" folder before you restart the process.

# POST-INFERENCING

Now that inference is done and you have matted video segments, you need to combine them together!

## 1. Drag and Drop Segments Matted Folder to combine the segments together
<img width="685" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/fcd53932-bbd8-4777-95fa-6e23def7a1f8">

This will produce a "COMPOSITE_SEGMENTS_COMBINED.mp4" but it will not have audio. 

## 2. Drag and Drop the original Video file to combine the matted video and original audio together!
<img width="830" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/d91a3b33-9ba9-470d-b8ee-4bff60a8dcae">

This will produce the matted video with the audio from the original video! 

So by the end of it your folder should look something like this:
<img width="717" alt="image" src="https://github.com/blewClue215/RVM_ON_SEGMENTS/assets/154766775/33301865-06e4-4bf1-a503-57fdf2db64de">

Now your matted video is ready to enjoy!

# Possible Problems and Solutions:

## 1. Frozen images after matting is complete:
For the frozen images it could be any number of reasons!

So the steps to troubleshoot is:
1. Go to the “segments_matted” folder and find the video segment that had frozen frames
eg. Output_0001.mp4
2. Go to the “segments” folder and find Output_0001.mp4, play it in your media player and see if it skips/weird pixel artifacts/purple screen
   
If it does, then that source segment failed to encode properly when segmenting:
  1. Resegment the video
  2. Copy the resegmented Output_0001.mp4 and pop it into a new folder, maybe name it “FIX_ME”
  3. Run inference on “FIX_ME” folder
  4. Once done, copy “FIX_ME/COMPOSITE/Output_0001.mp4” back to the “segments_matted” folder

If not, try the same steps as above but without resegmenting the video.

If the above does not work, the worst case scenario is to segment and reencode to H.265:

1. Open up "1. DRAG AND DROP VIDEO TO SEGMENT HERE.bat"
2. Copy and replace everything in that file with this:
```
@echo off
if "%~1" == "" (
    echo Drag and drop a video file onto this batch file to split it into 1-minute segments.
    pause
    exit /b
)

set /p time="Time in seconds per segment:"

set input_file=%~1
set output_folder=%~dpn1_segments

mkdir "%output_folder%"

ffmpeg -i "%input_file%" -c:v libx265 -crf 18 -preset medium -c:a aac -b:a 128k -f segment -segment_time "%time%" -reset_timestamps 1 "%output_folder%\output_%%03d.mp4"

cd "%output_folder%"
(for %%i in (*.mp4) do @echo file '%%i') > file_list.txt

echo Video has been split into 1-minute segments and reencoded to H.265 with minimal loss.
pause
 ```
3. Save
4. Drag and drop video file on this.

WARNING: THIS WILL TAKE A LOT LONGER TO SEGMENT THE VIDEO BUT SHOULD MAKE IT WORK!


