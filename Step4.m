%% Step4. Visualizing the Pixel Distance and Manually Selecting the Start and End Frames of Laser Dot Movement.
%% Plot the frame-by-frame pixel distance plot.
plot(1:1:size(pixel_distance, 1), pixel_distance);
hold on
title('Frame-by-Frame Pixel Distance Plot', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black');
xlabel('Frame Number', 'FontSize', 10, 'Color', 'black');
ylabel('Pixel Distance', 'FontSize', 10, 'Color', 'black');

%% Set the start and end frames based on the frame-by-frame pixel distance plot.
[x_distance_start, y_distance_start] = ginput(1);
[x_distance_end, y_distance_end] = ginput(1);
start_frame = round(x_distance_start);
end_frame = round(x_distance_end);

%% Mark the selected start and end frames on frame-by-frame pixel distance plot.
fprintf('# Start frame = %d, End frame = %d\n', start_frame, end_frame);
fprintf('\n');
plot(start_frame, pixel_distance(start_frame, 1), 'o', 'Color', 'r')
plot(end_frame, pixel_distance(end_frame, 1), 'o', 'Color', 'r')
hold off;
pause(1)
close
