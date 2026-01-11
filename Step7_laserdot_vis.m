%% Step7. (Optional) Laser Dot Movement Visualization.
vidObj = VideoReader(video_path);

set(gcf, 'KeyPressFcn', @keyPressCallback);
global is_paused;
is_paused = false;

cnt = 1;
while hasFrame(vidObj)
    laserdot_vidFrame = readFrame(vidObj);
    laserdot_vidFrame = imresize(laserdot_vidFrame, resize_ratio);
    laserdot_grayImage = im2gray(laserdot_vidFrame(:,:,1));
    laserdot_binaryImage = imbinarize(laserdot_grayImage, laser_threshold);

    if cnt <= size(stats,1) && ~isempty(stats{cnt,1})
        centers = stats{cnt,1}.Centroid;
        
        if ~isempty(centers)
            imshowpair(laserdot_vidFrame, laserdot_binaryImage, 'blend');
            hold on;
            
            theta = 0:0.01:2*pi;
            x_circle = centers(1) + normalized_radius * cos(theta);
            y_circle = centers(2) + normalized_radius * sin(theta);
            plot(x_circle, y_circle, 'r-', 'LineWidth', 2);
            plot(centers(1), centers(2), 'black.', 'MarkerSize', 2);
            hold off;

            if is_paused
                title(sprintf('Frame %d - PAUSED! Press SPACE to continue', cnt));
            else
                title(sprintf('Frame %d - Press SPACE to pause', cnt));
            end
            fprintf('Frame %d: Centroid (%.1f, %.1f)\n', cnt, centers(1), centers(2));
        end
    end
    
    if is_paused
        while is_paused
            pause(0.001); 
        end
    else
        pause(0);
    end
    
    cnt = cnt + 1;
end
close all

function keyPressCallback(src, event)
    global is_paused;
    if strcmp(event.Key, 'space')
        is_paused = ~is_paused; 
        fprintf('Pause: %s\n', mat2str(is_paused));
    end
end