%% Step1. Extracting the Black Line and Detecting the Four Reference Corners in the Zigzag Pattern.
%% Load the initial frame for extracting the black line in the zigzag pattern.
cor_vidFrame = readFrame(vidObj);
cor_vidFrame = imresize(cor_vidFrame, resize_ratio);
cor_grayImage = im2gray(cor_vidFrame);
cor_binaryImage = imbinarize(cor_grayImage, zz_threshold);
% Optional: invert polarity if black line appears white instead of black after binarization
% cor_binaryImage = ~cor_binaryImage; 

imshowpair(cor_vidFrame, cor_binaryImage, 'blend');
hold on;

%% Extract pixel coordinates corresponding to the black line.
[y_black, x_black] = find(cor_binaryImage == 0);  % row = y, col = x

%% Initialize corner names and coordinate storage.
corner_names = {'upper_left', 'upper_right', 'lower_left', 'lower_right'};
corner_coords = zeros(4, 2);                     

%% Manually mark four reference corner points (approximately, as accurate as possible).
title('Click on the four reference corner points in order: (1) Upper left, (2) Upper right, (3) Lower left, (4) Lower right.');
[x_clicks, y_clicks] = ginput(4);

%% Automatic detection (via refinement) of corners based on manually marked points.
for i = 1:4
    x0 = x_clicks(i);
    y0 = y_clicks(i);

    % Define the coordinate range based on search_box_size
    x_min = round(x0 - search_box_size);
    x_max = round(x0 + search_box_size);
    y_min = round(y0 - search_box_size);
    y_max = round(y0 + search_box_size);

    % Extract black line pixel candidates located within the defined search region
    mask = x_black >= x_min & x_black <= x_max & ...
           y_black >= y_min & y_black <= y_max;

    x_candidates = x_black(mask);
    y_candidates = y_black(mask);

    % If no black line pixels are found near the clicked point, the process will be terminated 
    % Please restart and click more accurately
    if isempty(x_candidates)
        error('No black line pixels found near the clicked point for %s corner. Please restart and click more accurately.', corner_names{i});
    else
        % Automatically refine each reference corner based on positional constraints
        switch i
            case 1  % Upper left: minimum x and minimum y
                idx = find(x_candidates == min(x_candidates));
                [~, best_idx] = min(y_candidates(idx));
                x_upper_left = x_candidates(idx(best_idx));
                y_upper_left = y_candidates(idx(best_idx));

            case 2  % Upper right: maximum x and minimum y
                idx = find(x_candidates == max(x_candidates));
                [~, best_idx] = min(y_candidates(idx));
                x_upper_right = x_candidates(idx(best_idx));
                y_upper_right = y_candidates(idx(best_idx));

            case 3  % Lower left: minimum x and maximum y
                idx = find(x_candidates == min(x_candidates));
                [~, best_idx] = max(y_candidates(idx));
                x_lower_left = x_candidates(idx(best_idx));
                y_lower_left = y_candidates(idx(best_idx));

            case 4  % Lower right: maximum x and maximum y
                idx = find(x_candidates == max(x_candidates));
                [~, best_idx] = max(y_candidates(idx));
                x_lower_right = x_candidates(idx(best_idx));
                y_lower_right = y_candidates(idx(best_idx));
        end

        % Store and visualize the final corner coordinates
        final_x = x_candidates(idx(best_idx));
        final_y = y_candidates(idx(best_idx));
        corner_coords(i, :) = [final_x, final_y];
        plot(final_x, final_y, 'r.', 'MarkerSize', 10, 'LineWidth', 1);
    end
end

%% Automatic detection (via refinement) of the start point based on a manually marked point.
% Manually mark the start point for the laser dot
title('Click the start point of the laser dot (one of the four reference corners).');
[x_start_click, y_start_click] = ginput(1);

% Automatically assign the start point to the closest reference corner
distances = [
    sqrt((x_start_click - x_upper_left)^2 + (y_start_click - y_upper_left)^2);
    sqrt((x_start_click - x_upper_right)^2 + (y_start_click - y_upper_right)^2);
    sqrt((x_start_click - x_lower_left)^2 + (y_start_click - y_lower_left)^2);
    sqrt((x_start_click - x_lower_right)^2 + (y_start_click - y_lower_right)^2)
];

[~, closest_corner] = min(distances);

switch closest_corner
    case 1
        x_start = x_upper_left; y_start = y_upper_left;
    case 2
        x_start = x_upper_right; y_start = y_upper_right;
    case 3
        x_start = x_lower_left; y_start = y_lower_left;
    case 4
        x_start = x_lower_right; y_start = y_lower_right;
end

% Visualize the start point with a green circle
plot(x_start, y_start, 'go', 'MarkerSize', 10, 'LineWidth', 1);
hold off;

%% Calculate the scale factor. 
scale_factor = 234 / sqrt((x_upper_right - x_upper_left)^2 + (y_upper_right - y_upper_left)^2); % (mm/pixel)
