function map_correlation(binsize,filtflag,sig,firstInterestPoint)
% Find the correlations between different types of maps

%% Parameters
if nargin==0
    binsize = 64; %must be a factor of both dimensions of the images (power of 2)
    filtflag = false;
    sig = 27;
    firstInterestPoint = true;
end

%% load data
load('saliency_maps.mat');
load('fixation_pts.mat');
load('interest_pts.mat');
load('head_pts.mat');

%% select appropriate natural scenes
%% use all images (bh)
interest_maps = interest_maps_points;
fixmaps = fixmaps_points;
head_points = head_points([1:100]);
salmaps = salmaps([1:100]);


%% Upper bound analysis params
Nresamp=1000; %number of times to resample the appropriate map

Npoints_int = zeros(size(fixmaps));
Npoints_fix = zeros(size(fixmaps));
Npoints_head = zeros(size(fixmaps));

for pic= 1:length(fixmaps)
    Npoints_fix(pic) = length(fix_points_x{pic});
    Npoints_int(pic) = length(all_x_points_int{pic});
    Npoints_head(pic) = length(find(head_points{pic}>0));
end

for pic = 1:length(fixmaps)
    fixmaps{pic} = downsize_map(fixmaps{pic},binsize);
    interest_maps{pic} = downsize_map(interest_maps{pic},binsize);
    salmaps{pic} = downsize_map(salmaps{pic},binsize);
    head_points{pic} = downsize_map(head_points{pic},binsize); % added bh
end

%% Compute True correlations

R_true = zeros(4,4,length(fixmaps));
for pic = 1:length(fixmaps)
    fix = fixmaps{pic}(:);
    int = interest_maps{pic}(:);
    sal = salmaps{pic}(:);
    head = head_points{pic}(:);
    R_true(:,:,pic) = corrcoef([fix int head sal]); % added bh
end

Rfixint = squeeze(R_true(1,2,:));
Rfixhead = squeeze(R_true(1,3,:)); % added bh
Rinthead = squeeze(R_true(2,3,:)); % added bh
Rheadsal = squeeze(R_true(3,4,:)); % added bh
Rfixsal = squeeze(R_true(1,4,:));
Rintsal = squeeze(R_true(2,4,:));

save('corr_true','R_true','Rfixint','Rfixhead','Rinthead','Rheadsal','Rfixsal','Rintsal');

Ravg = mean(R_true,3);

%% Compute correlations from mismatched images
Rfixint_rand = zeros(length(fixmaps),length(fixmaps));
Rfixhead_rand = zeros(length(fixmaps),length(fixmaps));
Rinthead_rand = zeros(length(fixmaps),length(fixmaps));
Rfixsal_rand = zeros(length(fixmaps),length(fixmaps));
Rheadsal_rand = zeros(length(fixmaps),length(fixmaps));
Rintsal_rand = zeros(length(fixmaps),length(fixmaps));

for pic1 = 1:length(fixmaps)
    for pic2 = 1:length(fixmaps)
        fix = fixmaps{pic1}(:);
        int = interest_maps{pic2}(:);
        R = corrcoef(fix,int);
        Rfixint_rand(pic1,pic2) = R(1,2);
        
        fix = fixmaps{pic1}(:);
        head = head_points{pic2}(:); % added bh
        R = corrcoef(fix,head);
        Rfixhead_rand(pic1,pic2) = R(1,2);
        
        int = interest_maps{pic1}(:);
        head = head_points{pic2}(:); % added bh
        R = corrcoef(int,head);
        Rinthead_rand(pic1,pic2) = R(1,2);
        
        head = head_points{pic1}(:); % added bh
        sal = salmaps{pic2}(:);
        R = corrcoef(head, sal);
        Rheadsal_rand(pic1,pic2) = R(1,2);
        
        fix = fixmaps{pic1}(:);
        sal = salmaps{pic2}(:);
        R = corrcoef(fix,sal);
        Rfixsal_rand(pic1,pic2) = R(1,2);
        
        int = interest_maps{pic1}(:);
        sal = salmaps{pic2}(:);
        R = corrcoef(int,sal);
        Rintsal_rand(pic1,pic2) = R(1,2);
    end
end

save('corr_rand','Rfixint_rand','Rfixhead_rand','Rinthead_rand','Rheadsal_rand', 'Rfixsal_rand', 'Rintsal_rand');

%% Generate sample error hypothesis correllation between interest and fixation by resampling from interest maps

R_samp_err_intfix = R_samp_err(interest_maps,interest_maps,Npoints_fix,Nresamp,sig,filtflag);
save('R_samp_err_intfix','R_samp_err_intfix');


%% Generate sample error hypothesis correllation between head and fixations by resampling from fixation maps

R_samp_err_fixhead = R_samp_err(fixmaps,fixmaps,Npoints_head,Nresamp,sig,filtflag);
save('R_samp_err_fixhead','R_samp_err_fixhead');


%% Generate sample error hypothesis correllation between interest and head by resampling from interest maps

R_samp_err_inthead = R_samp_err(interest_maps,interest_maps,Npoints_head,Nresamp,sig,filtflag);
save('R_samp_err_inthead','R_samp_err_inthead');

%% Correllate Interest and Fixation maps using only N head movements of interest points

R_intNheads_fix = R_samp_err(interest_maps,fixmaps,Npoints_head,Nresamp,sig,filtflag);
save('R_intNheads_fix2','R_intNheads_fix');

%% Generate sample error hypothesis correlation between head and computed salience by resampling from saliency maps

R_samp_err_headsal = R_samp_err(salmaps,salmaps,Npoints_head,Nresamp,sig,filtflag);
save('R_samp_err_headsal','R_samp_err_headsal');

%% Generate sample error hypothesis correlation between fixations and computed salience by resampling from saliency maps

R_samp_err_fixsal = R_samp_err(salmaps,salmaps,Npoints_fix,Nresamp,sig,filtflag);
save('R_samp_err_fixsal','R_samp_err_fixsal');

%% Generate sample error hypothesis correlation between interest and computed salience by resampling from saliency maps

R_samp_err_intsal = R_samp_err(salmaps,salmaps,Npoints_int,Nresamp,sig,filtflag);
save('R_samp_err_intsal','R_samp_err_intsal');