function [minIndices maxIndices persistence globalMinIndex globalMinValue] = persistence1d_analysis(data, threshold)
    mex run_persistence1d.cpp 
    single_precision_data = single(data);
    [minIndices maxIndices persistence globalMinIndex globalMinValue] = run_persistence1d(single_precision_data); 
    % Plot all features
%     figure; 
%     subplot(2,1,1);
%     plot(data);
%     title('all extrema');
%     hold on;

    % Add a scatter plot of all found features
%     extremaIndices = [minIndices ; maxIndices ; globalMinIndex];
%     markers = data(extremaIndices);
%     scatter(extremaIndices, markers,'fill');
%     markers = data(maxIndices);
%     scatter(maxIndices, markers, 'fill');

end

