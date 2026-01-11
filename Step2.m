%% Step2. Extracting the Laser Dot and Normalizing Its Size.
%% Preallocation for 'stats' and 'all_diameters'.
vidObj = VideoReader(video_path);
total_frames = vidObj.NumFrames; % Number of frames in the video
stats = cell(total_frames, 1);
all_diameters = NaN(total_frames, 1);

%% Load each frame for extracting the laser dot.
cnt0 = 1; % Frame counter
while hasFrame(vidObj)
    laserdot_vidFrame = readFrame(vidObj); 
    laserdot_vidFrame = imresize(laserdot_vidFrame,resize_ratio); 
    laserdot_grayImage = im2gray(laserdot_vidFrame(:,:,1)); % Use the corresponding color channel if laser dot was not red
    laserdot_binaryImage = imbinarize(laserdot_grayImage, laser_threshold);
    % Optional: invert polarity if laser dot appears black instead of white after binarization
    % laserdot_binaryImage = ~laserdot_binaryImage; 

    % Extract properties of the laser dot: centroid, major axis length, minor axis length, and area
    stats{cnt0,1} = regionprops("table", laserdot_binaryImage, "Centroid", ...
        "MajorAxisLength", "MinorAxisLength", "Area");

    % If multiple regions are detected, retain only the one with the largest area    
    if size(stats{cnt0,1},1) > 1
        [~, max_area_ind] = max(stats{cnt0,1}.Area(:,1));
        stats{cnt0,1} = stats{cnt0,1}(max_area_ind,:);
    end    

    % If a laser dot was detected in the current frame
    if ~isempty(stats{cnt0,1})
        diameters = mean([stats{cnt0,1}.MajorAxisLength, stats{cnt0,1}.MinorAxisLength], 2);
        all_diameters(cnt0,1) = diameters;
    else 
        all_diameters(cnt0,1) = NaN;
    end

    cnt0 = cnt0 + 1;
end

% Trim preallocated arrays to the actual number of processed frames
stats = stats(1:cnt0-1);
all_diameters = all_diameters(1:cnt0-1);

close all

%% Calculate normalized (mean used) diameter/radius across all frames.
% Count frames with missing diameter values (NaN)
nan_cnt = sum(isnan(all_diameters));
fprintf('# Number of NaN diameters (percentage): %d out of %d frames (%.2f%%) \n', nan_cnt, numel(all_diameters), nan_cnt/numel(all_diameters)*100);

% Check if more than 1% of the frames have no laser dot detected
if nan_cnt/numel(all_diameters)*100 > 1 
    warning('Laser dot not detected in more than 1%% of frames. Please check the video file and the settings for "laser_threshold".');
end

% Compute normalized diameter across frames (mean used; median can be used if many NaNs or outliers)
normalized_diameter = mean(all_diameters, 'omitnan');   
normalized_radius = normalized_diameter / 2;
fprintf('# Normalized diameter: %.2f pixels\n', normalized_diameter);
fprintf('# Normalized radius: %.2f pixels\n', normalized_radius);





