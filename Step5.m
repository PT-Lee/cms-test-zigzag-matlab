%% Step5. Determining Laser Dot Contact with the Black Line.
%% Preallocation for 'all_distance', 'contact_point', and 'd'.
idx = start_frame:end_frame;
start_to_end_cnt = numel(idx);
all_distance = zeros(start_to_end_cnt, 1);
contact_point = zeros(start_to_end_cnt, 1);
d = zeros(start_to_end_cnt, 4);

%% Determine contact between the laser dot and the black line.
analysis_frame = 0;
blackline_thickness_pixels = blackline_thickness_mm / scale_factor; 
for i = idx
    if ~isempty(stats{i,1})
        analysis_frame = analysis_frame + 1;

        % Inter-frame Euclidean-based pixel distance
        if i > idx(1) && ~isempty(stats{i-1,1})
            all_dis_coord = [stats{i-1,1}.Centroid(1), stats{i-1,1}.Centroid(2); stats{i,1}.Centroid(1), stats{i,1}.Centroid(2)]; 
            all_distance(analysis_frame) = pdist(all_dis_coord, 'euclidean');
        end

        % Pixel distances from the centroid of the laser dot to each of the four line segments
        d(analysis_frame,1) = GetPointSegmentDistance(stats{i,1}.Centroid(1), stats{i,1}.Centroid(2), x_upper_left,  y_upper_left, x_upper_right, y_upper_right);
        d(analysis_frame,2) = GetPointSegmentDistance(stats{i,1}.Centroid(1), stats{i,1}.Centroid(2), x_upper_left,  y_upper_left, x_lower_right, y_lower_right);
        d(analysis_frame,3) = GetPointSegmentDistance(stats{i,1}.Centroid(1), stats{i,1}.Centroid(2), x_lower_left,  y_lower_left, x_upper_right, y_upper_right);
        d(analysis_frame,4) = GetPointSegmentDistance(stats{i,1}.Centroid(1), stats{i,1}.Centroid(2), x_lower_left,  y_lower_left, x_lower_right, y_lower_right);

        % Determine contact by comparing the shortest of these distances
        % The shortest of these distances is less than or equal to the sum of the normalized_radius and half of the blackline_thickness_pixels
        if min(d(analysis_frame,:)) <= (normalized_radius + blackline_thickness_pixels / 2)
            contact_point(analysis_frame, 1) = 1; % In contact with the black line
        else
            contact_point(analysis_frame, 1) = 0; % Not in contact with the black line
        end
    end
end

%% Function to compute the shortest distance from a point to a line segment.
% Computes the shortest distance from a point (px, py) to a line segment defined by (x1, y1)–(x2, y2)
function distance = GetPointSegmentDistance(px, py, x1, y1, x2, y2)  
    
    % Length of the line segment
    segment_length = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    
    if segment_length == 0 % When the line segment is a single point
        distance = sqrt((px - x1)^2 + (py - y1)^2);
        return;
    end
    
    % Vector from the start point of the line segment to the point
    v1x = px - x1;
    v1y = py - y1;
    
    % Direction vector of the line segment
    v2x = x2 - x1;
    v2y = y2 - y1;
    
    % Projection factor of the point onto the line segment (clamped between 0 and 1)
    t = max(0, min(1, (v1x * v2x + v1y * v2y) / (segment_length^2)));
    
    % Closest point on the line segment to the point
    closest_x = x1 + t * v2x;
    closest_y = y1 + t * v2y;
    
    % Euclidean distance from the point to the closest point on the line segment
    distance = sqrt((px - closest_x)^2 + (py - closest_y)^2);
end
