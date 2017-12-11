FM_by_time = true; %Weight fixation points by fixation duration
firstInterestPoint = true; %Use only the first selection of the interest points or not.
filtflag = false; %Apply Gaussian to all maps
sig = 27;
binsize = 128; %[256];

map_correlation(binsize,filtflag,sig,firstInterestPoint)
plot_corr
h = figure(1);

pause;

saveas(h,['./Results/corrplot_' num2str(binsize) '_sal_FMbytime.fig']);
saveas(h,['./Results/corrplot_' num2str(binsize) '_sal_FMbytime.png']);