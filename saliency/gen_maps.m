function maps = gen_maps(points)

%% Generate heat maps from points
sig = 27; %The standard deviation of the gaussian

maps = cell(125,1);

[X, Y] = meshgrid(-3*sig:3*sig,-3*sig:3*sig);
gauss = 1*exp(-((X.^2)+(Y.^2))./(2*sig^2));

for pic = 1:125
    maps{pic} = conv2(points{pic},gauss,'same');
end

% Choose the appropriate map you would like to generate: head, fixation, interest
S.('headmaps') = maps;
save('head_maps', '-struct', 'S')
% S.('fixmaps') = maps;
% save('fixation_maps', '-struct', 'S')
% S.('intmaps') = maps;
% save('interest_maps', '-struct', 'S')
