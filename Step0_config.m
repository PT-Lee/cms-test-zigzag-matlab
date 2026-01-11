%% Configuration Settings.
close all
clear

%% Set folder name and video file name separately.
folder_name = 'videos';
video_name = 'example.mp4';

%% Full path to the video file.
video_path = fullfile(folder_name, video_name);

%% Load the video file.
vidObj = VideoReader(video_path);

%% Resize ratio for video file (1 = original resolution).
resize_ratio = 1; 

%% Threshold for extracting the black line in the zigzag pattern.
zz_threshold = 0.25; 

%% Threshold for extracting the laser dot.
laser_threshold = 0.9;  

%% Search range (in pixels) around manually marked corners.
search_box_size = 100; 

%% Black line thickness in mm.
blackline_thickness_mm = 1; % (default = 1 mm)

%% Outlier detection parameters.
window_size = 15;  % window size for moving average
std_threshold = 2;  % threshold in standard deviations (SD) from the moving average
