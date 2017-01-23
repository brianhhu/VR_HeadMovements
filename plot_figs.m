% Script to reproduce the figures in the paper

% This assumes you have the results.mat file, if not, you can generate it with the post_process function
load('results.mat')

%% Figure 1: Plot head movement trajectory for a single subject overlaid on the original image (this just shows the first example
% from the "cityscapes" category).
subj = 1;
im_cat = 1;
im_id = 6;
image_name = 'image06.gif';
[im, cmap] = imread(['images/' image_name]);

figure;
imagesc(im)
colormap(cmap)
hold on
plot(results(subj).cat(im_cat).image(im_id).pos_interp(:,1),results(subj).cat(im_cat).image(im_id).pos_interp(:,2),'r','LineWidth',2) 
plot(results(subj).cat(im_cat).image(im_id).fix_location(:,1),results(subj).cat(im_cat).image(im_id).fix_location(:,2),'yo','MarkerSize',20,'LineWidth',2)
set(gcf,'Color','w')
set(gca,'XTick',[])
set(gca,'YTick',[])

%% Figure 2: Plot the main sequence relationships between movement duration and movement amplitude/movement peak velocity.
mvt_dur = [];
mvt_amp = [];
mvt_peak = [];

for i = 1:length(results)
    for j = 1:length(results(i).cat)
        
        mvt_temp = vertcat(results(i).cat(j).image.mvt_amplitude);
        peak_temp = vertcat(results(i).cat(j).image.mvt_peakvel);
        dur_temp = vertcat(results(i).cat(j).image.mvt_duration);
        fix_temp = vertcat(results(i).cat(j).image.fix_duration);
        
        mvt_amp = [mvt_amp; mvt_temp];
        mvt_peak = [mvt_peak; peak_temp];
        mvt_dur = [mvt_dur; dur_temp];
    end
end

p1 = polyfit(mvt_amp,mvt_dur,1);
p2 = polyfit(mvt_amp,mvt_peak,1);

figure;
scatter(mvt_amp,mvt_dur,'*');
yplot1 = polyval(p1,linspace(min(mvt_amp),max(mvt_amp),100));
hold on
ax1 = plot(linspace(min(mvt_amp),max(mvt_amp),100),yplot1,'r');
xlabel('Amplitude (deg)');
ylabel('Duration (ms)');
set(gcf,'Color','w')

figure;
scatter(mvt_amp,mvt_peak,'*');
yplot2 = polyval(p2,linspace(min(mvt_amp),max(mvt_amp),100));
hold on
ax2 = plot(linspace(min(mvt_amp),max(mvt_amp),100),yplot2,'r');
xlabel('Amplitude (deg)');
ylabel('Peak Angular Velocity (deg/s)');
set(gcf,'Color','w')

yfit1 = polyval(p1,mvt_amp);
yfit2 = polyval(p2,mvt_amp);

yresid1 = mvt_dur-yfit1;
yresid2 = mvt_peak-yfit2;

SSresid1 = sum(yresid1.^2);
SSresid2 = sum(yresid2.^2);

SStotal1 = (length(mvt_dur)-1) * var(mvt_dur);
SStotal2 = (length(mvt_peak)-1) * var(mvt_peak);

rsq1 = 1 - SSresid1/SStotal1;
rsq2 = 1 - SSresid2/SStotal2;

legend(ax1, sprintf('R^2 = %5.3f', rsq1))
legend(ax2, sprintf('R^2 = %5.3f', rsq2))

%% Figure 3: Generate head position angle and magnitude for head movements.
cat1_ang = [];
cat2_ang = [];
cat3_ang = [];
cat4_ang = [];
cat5_ang = [];

cat1_mag = [];
cat2_mag = [];
cat3_mag = [];
cat4_mag = [];
cat5_mag = [];

for i = 1:length(results)
    for j = 1:length(results(i).cat)
        
        ang_temp = vertcat(results(i).cat(j).image.mvt_angle);
        mag_temp = vertcat(results(i).cat(j).image.mvt_amplitude);
        
        if j==1
            cat1_ang = [cat1_ang; ang_temp];
            cat1_mag = [cat1_mag; mag_temp];
        elseif j==2
            cat2_ang = [cat2_ang; ang_temp];
            cat2_mag = [cat2_mag; mag_temp];
        elseif j==3
            cat3_ang = [cat3_ang; ang_temp];
            cat3_mag = [cat3_mag; mag_temp];
        elseif j==4
            cat4_ang = [cat4_ang; ang_temp];
            cat4_mag = [cat4_mag; mag_temp];
        else
            cat5_ang = [cat5_ang; ang_temp];
            cat5_mag = [cat5_mag; mag_temp];
        end
    end
end

% position angle histogram
figure;
t = 0 : .01 : 2 * pi;
P = polar(t, 0.25 * ones(size(t)));
set(P, 'Visible', 'off')
hold all;

[~, r] = rose(deg2rad(cat1_ang),0:pi/8:(2*pi-pi/8)); % default polar histogram
t = [pi/8:pi/8:2*pi pi/8]; % to loop around
r1 = [r(2:4:end) r(2)]/sum(r(2:4:end)); % normalize
polar(t,r1,'b');

[~, r] = rose(deg2rad(cat2_ang),0:pi/8:(2*pi-pi/8));
r2 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r2,'g');

[~, r] = rose(deg2rad(cat3_ang),0:pi/8:(2*pi-pi/8));
r3 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r3,'r');

[~, r] = rose(deg2rad(cat4_ang),0:pi/8:(2*pi-pi/8));
r4 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r4,'c');

[~, r] = rose(deg2rad(cat5_ang),0:pi/8:(2*pi-pi/8));
r5 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r5,'m');

set(gcf,'Color','w')

% head position magnitude histogram
figure;
x = [-inf 5:5:90 inf]; % 5 deg bins
n1 = histc(cat1_mag,x); % choose common bin centers
n2 = histc(cat2_mag,x);
n3 = histc(cat3_mag,x);
n4 = histc(cat4_mag,x);
n5 = histc(cat5_mag,x);
plot(x-2.5,n1/sum(n1),'b',x-2.5,n2/sum(n2),'g',x-2.5,n3/sum(n3),'r',x-2.5,n4/sum(n4),'c',x-2.5,n5/sum(n5),'m')

xlabel('Amplitude (deg)')
ylabel('Relative Frequency')
legend('Buildings','Fractals','Interiors-Old','Landscapes','Interiors-New')
set(gcf,'Color','w')
box off

%% Figure 4: Generate head velocity angle and magnitude for all movements.
cat1_ang = [];
cat2_ang = [];
cat3_ang = [];
cat4_ang = [];
cat5_ang = [];

cat1_mag = [];
cat2_mag = [];
cat3_mag = [];
cat4_mag = [];
cat5_mag = [];

for i = 1:length(results)
    for j = 1:length(results(i).cat)
        
        ang_temp = vertcat(results(i).cat(j).image.ang_vel_dir);
        mag_temp = vertcat(results(i).cat(j).image.ang_vel_mag);
        
        if j==1
            cat1_ang = [cat1_ang; ang_temp];
            cat1_mag = [cat1_mag; mag_temp];
        elseif j==2
            cat2_ang = [cat2_ang; ang_temp];
            cat2_mag = [cat2_mag; mag_temp];
        elseif j==3
            cat3_ang = [cat3_ang; ang_temp];
            cat3_mag = [cat3_mag; mag_temp];
        elseif j==4
            cat4_ang = [cat4_ang; ang_temp];
            cat4_mag = [cat4_mag; mag_temp];
        else
            cat5_ang = [cat5_ang; ang_temp];
            cat5_mag = [cat5_mag; mag_temp];
        end
    end
end

% head velocity angle histogram
figure;
t = 0 : .01 : 2 * pi;
P = polar(t, 0.25 * ones(size(t)));
set(P, 'Visible', 'off')
hold all;

[~, r] = rose(deg2rad(cat1_ang),0:pi/8:(2*pi-pi/8)); % default polar histogram
t = [pi/8:pi/8:2*pi pi/8]; % to loop around
r1 = [r(2:4:end) r(2)]/sum(r(2:4:end)); % normalize
polar(t,r1,'b');

[~, r] = rose(deg2rad(cat2_ang),0:pi/8:(2*pi-pi/8));
r2 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r2,'g');

[~, r] = rose(deg2rad(cat3_ang),0:pi/8:(2*pi-pi/8));
r3 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r3,'r');

[~, r] = rose(deg2rad(cat4_ang),0:pi/8:(2*pi-pi/8));
r4 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r4,'c');

[~, r] = rose(deg2rad(cat5_ang),0:pi/8:(2*pi-pi/8));
r5 = [r(2:4:end) r(2)]/sum(r(2:4:end));
polar(t,r5,'m');

set(gcf,'Color','w')

% head velocity magnitude histogram
figure;
x = [-inf 10:10:200 inf]; % 10 deg/s bins
n1 = histc(cat1_mag,x); % choose common bin centers
n2 = histc(cat2_mag,x);
n3 = histc(cat3_mag,x);
n4 = histc(cat4_mag,x);
n5 = histc(cat5_mag,x);
plot(x-5,n1/sum(n1),'b',x-5,n2/sum(n2),'g',x-5,n3/sum(n3),'r',x-5,n4/sum(n4),'c',x-5,n5/sum(n5),'m')

xlabel('Head Velocity (deg)')
ylabel('Relative Frequency')
ylim([0 0.25]) % set an upper limit so the figure looks better
legend('Buildings','Fractals','Interiors-Old','Landscapes','Interiors-New')
set(gcf,'Color','w')
box off