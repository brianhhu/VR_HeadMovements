load('results')

% pool all mvt_duration, mvt_amplitude, mvt_velocity
image_struct(125) = struct('fix_dur',[],'fix_freq',[],'sacc_freq',[],'sacc_len',[]); % group by image

for i = 1:length(results)
    for j = 1:length(results(i).cat)
         for k = 1:length(results(i).cat(j).image)
%              group by image
             image_struct(results(i).cat(j).image(k).id+1).fix_dur = [image_struct(results(i).cat(j).image(k).id+1).fix_dur; results(i).cat(j).image(k).fix_duration];
             image_struct(results(i).cat(j).image(k).id+1).fix_freq = [image_struct(results(i).cat(j).image(k).id+1).fix_freq; length(results(i).cat(j).image(k).fix_duration)];
             image_struct(results(i).cat(j).image(k).id+1).sacc_freq = [image_struct(results(i).cat(j).image(k).id+1).sacc_freq; length(results(i).cat(j).image(k).mvt_duration)];
             image_struct(results(i).cat(j).image(k).id+1).sacc_len = [image_struct(results(i).cat(j).image(k).id+1).sacc_len; results(i).cat(j).image(k).mvt_amplitude];
         end
    end
end

image_struct_avg(125) = struct('fix_dur',[],'fix_freq',[],'sacc_freq',[],'sacc_len',[]); % by image

for i=1:length(image_struct)
    
%   by image (average)
    image_struct_avg(i).fix_dur = mean(image_struct(i).fix_dur);
    image_struct_avg(i).fix_freq = mean(image_struct(i).fix_freq);
    image_struct_avg(i).sacc_freq = mean(image_struct(i).sacc_freq);
    image_struct_avg(i).sacc_len = mean(image_struct(i).sacc_len);    
    
end

%by image

% head fixation duration
y_fix_dur(:,1) = vertcat(image_struct_avg(1:25).fix_dur);
y_fix_dur(:,2) = vertcat(image_struct_avg(26:50).fix_dur);
y_fix_dur(:,3) = vertcat(image_struct_avg(51:75).fix_dur);
y_fix_dur(:,4) = vertcat(image_struct_avg(76:100).fix_dur);
y_fix_dur(:,5) = vertcat(image_struct_avg(101:125).fix_dur);
[~,~,stats_fix_dur] = anova1(y_fix_dur);

[c_fix_dur,~,~,gnames] = multcompare(stats_fix_dur,'ctype','bonferroni'); % example comparison

% number of head fixations
y_fix_freq(:,1) = vertcat(image_struct_avg(1:25).fix_freq);
y_fix_freq(:,2) = vertcat(image_struct_avg(26:50).fix_freq);
y_fix_freq(:,3) = vertcat(image_struct_avg(51:75).fix_freq);
y_fix_freq(:,4) = vertcat(image_struct_avg(76:100).fix_freq);
y_fix_freq(:,5) = vertcat(image_struct_avg(101:125).fix_freq);
[~,~,stats_fix_freq] = anova1(y_fix_freq);

[c_fix_freq,~,~,~] = multcompare(stats_fix_freq,'ctype','bonferroni'); % example comparison

% number of head movements
y_sacc_freq(:,1) = vertcat(image_struct_avg(1:25).sacc_freq);
y_sacc_freq(:,2) = vertcat(image_struct_avg(26:50).sacc_freq);
y_sacc_freq(:,3) = vertcat(image_struct_avg(51:75).sacc_freq);
y_sacc_freq(:,4) = vertcat(image_struct_avg(76:100).sacc_freq);
y_sacc_freq(:,5) = vertcat(image_struct_avg(101:125).sacc_freq);
[~,~,stats_sacc_freq] = anova1(y_sacc_freq);

[c_sacc_freq,~,~,~] = multcompare(stats_sacc_freq,'ctype','bonferroni'); % example comparison

% amplitude of head movements
y_sacc_len(:,1) = vertcat(image_struct_avg(1:25).sacc_len);
y_sacc_len(:,2) = vertcat(image_struct_avg(26:50).sacc_len);
y_sacc_len(:,3) = vertcat(image_struct_avg(51:75).sacc_len);
y_sacc_len(:,4) = vertcat(image_struct_avg(76:100).sacc_len);
y_sacc_len(:,5) = vertcat(image_struct_avg(101:125).sacc_len);
[~,~,stats_sacc_len] = anova1(y_sacc_len);

[c_sacc_len,~,~,gnames] = multcompare(stats_sacc_len,'ctype','bonferroni'); % example comparison

% Example plot
bar([1 2 3 4 5],mean(y_sacc_len))
hold on
errorbar([1 2 3 4 5],mean(y_sacc_len),std(y_sacc_len)/sqrt(25),'r.')
set(gca,'XTickLabel',{'B','F','I-old','L','I-new'})
ylabel('Saccade Length (deg)')




