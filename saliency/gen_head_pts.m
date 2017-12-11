function head_points = gen_head_pts(results)

FM_by_time = true; %Weight fixation points by fixation duration

head_points = cell(125,1); % by image
imsize = [768 1024]; % for comparing with fixations/interest

for i = 1:length(results)
    for j = 1:length(results(i).cat)
        for k = 1:length(results(i).cat(j).image)
            
            fix = round(results(i).cat(j).image(k).fix_location*1.6); % for larger image size
            
            sel = fix(:,1)>=1 & fix(:,2)>=1 & fix(:,1)<=imsize(2) & fix(:,2)<=imsize(1); %select only valid fixations
            
            if FM_by_time
                fix_pts = accumarray([fix(sel,2) fix(sel,1)],results(i).cat(j).image(k).fix_duration(sel)/1000,imsize);
            else
                fix_pts = accumarray([fix(sel,2) fix(sel,1)],1,imsize);
            end
            
            % by image
            if isempty(head_points{results(i).cat(j).image(k).id+1})
                head_points{results(i).cat(j).image(k).id+1} = fix_pts; % store points
            else
                head_points{results(i).cat(j).image(k).id+1} = head_points{results(i).cat(j).image(k).id+1}+fix_pts; % store points
            end
            
        end
    end
end

save('head_pts','head_points')

end
