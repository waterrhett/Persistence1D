% mex run_persistence1d.cpp 
clear;
close all;
sil_area = textread('input/bullet_sil_area_data.txt');
sil_len = textread('input/bullet_sil_len_data.txt');
sil_area = sil_area';
sil_len = sil_len';

n = length(sil_area);
x = 1:n;
% 
% d_sil_area = gradient(sil_area);
% d_sil_len = gradient(sil_len);
%
% hold on
% plot(x, sil_area, 'b')
% plot(x, d_sil_area, 'r')
% 
% figure
% hold on
% plot(x, sil_len, 'b')
% plot(x, d_sil_len, 'r')
%% Thresholds
sil_area_persistence_threshold_ratio = 0.05;
sil_len_persistence_threshold_ratio = 0.05;
dp_sil_area_threshold_ratio = 0.3;
dp_sil_len_threshold_ratio = 0.4;

%% Compute the local maxima
[sil_area_minIndices sil_area_maxIndices sil_area_persistence sil_area_globalMinIndex sil_area_globalMinValue] = ...
    persistence1d_analysis(sil_area, sil_area_persistence_threshold_ratio);

[sil_len_minIndices sil_len_maxIndices sil_len_persistence sil_len_globalMinIndex sil_len_globalMinValue] = ...
    persistence1d_analysis(sil_len, sil_len_persistence_threshold_ratio);
%% Threshold the extreama by persistence

sil_area_persistence_diff = max(sil_area_persistence) - min(sil_area_persistence);
sil_len_persistence_diff = max(sil_len_persistence) - min(sil_len_persistence);

sil_area_persistent_features = ...
    filter_features_by_persistence(sil_area_minIndices, sil_area_maxIndices, sil_area_persistence, ...
    sil_area_persistence_threshold_ratio * sil_area_persistence_diff);
sil_len_persistent_features = ...
    filter_features_by_persistence(sil_len_minIndices, sil_len_maxIndices, sil_len_persistence, ...
    sil_len_persistence_threshold_ratio * sil_len_persistence_diff);
threshold_sil_area_maxIndices = sil_area_persistent_features(:,2);
threshold_sil_len_maxIndices = sil_len_persistent_features(:,2);

%% Using Douglas-Peucker on local maxima
% Turn them into data points first
sil_area_data_pts = [x; sil_area];
sil_len_data_pts = [x; sil_len];

sil_area_maxima_data_pts = sil_area_data_pts(:,sil_area_maxIndices);
sil_len_maxima_data_pts = sil_len_data_pts(:,sil_len_maxIndices);

% Sort the data points according to x
% DP requires that the x's come in order
[~, I] = sort(sil_area_maxima_data_pts(1,:));
sorted_sil_area_maxima_data_pts = sil_area_maxima_data_pts(:, I);
sil_area_maxima_diff = ...
    max(sil_area_maxima_data_pts(2, :)) - min(sil_area_maxima_data_pts(2, :));
[~, I] = sort(sil_len_maxima_data_pts(1,:));
sorted_sil_len_maxima_data_pts = sil_len_maxima_data_pts(:, I);
sil_len_maxima_diff = ...
    max(sil_len_maxima_data_pts(2, :)) - min(sil_len_maxima_data_pts(2, :));

dp_sil_area_maxima_data_pts = DouglasPeucker(...
    sorted_sil_area_maxima_data_pts, dp_sil_area_threshold_ratio * sil_area_maxima_diff);
dp_sil_len_maxima_data_pts = DouglasPeucker(...
    sorted_sil_len_maxima_data_pts, dp_sil_len_threshold_ratio * sil_len_maxima_diff);

%%
figure;
subplot(3, 1, 1);
plot(x, sil_area, 'r');
title('Silhouette Area with All Local Maxima');
hold on;
% Add a scatter plot of all (unfiltered) maxima
markers = sil_area(sil_area_maxIndices);
scatter(sil_area_maxIndices, markers, 'blue', 'fill');
% scatter(sil_area_maxIndices, sil_area_maxima_data_pts(2,:), 'blue', 'fill');
% scatter(dp_sil_area_maxima_data_pts(1,:), dp_sil_area_maxima_data_pts(2,:), ...
%     'yellow', 'fill');
hold off;

subplot(3, 1, 2);
plot(x, sil_area, 'r');
title(strcat(...
    'Silhouette Area Local Maxima with Persistence > ', ...
    num2str(sil_area_persistence_threshold_ratio), ...
    ' of Max Persistence'));
hold on;
markers = sil_area(threshold_sil_area_maxIndices);
scatter(threshold_sil_area_maxIndices, markers, 'blue', 'fill');
hold off;

subplot(3, 1, 3);
plot(x, sil_area, 'r');
title(strcat(...
    'Silhouette Area Local Maxima (DP) threshold > ',...
    num2str(dp_sil_area_threshold_ratio),...
    ' of Max Persistence'));

hold on;
scatter(dp_sil_area_maxima_data_pts(1,:), dp_sil_area_maxima_data_pts(2,:), ...
    'blue', 'fill');
hold off;
%%
figure;
subplot(3, 1, 1);
plot(x, sil_len, 'r');
title('Silhouette Length with All Local Maxima');
hold on;
% Add a scatter plot of all (unfiltered) maxima
markers = sil_len(sil_len_maxIndices);
scatter(sil_len_maxIndices, markers, 'blue', 'fill');
% scatter(sil_len_maxIndices, sil_len_maxima_data_pts(2,:), 'blue', 'fill');
% scatter(dp_sil_len_maxima_data_pts(1,:), dp_sil_len_maxima_data_pts(2,:), ...
%     'yellow', 'fill');
hold off;

subplot(3, 1, 2);
plot(x, sil_len, 'r');
title(strcat(...
    'Silhouette Length Local Maxima with Persistence > ', ...
    num2str(sil_len_persistence_threshold_ratio), ...
    ' of Max Persistence'));
hold on;
markers = sil_len(threshold_sil_len_maxIndices);
scatter(threshold_sil_len_maxIndices, markers, 'blue', 'fill');
hold off;

subplot(3, 1, 3);
plot(x, sil_len, 'r');
title(strcat(...
    'Silhouette Length Local Maxima (DP) threshold > ',...
    num2str(dp_sil_len_threshold_ratio),...
    ' of Max Persistence'));
hold on;
scatter(dp_sil_len_maxima_data_pts(1,:), dp_sil_len_maxima_data_pts(2,:), ...
    'blue', 'fill');
hold off;
%% For outputing keyframe indices (comma separated)
sorted_sa_ind = sort(threshold_sil_area_maxIndices);
sorted_sa_ind = sorted_sa_ind-1;
sorted_sa_ind = [0; sorted_sa_ind; length(sil_area)-1];
output_sa_keyframes = sprintf('%.0f,' , sorted_sa_ind);

sorted_sl_ind = sort(threshold_sil_len_maxIndices);
sorted_sl_ind = sorted_sl_ind-1;
sorted_sl_ind = [0; sorted_sl_ind; length(sil_area)-1];
output_sl_keyframes = sprintf('%.0f,' , sorted_sl_ind);


