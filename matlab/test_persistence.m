% mex run_persistence1d.cpp 

sil_area = textread('sil_area_data.txt');
sil_len = textread('sil_len_data.txt');

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

[sil_area_minIndices sil_area_maxIndices ail_area_persistence ail_area_globalMinIndex sil_area_globalMinValue] = ...
    persistence1d_analysis(sil_area);

figure;
subplot(2, 1, 1);
plot(x, sil_area, 'r');
title('Silhouette Area');
hold on;
% Add a scatter plot of all (unfiltered) maxima
markers = sil_area(sil_area_maxIndices);
scatter(sil_area_maxIndices, markers, 'blue', 'fill');
hold off;

[sil_len_minIndices sil_len_maxIndices sil_len_persistence sil_len_globalMinIndex sil_len_globalMinValue] = ...
    persistence1d_analysis(sil_len);
subplot(2, 1, 2);
plot(x, sil_len, 'r');
title('Silhouette Length');
hold on;
% Add a scatter plot of all (unfiltered) maxima
markers = sil_len(sil_len_maxIndices);
scatter(sil_len_maxIndices, markers, 'blue', 'fill');
hold off;
