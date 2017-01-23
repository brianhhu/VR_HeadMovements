% This function takes input data in the form of a csv file and performs post-processing
% on the data to compute position/velocity information.

function results = analyze_csv(csv_data,image_id,repeat)
%csv file format:
%    Timestamp(ms), viewScreenCenter x_pos(px), viewScreenCenter y_pos(px),
%    sphericalCoord x_angle, sphericalCoord y_angle

results.id = image_id; % book keeping for image id and whether or not image was repeat image
results.repeat = repeat;

% extract out time and position data
x_pos = csv_data(:,2);
y_pos = csv_data(:,3);
time = csv_data(:,1)-csv_data(1,1);

% remove values that are "out-of-bounds" (i.e. -1)
x_pos_new = x_pos;
y_pos_new = y_pos;

x_pos_new(x_pos < 0 | y_pos < 0) = NaN;
y_pos_new(x_pos < 0 | y_pos < 0) = NaN;

% for mapping onto time vector
time_new = 0:20:min(floor(max(time)),10000);

% interpolate position values between 0 and 10 sec. (50 Hz sampling, 20 ms increments)
results.pos_interp = interp1(time,[x_pos_new y_pos_new],time_new); % position data (time in ms)

% angle data
results.ang_interp = radtodeg(atan((results.pos_interp-repmat([320 240],length(results.pos_interp),1))./(1/.005)));
results.ang_interp(:,2) = -1*results.ang_interp(:,2); % flip y-axis

% create derivative of Gaussian filter for computing velocity
sigma = 5;
k = 3; % size of kernel support (one tail)
gauss = fspecial('gauss',[2*k*sigma+1 1],sigma);
gx = gradient(gauss); % for velocity

% subtract out mean to get zero-mean filter
gx = gx - mean(gx);

% angle velocity data (deg/sec)
results.ang_vel_interp(:,1) = 50*imfilter(results.ang_interp(:,1),gx,'replicate','conv');
results.ang_vel_interp(:,2) = 50*imfilter(results.ang_interp(:,2),gx,'replicate','conv');

% Compute magnitude and direction of velocity trace
results.ang_vel_mag = sqrt(sum(results.ang_vel_interp.^2,2));
results.ang_vel_dir = radtodeg(mod(atan2(results.ang_vel_interp(:,2),results.ang_vel_interp(:,1))+2*pi,2*pi));

% Find fixations vs. movements using a velocity threshold (from 2015 paper)
vel_thresh = 25; % deg/s

% For storing movement and fixation data
movements = [0; (results.ang_vel_mag>vel_thresh); 0];
fixations = [0; (results.ang_vel_mag<=vel_thresh); 0];

% Make sure there are no one sample movements/fixations
movements(abs(diff(diff([0; fixations])))==2) = 1;
fixations(abs(diff(diff([0; fixations])))==2) = 0;

fixations(abs(diff(diff([0; movements])))==2) = 1;
movements(abs(diff(diff([0; movements])))==2) = 0;

% Find onset of movements
time_onset = find(diff(movements)==1);
time_offset = find(diff(movements)==-1)-1;

% Find onset of fixations
time_onset_fix = find(diff(fixations)==1);
time_offset_fix = find(diff(fixations)==-1)-1;

if isempty(time_onset)
    
    % We look at the following metrics: movement duration, movement amplitude, movement peak velocity,
    % movement angle, fixation duration, and fixation location
    % NOTE: Movements and "fixations" were defined by using a velocity threshold of 25 deg/s
    results.mvt_duration = []; % duration of head movement (time_offset-time_onset)
    results.mvt_amplitude = []; % amplitude of head movement (based on head position at end points of movement)
    results.mvt_peakvel = []; % peak velocity during head movement
    results.mvt_angle = []; % angle of head movement (based on head position at end points of movement)
    results.fix_duration = time_new(end); % duration of head "fixation" (time_offset_fix-time_onset_fix)
    results.fix_location = mean(results.pos_interp); % X/Y coordinates (in pixels) of head "fixations"
    
else
    
    % Compute and store the various metrics for each image here
    results.mvt_duration = (time_new(time_offset)-time_new(time_onset))';
    diff_pos = results.ang_interp(time_offset,:)-results.ang_interp(time_onset,:);
    
    results.mvt_amplitude = sqrt(sum(diff_pos.^2,2));
    for i=1:length(time_onset)
        results.mvt_peakvel(i,1) = max(results.ang_vel_mag(time_onset(i):time_offset(i)));
    end
    results.mvt_angle = radtodeg(mod(atan2(diff_pos(:,2),diff_pos(:,1))+2*pi,2*pi));
    
    results.fix_duration = (time_new(time_offset_fix)-time_new(time_onset_fix))';
    
    results.fix_location = zeros(length(results.fix_duration),2);
    for i = 1:length(results.fix_duration)
        results.fix_location(i,:) = mean(results.pos_interp(time_onset_fix(i):time_offset_fix(i),:));
    end
    
end

end