%% Step3. Calculating and Preprocessing the Frame-by-Frame Pixel Distance from the Start Point.
%% Calculate the Euclidean-based pixel distance between the laser dot and the start point.
pixel_distance = NaN(size(stats,1), 1); 
for i = 1 : size(stats,1)
    if ~isempty(stats{i,1})
        coord = [x_start, y_start; stats{i,1}.Centroid(1,1),stats{i,1}.Centroid(1,2)];
        pixel_distance(i,1) = pdist(coord,'euclidean');
    else
        pixel_distance(i,1) = NaN;
    end
end

%% Outlier detection and correction.
% Compute moving average (window size in frames)
moving_avg = movmean(pixel_distance, window_size, 'omitnan');

% Compute moving standard deviation (local variability)
local_std = movstd(pixel_distance, window_size, 'omitnan');
local_std = max(local_std, eps); % Prevent zero local_std (flat window) and avoid division by zero

% Identify outliers: deviation from moving average greater than (std_threshold × local_std)
outlier_indices = find(abs(pixel_distance - moving_avg) > std_threshold * local_std);

% Apply correction to outlier frames
for i = 1:numel(outlier_indices)
    idx = outlier_indices(i);
    if idx > 1 && idx < numel(pixel_distance)
        
        % Find previous valid index
        prev_idx = idx - 1;
        while prev_idx > 0 && (isnan(pixel_distance(prev_idx)) || ismember(prev_idx, outlier_indices))
            prev_idx = prev_idx - 1;
        end
        
        % Find next valid index
        next_idx = idx + 1;
        while next_idx <= numel(pixel_distance) && (isnan(pixel_distance(next_idx)) || ismember(next_idx, outlier_indices))
            next_idx = next_idx + 1;
        end
        
        % Apply simple average imputation (nearest neighbor prev_idx and next_idx)
        if prev_idx > 0 && next_idx <= numel(pixel_distance)
            pixel_distance(idx) = (pixel_distance(prev_idx) + pixel_distance(next_idx)) / 2;
        elseif prev_idx > 0
            pixel_distance(idx) = pixel_distance(prev_idx);
        elseif next_idx <= numel(pixel_distance)
            pixel_distance(idx) = pixel_distance(next_idx);
        else
            pixel_distance(idx) = moving_avg(idx);
        end
    end    
end


fprintf('# A total of %d outliers were detected and corrected.\n', numel(outlier_indices));



