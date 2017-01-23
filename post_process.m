% This function processes the raw head movement data and creates a .mat file storing the post-processed
% head movement data, separated by subject and image.

function post_process

addpath(genpath('data')) % add to MATLAB path folder with data

% find folders in the given dir (labeled by subject id, starting with 0)
D = dir('data');
folderNames = {D([D.isdir]).name};
folderNames(1:2) = []; % remove extraneous folder names (., ..)
numSubjects = length(folderNames); % find number of subjects

% experiment parameters
imageCategories = 5; % default for the experiment (1: cityscape, 2: fractal, 3: indoor_old, 4: natural, 5: indoor_new)
imagesShown = 14; % default for the experiment (13 original images/category + 1 repeat image/category)

% results structure: subjects -> image categories -> image id
results(numSubjects+1).cat(imageCategories).image(imagesShown) = struct(); % pre-allocate structure (add one more subject to avoid error)

% for storing results of initial tutorial calibration and initial starting position error
square_mat = zeros(numSubjects,9); % 9 calibration points
distance_mat = nan(numSubjects,70); % 70 images

for i = 1:numSubjects % loop through subjects
    
    %id is subject id, starting from 0
    D = dir(['data/',folderNames{i}]);
    numImages = length(D(not([D.isdir]))); % find number of images viewed by subject
    imgFiles = {D(~[D.isdir]).name};
    
    img_cnt = 1;
    
    for j = 1:numImages % loop through images
        
        % ignore certain files that do not pertain to the analysis
        if strcmp(imgFiles{j}, 'Done.csv') || strcmp(imgFiles{j}, 'imageList.txt') || strcmp(imgFiles{j}(end-3:end), '.WMA') % do nothing here
            
        elseif strcmp(imgFiles{j}, 'tutorial.csv')
            % The tutorial consisted of 9 "clicks" that the subject had to make on small red squares in a fixed grid
            temp_data = csvread(['data/',folderNames{i},'/',imgFiles{j}],2,0); % read in data from csv file (time, x, y, ...)
            square_data = [temp_data(temp_data(:,4)==1,2) temp_data(temp_data(:,4)==1,3)]; % find "clicks", which should match with the tutorial squares
            
            if length(find(temp_data(:,4)==1)) > 9 % should be 9 squares/clicks
                temp_dist = tril(squareform(pdist(square_data))); % remove any double-clicks close together in space
                [ind,~] = find(temp_dist < 100 & temp_dist > 0); % spacing between tutorial squares
                square_data(ind,:) = [];
            end
            
            % Find error tolerance for each tutorial square (bounds defined by visual inspection)
            square_mat(i,1) = sqrt(sum((square_data(square_data(:,1)>0 & square_data(:,1)<200 & square_data(:,2)>0 & square_data(:,2)<165,:)-[80 70]).^2));
            square_mat(i,2) = sqrt(sum((square_data(square_data(:,1)>200 & square_data(:,1)<440 & square_data(:,2)>0 & square_data(:,2)<165,:)-[320 70]).^2));
            square_mat(i,3) = sqrt(sum((square_data(square_data(:,1)>440 & square_data(:,1)<640 & square_data(:,2)>0 & square_data(:,2)<165,:)-[560 70]).^2));
            square_mat(i,4) = sqrt(sum((square_data(square_data(:,1)>0 & square_data(:,1)<200 & square_data(:,2)>165 & square_data(:,2)<355,:)-[80 260]).^2));
            square_mat(i,5) = sqrt(sum((square_data(square_data(:,1)>200 & square_data(:,1)<440 & square_data(:,2)>165 & square_data(:,2)<355,:)-[320 260]).^2));
            square_mat(i,6) = sqrt(sum((square_data(square_data(:,1)>440 & square_data(:,1)<640 & square_data(:,2)>165 & square_data(:,2)<355,:)-[560 260]).^2));
            square_mat(i,7) = sqrt(sum((square_data(square_data(:,1)>0 & square_data(:,1)<200 & square_data(:,2)>355 & square_data(:,2)<480,:)-[80 450]).^2));
            square_mat(i,8) = sqrt(sum((square_data(square_data(:,1)>200 & square_data(:,1)<440 & square_data(:,2)>355 & square_data(:,2)<480,:)-[320 450]).^2));
            square_mat(i,9) = sqrt(sum((square_data(square_data(:,1)>440 & square_data(:,1)<640 & square_data(:,2)>355 & square_data(:,2)<480,:)-[560 450]).^2));
            
        else
            image_id = str2double(imgFiles{j}(6:strfind(imgFiles{j},'data')-1)); % image number
            image_cat = floor(image_id/25)+1; % image category
            temp_data = csvread(['data/',folderNames{i},'/',imgFiles{j}],2,0); % read in data from csv file (time, x, y, ...)
            
            % find error in initial starting position, should be centered on image
            distance_mat(i,img_cnt) = sqrt(sum((temp_data(1,2:3)-[320 240]).^2));
            
            if isempty(find(temp_data(:,2) < 0, 1)) && isempty(find(temp_data(:,3) < 0, 1)) && max(temp_data(:,1)-temp_data(1,1)) > 9900 % Use only trials which stay within image region
                img_cnt = img_cnt+1; % only increment if valid, if not will be overwritten
                
                if isempty(strfind(imgFiles{j},'repeat'))
                    results(i).cat(image_cat).image(image_id-25*(image_cat-1)+2) = analyze_csv(temp_data,image_id,0); % post-process data
                else
                    results(i).cat(image_cat).image(1) = analyze_csv(temp_data,image_id,1); % post-process data
                end
            else
                disp('Discarded trial due to recorded position or data collection error.')
            end
        end
        
    end
    
    % clean up the structure by removing empty structure elements
    for category = 1:imageCategories
        empty_elems = arrayfun(@(s) all(structfun(@isempty,s)), results(i).cat(category).image);
        results(i).cat(category).image(empty_elems) = [];
    end
end

% Calculate mean error on head tracking position for tutorial and experiments
tut_error = mean(mean(square_mat)); % error for clicking within tutorial squares (calibration)
img_error = mean((nanmean(distance_mat,2))); % error for starting distance from initial fixation point

fprintf('\n\n')
disp(['The total error on the tutorial calibration was ' num2str(tut_error) ' pixels.'])
disp(['The total error on initial starting position was ' num2str(img_error) ' pixels.'])

results(numSubjects+1) = []; % remove extra added subject number to do the analysis

% results.mat has the following structure: results(numSubjects).cat(numCategories).image(numImagesViewed)

% Ex. To get the associated data for the sixth subject viewing the second image category ("fractals"),
% and the fifth image they viewed, use the following: results(6).cat(2).image(5)

% save the output to a .mat file
save('results','results')

end
