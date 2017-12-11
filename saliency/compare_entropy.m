%%%% Entropy Script %%%%

%% Convert heat maps into probability distributions
load('fixation_maps') % load the data
load('interest_maps')
load('head_maps')

a = zeros(768,1024); % for calculating uniform distribution (same size as input maps)
f_map = cell(1,100);
i_map = cell(1,100);
h_map = cell(1,125); % more rows for new home interiors

for i=1:125
    if i<=100
        % fixation
        map_norm = (fixmaps{i} + 0.0001) ./ (sum(sum(fixmaps{i}+0.0001))); % create pdf (change)
        temp = map_norm.*log(map_norm);
        temp(isnan(temp))=0; % resolving the case when P(i)==0
        temp(isinf(temp))=0;
        f_map{i} = -1 .* sum(sum(temp)) ./ log(length(a(:))); %change for different maps
        
        % interest
        map_norm = (intmaps{i} + 0.0001) ./ (sum(sum(intmaps{i}+0.0001))); % create pdf (change)
        temp = map_norm.*log(map_norm);
        temp(isnan(temp))=0; % resolving the case when P(i)==0
        temp(isinf(temp))=0;
        i_map{i} = -1 .* sum(sum(temp)) ./ log(length(a(:))); %change for different maps
        
        % head
        map_norm = (headmaps{i} + 0.0001) ./ (sum(sum(headmaps{i}+0.0001))); % create pdf (change)
        temp = map_norm.*log(map_norm);
        temp(isnan(temp))=0; % resolving the case when P(i)==0
        temp(isinf(temp))=0;
        h_map{i} = -1 .* sum(sum(temp)) ./ log(length(a(:))); %change for different maps
    else
        % head only
        map_norm = (headmaps{i} + 0.0001) ./ (sum(sum(headmaps{i}+0.0001))); % create pdf (change)
        temp = map_norm.*log(map_norm);
        temp(isnan(temp))=0; % resolving the case when P(i)==0
        temp(isinf(temp))=0;
        h_map{i} = -1 .* sum(sum(temp)) ./ log(length(a(:))); %change for different maps
    end
end

%% Calculate entropy

% fixation
cat1 = mean(cat(3,fixmaps{1:25}),3);
cat1_f = (cat1 + 0.0001) ./ (sum(sum(cat1+0.0001))); % create pdf
temp = cat1_f.*log(cat1_f);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
f_cat1 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat2 = mean(cat(3,fixmaps{26:50}),3);
cat2_f = (cat2 + 0.0001) ./ (sum(sum(cat2+0.0001))); % create pdf
temp = cat2_f.*log(cat2_f);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
f_cat2 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat3 = mean(cat(3,fixmaps{51:75}),3);
cat3_f = (cat3 + 0.0001) ./ (sum(sum(cat3+0.0001))); % create pdf
temp = cat3_f.*log(cat3_f);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
f_cat3 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat4 = mean(cat(3,fixmaps{76:100}),3);
cat4_f = (cat4 + 0.0001) ./ (sum(sum(cat4+0.0001))); % create pdf
temp = cat4_f.*log(cat4_f);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
f_cat4 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

% interest
cat1 = mean(cat(3,intmaps{1:25}),3);
cat1_i = (cat1 + 0.0001) ./ (sum(sum(cat1+0.0001))); % create pdf
temp = cat1_i.*log(cat1_i);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
i_cat1 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat2 = mean(cat(3,intmaps{26:50}),3);
cat2_i = (cat2 + 0.0001) ./ (sum(sum(cat2+0.0001))); % create pdf
temp = cat2_i.*log(cat2_i);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
i_cat2 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat3 = mean(cat(3,intmaps{51:75}),3);
cat3_i = (cat3 + 0.0001) ./ (sum(sum(cat3+0.0001))); % create pdf
temp = cat3_i.*log(cat3_i);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
i_cat3 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat4 = mean(cat(3,intmaps{76:100}),3);
cat4_i = (cat4 + 0.0001) ./ (sum(sum(cat4+0.0001))); % create pdf
temp = cat4_i.*log(cat4_i);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
i_cat4 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

% head
cat1 = mean(cat(3,headmaps{1:25}),3);
cat1_h = (cat1 + 0.0001) ./ (sum(sum(cat1+0.0001))); % create pdf
temp = cat1_h.*log(cat1_h);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
h_cat1 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat2 = mean(cat(3,headmaps{26:50}),3);
cat2_h = (cat2 + 0.0001) ./ (sum(sum(cat2+0.0001))); % create pdf
temp = cat2_h.*log(cat2_h);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
h_cat2 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat3 = mean(cat(3,headmaps{51:75}),3);
cat3_h = (cat3 + 0.0001) ./ (sum(sum(cat3+0.0001))); % create pdf
temp = cat3_h.*log(cat3_h);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
h_cat3 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat4 = mean(cat(3,headmaps{76:100}),3);
cat4_h = (cat4 + 0.0001) ./ (sum(sum(cat4+0.0001))); % create pdf
temp = cat4_h.*log(cat4_h);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
h_cat4 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

cat5 = mean(cat(3,headmaps{101:125}),3);
cat5_h = (cat5 + 0.0001) ./ (sum(sum(cat5+0.0001))); % create pdf
temp = cat5_h.*log(cat5_h);
temp(isnan(temp))=0; % resolving the case when P(i)==0
temp(isinf(temp))=0;
h_cat5 = -1 .* sum(sum(temp)) ./ log(length(a(:)));

%% Plot results

% fixation
plot([1 2 3 4],[f_cat1 f_cat2 f_cat4 f_cat3], 'r--','MarkerSize',20)
hold on
errorbar([1 2 3 4],[mean(cat(3,f_map{1:25})) mean(cat(3,f_map{26:50})) mean(cat(3,f_map{76:100})) mean(cat(3,f_map{51:75}))],[std(cat(3,f_map{1:25}))/sqrt(25) std(cat(3,f_map{26:50}))/sqrt(25) std(cat(3,f_map{76:100}))/sqrt(25) std(cat(3,f_map{51:75}))/sqrt(25)],'r')

% interest
plot([1 2 3 4],[i_cat1 i_cat2 i_cat4 i_cat3], 'g--','MarkerSize',20)
errorbar([1 2 3 4],[mean(cat(3,i_map{1:25})) mean(cat(3,i_map{26:50})) mean(cat(3,i_map{76:100})) mean(cat(3,i_map{51:75}))],[std(cat(3,i_map{1:25}))/sqrt(25) std(cat(3,i_map{26:50}))/sqrt(25) std(cat(3,i_map{76:100}))/sqrt(25) std(cat(3,i_map{51:75}))/sqrt(25)],'g')

% head
plot([1 2 3 4 5],[h_cat1 h_cat2 h_cat4 h_cat3 h_cat5], 'b--','MarkerSize',20)
errorbar([1 2 3 4 5],[mean(cat(3,h_map{1:25})) mean(cat(3,h_map{26:50})) mean(cat(3,h_map{76:100})) mean(cat(3,h_map{51:75})) mean(cat(3,h_map{101:125}))],[std(cat(3,h_map{1:25}))/sqrt(25) std(cat(3,h_map{26:50}))/sqrt(25) std(cat(3,h_map{76:100}))/sqrt(25) std(cat(3,h_map{51:75}))/sqrt(25) std(cat(3,h_map{101:125}))/sqrt(25)],'b')

% Plot points after
plot([1 2 3 4],[f_cat1 f_cat2 f_cat4 f_cat3], 'r.','MarkerSize',20)
plot([1 2 3 4],[i_cat1 i_cat2 i_cat4 i_cat3], 'g.','MarkerSize',20)
plot([1 2 3 4 5],[h_cat1 h_cat2 h_cat4 h_cat3 h_cat5], 'b.','MarkerSize',20)

% Overall legend
legend('fix-category','fix-image','int-category','int-image','head-category','head-image')
set(gca,'XTick',[0,1,2,3,4,5,6])
set(gca,'XTickLabel',{'','B','F','L','I-old','I-new',''})
xlabel('Category')
ylabel('Normalized Entropy')

%% Test 2-way ANOVA differences

% 25 measurements per category
[~,tbl,stats] = anova2([cell2mat(f_map') cell2mat(i_map') cell2mat(h_map(1:100)')], 25);

% Post-hoc differences in map type (fixation, interest, head)
stats_cols = multcompare(stats,'ctype','bonferroni');

% Post-hoc differences in category type (buildings, fractals, interiors, landscapes)
stats_rows = multcompare(stats,'Estimate','row','ctype','bonferroni');

% UNUSED
% f_ent(:,1) = vertcat(f_map(1:25));
% f_ent(:,2) = vertcat(f_map(26:50));
% f_ent(:,3) = vertcat(f_map(51:75));
% f_ent(:,4) = vertcat(f_map(76:100));
% [~,~,stats_f] = anova1(cell2mat(f_ent));
% [c_f,~,~,gnames_f] = multcompare(stats_f,'ctype','bonferroni'); % example comparison
% 
% i_ent(:,1) = vertcat(i_map(1:25));
% i_ent(:,2) = vertcat(i_map(26:50));
% i_ent(:,3) = vertcat(i_map(51:75));
% i_ent(:,4) = vertcat(i_map(76:100));
% [~,~,stats_i] = anova1(cell2mat(i_ent));
% [c_i,~,~,gnames_i] = multcompare(stats_i,'ctype','bonferroni'); % example comparison
% 
% h_ent(:,1) = vertcat(h_map(1:25));
% h_ent(:,2) = vertcat(h_map(26:50));
% h_ent(:,3) = vertcat(h_map(51:75));
% h_ent(:,4) = vertcat(h_map(76:100));
% h_ent(:,5) = vertcat(h_map(101:125));
% [~,~,stats_h] = anova1(cell2mat(h_ent));
% [c_h,~,~,gnames_h] = multcompare(stats_h,'ctype','bonferroni'); % example comparison