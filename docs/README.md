# Title
Customized Algorithm for Video Analysis in MATLAB - Cervical Movement Sense (CMS) Test in the Zigzag Pattern.

# Overview
This customized algorithm was developed in MATLAB software (developed and tested on version R2023a; The MathWorks Inc., USA), based on the methodology described by Röijezon et al. [1, 2]. Although the original source code was not utilized, the algorithm and procedures were independently implemented using similar image processing techniques reported in previous studies [1, 2], and were executed with functions from the Image Processing Toolbox.

This repository contains supplementary resources for the paper: 
- Article Title: Immediate Effects of Upper Cervical Spinal Manipulation on Cervical Sensorimotor Control in Individuals with Chronic Primary Cervical Pain: An Exploratory Randomized Controlled Trial 
- Authors: Minwoo Lee & Yongwoo Lee
- Journal: Chiropractic & Manual Therapies
- DOI: 

Please refer to the published article for the full methodology, results, and discussion.
If you use this code in your research, please cite the above paper!

# Requirements
- MATLAB R2019b or later (developed and tested on MATLAB R2023a)
- Image Processing Toolbox

# File Structure
- `CMS_run.m`: Main execution script.
- `Step0_config.m`: Configuration settings.
- `Step1.m`: Extracting the Black Line and Detecting the Four Reference Corners in the Zigzag Pattern.
- `Step2.m`: Extracting the Laser Dot and Normalizing Its Size.
- `Step3.m`: Calculating and Preprocessing the Frame-by-Frame Pixel Distance from the Start Point.
- `Step4.m`: Visualizing the Pixel Distance and Manually Selecting the Start and End Frames of Laser Dot Movement.
- `Step5.m`: Determining Laser Dot Contact with the Black Line.
- `Step6.m`: Calculating the CMS Kinematic Variables.
- `Step7_laserdot_vis.m`: (Optional) Laser Dot Movement Visualization.

# Usage
1. Place your video file in the `videos/` folder.
2. Edit `Step0_config.m` to match your file and parameter settings.
3. Run `CMS_run.m`.
4. Follow the on-screen prompts.

# Output (CMS kinematic variables)
- Movement Accuracy (%) (MA)
- Movement Time (s) (MT) 
- Movement Speed (mm/s) (MS)
- Movement Accuracy-Time Ratio (MAT)

# Reference
1. Röijezon U, Jull G, Blandford C, Daniels A, Michaelson P, Karvelis P, et al. Proprioceptive disturbance in chronic neck pain: Discriminate validity and reliability of performance of the clinical cervical movement sense test. Front Pain Res (Lausanne). 2022;3:908414.
2. Röijezon U, Faleij R, Karvelis P, Georgoulas G, Nikolakopoulos G. A new clinical test for sensorimotor function of the hand–development and preliminary validation. BMC Musculoskelet Disord. 2017;18:1-11.


