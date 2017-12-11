%%% FDM

load('fixation_maps') % load the data
load('interest_maps')
load('head_maps')
load('saliency_maps')

fix_norm = cell(1,100);
int_norm = cell(1,100);
head_norm = cell(1,100);
sal_norm = cell(1,100);
 
% Only use the four categories which were shared among all maps
for i=1:100
    fix_norm{i} = (fixmaps{i}-mean(fixmaps{i}(:)))./std(fixmaps{i}(:));
    int_norm{i} = (intmaps{i}-mean(intmaps{i}(:)))./std(intmaps{i}(:));
    head_norm{i} = (headmaps{i}-mean(headmaps{i}(:)))./std(headmaps{i}(:));
    sal_norm{i} = (salmaps{i}-mean(salmaps{i}(:)))./std(salmaps{i}(:));
end
 
% fixation
cat1 = mean(cat(3,fix_norm{1:25}),3);
cat2 = mean(cat(3,fix_norm{26:50}),3);
cat3 = mean(cat(3,fix_norm{51:75}),3);
cat4 = mean(cat(3,fix_norm{76:100}),3);
 
cat_avg = (cat1+cat2+cat3+cat4)/4;
 
cat1_fix = cat1-cat_avg;
cat2_fix = cat2-cat_avg;
cat3_fix = cat3-cat_avg;
cat4_fix = cat4-cat_avg;

% interest
cat1 = mean(cat(3,int_norm{1:25}),3);
cat2 = mean(cat(3,int_norm{26:50}),3);
cat3 = mean(cat(3,int_norm{51:75}),3);
cat4 = mean(cat(3,int_norm{76:100}),3);
 
cat_avg = (cat1+cat2+cat3+cat4)/4;
 
cat1_int = cat1-cat_avg;
cat2_int = cat2-cat_avg;
cat3_int = cat3-cat_avg;
cat4_int = cat4-cat_avg;

% head
cat1 = mean(cat(3,head_norm{1:25}),3);
cat2 = mean(cat(3,head_norm{26:50}),3);
cat3 = mean(cat(3,head_norm{51:75}),3);
cat4 = mean(cat(3,head_norm{76:100}),3);
 
cat_avg = (cat1+cat2+cat3+cat4)/4;
 
cat1_head = cat1-cat_avg;
cat2_head = cat2-cat_avg;
cat3_head = cat3-cat_avg;
cat4_head = cat4-cat_avg;

% saliency
cat1 = mean(cat(3,sal_norm{1:25}),3);
cat2 = mean(cat(3,sal_norm{26:50}),3);
cat3 = mean(cat(3,sal_norm{51:75}),3);
cat4 = mean(cat(3,sal_norm{76:100}),3);
 
cat_avg = (cat1+cat2+cat3+cat4)/4;
 
cat1_sal = cat1-cat_avg;
cat2_sal = cat2-cat_avg;
cat3_sal = cat3-cat_avg;
cat4_sal = cat4-cat_avg;

%% Plot everything
figure
ha(1) = subplot(4,4,1);
imagesc(cat1_fix)
caxis([-1.25 1.25])
title('Buildings')
ylabel('Eye')
ha(2) = subplot(4,4,2);
imagesc(cat2_fix)
caxis([-1.25 1.25])
title('Fractals')
ha(3) = subplot(4,4,3);
imagesc(cat3_fix)
caxis([-1.25 1.25])
title('Home Interiors')
ha(4) = subplot(4,4,4);
imagesc(cat4_fix)
caxis([-1.25 1.25])
title('Landscapes')

ha(5) = subplot(4,4,5);
imagesc(cat1_int)
caxis([-1.25 1.25])
ylabel('Interest')
ha(6) = subplot(4,4,6);
imagesc(cat2_int)
caxis([-1.25 1.25])
ha(7) = subplot(4,4,7);
imagesc(cat3_int)
caxis([-1.25 1.25])
ha(8) = subplot(4,4,8);
imagesc(cat4_int)
caxis([-1.25 1.25])

ha(9) = subplot(4,4,9);
imagesc(cat1_head)
caxis([-1.25 1.25])
ylabel('Head')
ha(10) = subplot(4,4,10);
imagesc(cat2_head)
caxis([-1.25 1.25])
ha(11) = subplot(4,4,11);
imagesc(cat3_head)
caxis([-1.25 1.25])
ha(12) = subplot(4,4,12);
imagesc(cat4_head)
caxis([-1.25 1.25])

ha(13) = subplot(4,4,13);
imagesc(cat1_sal)
caxis([-0.75 0.75])
ylabel('Saliency')
ha(14) = subplot(4,4,14);
imagesc(cat2_sal)
caxis([-0.75 0.75])
ha(15) = subplot(4,4,15);
imagesc(cat3_sal)
caxis([-0.75 0.75])
ha(16) = subplot(4,4,16);
imagesc(cat4_sal)
caxis([-0.75 0.75])

set(ha(1:16),'XTickLabel','')
set(ha(1:16),'YTickLabel','')
set(ha(1:16),'XTick',[])
set(ha(1:16),'YTick',[])
set(gcf, 'Color', 'w');

tightfig