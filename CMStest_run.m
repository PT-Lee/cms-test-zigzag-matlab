%% Customized Algorithm for Video Analysis in MATLAB.
%% Cervical Movement Sense (CMS) Test in the Zigzag Pattern

%% Run the scripts.
% Configuration Settings.
run('Step0_config.m')

% Step1. Extracting the Black Line and Detecting the Four Reference Corners in the Zigzag Pattern.
run('Step1.m') 

% Step2. Extracting the Laser Dot and Normalizing Its Size.
run('Step2.m') 

% Step3. Calculating and Preprocessing the Frame-by-Frame Pixel Distance from the Start Point.
run('Step3.m') 

% Step4. Visualizing the Pixel Distance and Manually Selecting the Start and End Frames of Laser Dot Movement.
run('Step4.m') 

% Step5. Determining Laser Dot Contact with the Black Line.
run('Step5.m') 

% Step6. Calculating the CMS Kinematic Variables.
run('Step6.m') 

% Step7. (Optional) Laser Dot Movement Visualization. % If you want to visualize the laser dot movement, run this script.
% run('Step7_laserdot_vis.m') 
