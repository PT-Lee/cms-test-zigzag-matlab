%% Step6. Calculating the CMS Kinematic Variables.
MovementTime = start_to_end_cnt / vidObj.FrameRate;
MovementSpeed = sum(all_distance, 'omitnan') * scale_factor / MovementTime;
MovementAccuracy = sum(contact_point == 1) / start_to_end_cnt * 100;
MovementAccuracyTimeRatio = MovementAccuracy / MovementTime;

MA = round(MovementAccuracy, 2);
MT = round(MovementTime, 2);
MS = round(MovementSpeed, 2);
MAT = round(MovementAccuracyTimeRatio, 2);

% Display the all results
All_results = table(MA, MT, MS, MAT);
disp(All_results)
