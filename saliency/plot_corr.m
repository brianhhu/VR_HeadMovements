% Plot the results of the correlation analyses
%
% By Daniel Jeck 2016

load('corr_rand') % correlation results of randomly shuffled pictures (e.g. pic 1 fixation with pic 2 interest)
load('corr_true'); % correlation results of matched pictures (e.g. pic 1 fixation and interest)
load('R_samp_err_fixhead'); % correlation of fixations resampled with the number of heads (sample error only cause of <1 correlation)
load('R_samp_err_intfix'); % correlation of interest resampled with the number of fixation
load('R_samp_err_inthead'); % correlation of interest resampled with the number of heads
load('R_samp_err_headsal');
load('R_intNheads_fix2');
load('R_samp_err_fixsal');
load('R_samp_err_intsal');

Ravg = mean(R_true,3);
figure(1);

%% Fixations vs interest

subplot(2,3,1)

alpha = 0.5;
xlist = [-0.5:0.05:1];

[pRfixint_rand] = phistf(Rfixint_rand(:),xlist,'FaceColor','b','FaceAlpha',alpha);
xlim([-0.2 1]);
hold on;
[pRfixint] = phistf(Rfixint(:),xlist,'FaceColor','r','FaceAlpha',alpha);
[pRfixhead_samp_err] = phistf(mean(R_samp_err_intfix,1),xlist,'FaceColor','k','FaceAlpha',alpha);
hold off;

plot(xlist,pRfixint_rand,'b')
hold all;
plot(xlist,pRfixint,'r')
plot(xlist,pRfixhead_samp_err,'k')
hold off

% xlabel('Correlation Value');
ylabel('Relative Frequency');

% compute p-values
[~, p_Rfixint] = ztest(mean(Rfixint),mean(Rfixint_rand(:)), ...
    sqrt(var(Rfixint(:))/length(Rfixint) + var(Rfixint_rand(:))/length(Rfixint_rand(:))),0.95,'right'); %two sampled z-test by computing sigma as sqrt(var1/n1+var2/n2)
[~, p_Rfixint_samp_err] = ztest(mean(Rfixint),mean(R_samp_err_intfix(:)), ...
    sqrt(var(Rfixint(:))/length(Rfixint) + var(mean(R_samp_err_intfix))/length(mean(R_samp_err_intfix))),0.95,'both');
p_Rfixint_samp_err2 = (sum(mean(Rfixint)>=mean(R_samp_err_intfix,2))+1)/(size(R_samp_err_intfix,1)+1);

disp(['pfixint = ' num2str(p_Rfixint) ' / ' num2str(p_Rfixint_samp_err) '/' num2str(p_Rfixint_samp_err2)]);
title('Fixation vs Interest');

y = 0.5;

% subplot(2,2,1)
hold all;

herrorbar(mean(Rfixint),y,std(Rfixint)/sqrt(length(Rfixint)),'or');
herrorbar(mean(Rfixint_rand(:)),y,std(Rfixint_rand(:))/sqrt(length(Rfixint)),'ob');
herrorbar(mean(R_samp_err_intfix(:)),y,std(R_samp_err_intfix(:))/sqrt(length(Rfixint)),'ok');
ylim([0 y+.1])
hold off



%% Fixations vs heads
figure(1);
% subplot(2,4,2);
% plot(sort(Rfixhead_rand(:)))
% hold on;
% plot(0.95*length(Rfixhead_rand(:)),Rfixhead,'r*');
% plot(0.95*length(Rfixhead_rand(:)),Ravg(1,3),'g*');
% errorbar(0.95*length(Rfixhead_rand(:)),Ravg(1,3),...
%     1.96*std(Rfixhead)/sqrt(length(Rfixhead)),'g');
% plot(0.95*length(Rfixhead_rand(:)),mean(R_samp_err_fixhead(:)),'k*');
% plot(0.95*length(Rfixhead_rand(:)),mean(R_intNheads_fix(:)),'b*');
% hold off

subplot(2,3,4)

pRfixhead_rand = phistf(Rfixhead_rand(:),xlist,'FaceColor','b','FaceAlpha',alpha);
xlim([-0.2 1]);
hold on;
pRfixhead = phistf(Rfixhead(:),xlist,'FaceColor','r','FaceAlpha',alpha);
pRfixhead_samp_err = phistf(mean(R_samp_err_fixhead,1),xlist,'FaceColor','k','FaceAlpha',alpha);
hold off;

plot(xlist,pRfixhead_rand,'b')
hold all;
plot(xlist,pRfixhead,'r')
plot(xlist,pRfixhead_samp_err,'k')
hold off

[~, p_Rfixhead] = ztest(mean(Rfixhead),mean(Rfixhead_rand(:)),...
    sqrt(var(Rfixhead(:))/length(Rfixhead) + var(Rfixhead_rand(:))/length(Rfixhead_rand(:))),0.95,'right');
[~, p_Rfixhead_samp_err] = ztest(mean(Rfixhead),mean(R_samp_err_fixhead(:)),...
    sqrt(var(Rfixhead(:))/length(Rfixhead) + var(mean(R_samp_err_fixhead))/length(mean(R_samp_err_fixhead))),0.95,'both');
p_Rfixhead_samp_err2 = (sum(mean(Rfixhead)>=mean(R_samp_err_fixhead,2))+1)/(size(R_samp_err_fixhead,1)+1);

% title('Fixation vs Taps');
title('Fixation vs Head');
xlabel('Correlation Value');
ylabel('Relative Frequency')

disp(['pfixhead = ' num2str(p_Rfixhead) ' / ' num2str(p_Rfixhead_samp_err) '/' num2str(p_Rfixhead_samp_err2)]);

y = 0.5;
% subplot(2,3,4)
hold all;

herrorbar(mean(Rfixhead),y,std(Rfixhead)/sqrt(length(Rfixhead)),'or');
herrorbar(mean(Rfixhead_rand(:)),y,std(Rfixhead_rand(:))/sqrt(length(Rfixhead)),'ob');
herrorbar(mean(R_samp_err_fixhead(:)),y,std(R_samp_err_fixhead(:))/sqrt(length(Rfixhead)),'ok');
ylim([0 y+.1])

hold off



%% Interest vs heads
figure(1);
% subplot(2,4,3);
% plot(sort(Rinthead_rand(:)))
% hold on;
% plot(0.95*length(Rinthead_rand(:)),Rinthead,'r*');
% plot(0.95*length(Rinthead_rand(:)),Ravg(2,3),'g*');
% errorbar(0.95*length(Rinthead_rand(:)),Ravg(2,3),...
%     1.96*std(Rinthead)/sqrt(length(Rinthead)),'g');
% plot(0.95*length(Rinthead_rand(:)),mean(R_samp_err_inthead(:)),'k*');
% 
% hold off

subplot(2,3,5)

pRinthead_rand = phistf(Rinthead_rand(:),xlist,'FaceColor','b','FaceAlpha',alpha);
xlim([-0.2 1]);
hold on;
pRinthead = phistf(Rinthead(:),xlist,'FaceColor','r','FaceAlpha',alpha);
pRinthead_samp_err = phistf(mean(R_samp_err_inthead,1),xlist,'FaceColor','k','FaceAlpha',alpha);
hold off;

plot(xlist,pRinthead_rand,'b')
hold all;
plot(xlist,pRinthead,'r')
plot(xlist,pRinthead_samp_err,'k')
hold off


[~, p_Rinthead] = ztest(mean(Rinthead),mean(Rinthead_rand(:)),...
    sqrt(var(Rinthead(:))/length(Rinthead) + var(Rinthead_rand(:))/length(Rinthead_rand(:))),0.95,'right');
[~, p_Rinthead_samp_err] = ztest(mean(Rinthead),mean(R_samp_err_inthead(:)),...
    sqrt(var(Rinthead(:))/length(Rinthead) + var(mean(R_samp_err_inthead))/length(mean(R_samp_err_inthead))),0.95,'both');
p_Rinthead_samp_err2 = (sum(mean(Rinthead)>=mean(R_samp_err_inthead,2))+1)/(size(R_samp_err_inthead,1)+1);



% title('Interest vs Taps');
title('Interest vs Head');
xlabel('Correlation Value');
% ylabel('Relative Frequency');
disp(['pinthead = ' num2str(p_Rinthead) ' / ' num2str(p_Rinthead_samp_err) ' / ' num2str(p_Rinthead_samp_err2)]);

y = 0.5;
% subplot(2,3,5)
hold all;

herrorbar(mean(Rinthead),y,std(Rinthead)/sqrt(length(Rinthead)),'or');
herrorbar(mean(Rinthead_rand(:)),y,std(Rinthead_rand(:))/sqrt(length(Rinthead)),'ob');
herrorbar(mean(R_samp_err_inthead(:)),y,std(R_samp_err_inthead(:))/sqrt(length(Rinthead)),'ok');
ylim([0 y+.1])

hold off


%% Taps vs Sal

figure(1);
% subplot(2,4,4);
% plot(sort(Rheadsal_rand(:)))
% 
% hold on;
% plot(0.95*length(Rheadsal_rand(:)),Rheadsal,'r*');
% plot(0.95*length(Rheadsal_rand(:)),Ravg(3,4),'g*');
% errorbar(0.95*length(Rheadsal_rand(:)),Ravg(3,4),...
%     1.96*std(Rheadsal)/sqrt(length(Rheadsal)),'g');
% plot(0.95*length(Rheadsal_rand(:)),mean(R_samp_err_headsal(:)),'k*');
% 
% hold off

subplot(2,3,6)

pRheadsal_rand = phistf(Rheadsal_rand(:),xlist,'FaceColor','b','FaceAlpha',alpha);
xlim([-0.2 1]);
hold on;
pRheadsal = phistf(Rheadsal(:),xlist,'FaceColor','r','FaceAlpha',alpha);
pRheadsal_samp_err = phistf(mean(R_samp_err_headsal,1),xlist,'FaceColor','k','FaceAlpha',alpha);
hold off;

plot(xlist,pRheadsal_rand,'b')
hold all;
plot(xlist,pRheadsal,'r')
plot(xlist,pRheadsal_samp_err,'k')
hold off

% legend('Null hypothesis','Measured correllation','Upper bound');

[~, p_Rheadsal] = ztest(mean(Rheadsal),mean(Rheadsal_rand(:)),...
    sqrt(var(Rheadsal(:))/length(Rheadsal) + var(Rheadsal_rand(:))/length(Rheadsal_rand(:))),0.95,'right');
[~, p_Rheadsal_samp_err] = ztest(mean(Rheadsal),mean(R_samp_err_headsal(:)),...
    sqrt(var(Rheadsal(:))/length(Rheadsal) + var(mean(R_samp_err_headsal))/length(mean(R_samp_err_headsal))),0.95,'both');
p_Rheadsal_samp_err2 = (sum(mean(Rheadsal)>=mean(R_samp_err_headsal,2))+1)/(size(R_samp_err_headsal,1)+1);

% title('Comp Saliency vs Taps');
title('Comp Saliency vs Head');
xlabel('Correlation Value');

disp(['pheadsal = ' num2str(p_Rheadsal) ' / ' num2str(p_Rheadsal_samp_err) ' / ' num2str(p_Rheadsal_samp_err2)]);

legend('Null hypothesis','Measured correllation','Sample Error hypothesis');

y=0.5;
% subplot(2,3,6)
hold all;

herrorbar(mean(Rheadsal),y,std(Rheadsal)/sqrt(length(Rheadsal)),'or');
herrorbar(mean(Rheadsal_rand(:)),y,std(Rheadsal_rand(:))/sqrt(length(Rheadsal)),'ob');
herrorbar(mean(R_samp_err_headsal(:)),y,std(R_samp_err_headsal(:))/sqrt(length(Rheadsal)),'ok');
ylim([0 y+.1])

hold off


%% Fixation vs Salience
%

figure(1);
subplot(2,3,2);
[pRfixsal_rand] = phistf(Rfixsal_rand(:),xlist,'FaceColor','b','FaceAlpha',alpha);
xlim([-0.2 1]);
hold on;
[pRfixsal] = phistf(Rfixsal(:),xlist,'FaceColor','r','FaceAlpha',alpha);
[pRfixsal_samp_err] = phistf(mean(R_samp_err_fixsal,1),xlist,'FaceColor','k','FaceAlpha',alpha);
hold off;

plot(xlist,pRfixsal_rand,'b')
hold all;
plot(xlist,pRfixsal,'r')
plot(xlist,pRfixsal_samp_err,'k')
hold off

% xlabel('Correlation Value');
% ylabel('Relative Frequency');

[~, p_Rfixsal] = ztest(mean(Rfixsal),mean(Rfixsal_rand(:)),...
    sqrt(var(Rfixsal(:))/length(Rfixsal) + var(Rfixsal_rand(:))/length(Rfixsal_rand(:))),0.95,'right');
[~, p_Rfixsal_samp_err] = ztest(mean(Rfixsal),mean(R_samp_err_fixsal(:)),...
    sqrt(var(Rfixsal(:))/length(Rfixsal) + var(mean(R_samp_err_fixsal))/length(mean(R_samp_err_fixsal))),0.95,'both');
p_Rfixsal_samp_err2 = (sum(mean(Rfixsal)>=mean(R_samp_err_fixsal,2))+1)/(size(R_samp_err_fixsal,1)+1);


y=0.5;

disp(['pfixsal = ' num2str(p_Rfixsal) ' / ' num2str(p_Rfixsal_samp_err) ' / ' num2str(p_Rfixsal_samp_err2)]);
title('Fixation vs Comp Saliency');
hold on;
herrorbar(mean(Rfixsal),y,std(Rfixsal)/sqrt(length(Rfixsal)),'or');
herrorbar(mean(Rfixsal_rand(:)),y,std(Rfixsal_rand(:))/sqrt(length(Rfixsal)),'ob');
herrorbar(mean(R_samp_err_fixsal(:)),y,std(R_samp_err_fixsal(:))/sqrt(length(Rfixsal)),'ok');
ylim([0 y+.1])

hold off;

%% Int vs Salience

figure(1);
subplot(2,3,3);
[pRintsal_rand] = phistf(Rintsal_rand(:),xlist,'FaceColor','b','FaceAlpha',alpha);
xlim([-0.2 1]);
hold on;
[pRintsal] = phistf(Rintsal(:),xlist,'FaceColor','r','FaceAlpha',alpha);
[pRintsal_samp_err] = phistf(mean(R_samp_err_intsal,1),xlist,'FaceColor','k','FaceAlpha',alpha);
hold off;

plot(xlist,pRintsal_rand,'b')
hold all;
plot(xlist,pRintsal,'r')
plot(xlist,pRintsal_samp_err,'k')
hold off

% xlabel('Correlation Value');
% ylabel('Relative Frequency');

[~, p_Rintsal] = ztest(mean(Rintsal),mean(Rintsal_rand(:)),...
    sqrt(var(Rintsal(:))/length(Rintsal) + var(Rintsal_rand(:))/length(Rintsal_rand(:))),0.95,'right');
[~, p_Rintsal_samp_err] = ztest(mean(Rintsal),mean(R_samp_err_intsal(:)),...
    sqrt(var(Rintsal(:))/length(Rintsal) + var(mean(R_samp_err_intsal))/length(mean(R_samp_err_intsal))),0.95,'both');
p_Rintsal_samp_err2 = (sum(mean(Rintsal)>=mean(R_samp_err_intsal,2))+1)/(size(R_samp_err_intsal,1)+1);

y=0.5;

disp(['pintsal = ' num2str(p_Rintsal) ' / ' num2str(p_Rintsal_samp_err) '/' num2str(p_Rintsal_samp_err2)]);
title('Interest vs Comp Saliency');
hold on;
herrorbar(mean(Rintsal),y,std(Rintsal)/sqrt(length(Rintsal)),'or');
herrorbar(mean(Rintsal_rand(:)),y,std(Rintsal_rand(:))/sqrt(length(Rintsal)),'ob');
herrorbar(mean(R_samp_err_intsal(:)),y,std(R_samp_err_intsal(:))/sqrt(length(Rintsal)),'ok');
ylim([0 y+.1])

hold off;
subplot(2,3,5)
%% Fix vs. Russell Salience
% 
% pRfixruss_rand = phistf(Rfixruss_rand(:),xlist,'FaceColor','b','FaceAlpha',alpha);
% % xlim([-0.2 1]);
% hold on;
% pRfixruss = phistf(Rfixruss(:),xlist,'FaceColor','r','FaceAlpha',alpha);
% pRfixruss_samp_err = phistf(mean(R_samp_err_fixruss,2),xlist,'FaceColor','k','FaceAlpha',alpha);
% hold off;
% 
% plot(xlist,pRfixruss_rand,'b')
% hold all;
% plot(xlist,pRfixruss,'r')
% plot(xlist,pRfixruss_samp_err,'k')
% hold off
% 
% legend('Null hypothesis','Measured correllations','Sample Error hypothesis');
% 
% [~, p_Rfixruss] = ztest(mean(Rfixruss),mean(Rfixruss_rand(:)),std(Rfixruss_rand(:))/sqrt(length(Rfixruss)),0.95,'right');
% [~, p_Rfixruss_samp_err] = ztest(mean(Rfixruss),mean(R_samp_err_fixruss(:)),std(mean(R_samp_err_fixruss,2)),0.95,'both');
% 
% 
% title('Russ Sal vs Fix');
% xlabel('Correlation Value');
% 
% disp(['pfixruss = ' num2str(p_Rfixruss) ' / ' num2str(p_Rfixruss_samp_err)]);


% y=0.4;
% % subplot(2,3,5)
% hold all;
% 
% herrorbar(mean(Rfixruss),y,std(Rfixruss)/sqrt(length(Rfixruss)),'or');
% herrorbar(mean(Rfixruss_rand(:)),y,std(Rfixruss_rand(:))/sqrt(length(Rfixruss)),'ob');
% herrorbar(mean(R_samp_err_fixruss(:)),y,std(R_samp_err_fixruss(:))/sqrt(length(Rfixruss)),'ok');
% 
% hold off

%%
boldify
% 
% %%
% figure(2)
% pic = 64-30;
% 
% % for pic = 1:48
% pthresh = 0.025; 
% 
% y=0.5;
% hist(R_samp_err_fixhead(:,pic));
% 
% Pupper = phistf(R_samp_err_fixhead(:,pic),xlist);
% Plower = phistf(Rfixhead_rand(:),xlist);
% 
% upper_err = std(R_samp_err_fixhead(:,pic));
% lower_err = std(Rfixhead_rand(:));
% 
% % upper_sort = sort(R_upper_fixhead(:,pic));
% % upper_L = upper_sort(ceil(pthresh*length(upper_sort)))-mean(upper_sort);
% % upper_sort = sort(R_upper_fixhead(:,pic),'descend');
% % upper_U = upper_sort(ceil(pthresh*length(upper_sort)))-mean(upper_sort);
% 
% % lower_sort = sort(Rfixhead_rand(:));
% % lower_L = lower_sort(ceil(pthresh*length(lower_sort)))-mean(lower_sort);
% % lower_sort = sort(Rfixhead_rand(:),'descend');
% % lower_U = lower_sort(ceil(pthresh*length(lower_sort)))-mean(lower_sort);
% 
% 
% 
% plot(xlist,Pupper,'k');
% hold on;
% plot(xlist,Plower,'b');
% herrorbar(mean(Rfixhead_rand(:)),y,lower_err,'ob')
% herrorbar(mean(R_samp_err_fixhead(:,pic)),y,upper_err,'ok')
% stem(Rfixhead(pic),y,'or');
% hold off;
% ylim([0 0.6])
% xlim([-0.2 1]);
% 
% xlabel('Correlation Value');
% ylabel('Relative Frequency');
% 
% pnull = sum(Rfixhead_rand(:)>Rfixhead(pic))/length(Rfixhead_rand(:))
% 
% p_samp_err = sum(R_samp_err_fixhead(:,pic)<Rfixhead(pic))/length(R_samp_err_fixhead(:,pic))
% % title(num2str(pic));
% 
% boldify
% % pause;
% % end