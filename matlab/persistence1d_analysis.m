function [minIndices maxIndices persistence globalMinIndex globalMinValue] = persistence1d_analysis(data, threshold)
    single_precision_data = single(data);
    [minIndices maxIndices persistence globalMinIndex globalMinValue] = run_persistence1d(single_precision_data); 
    
%     persistent_features = filter_features_by_persistence(minIndices, maxIndices, persistence, threshold); 
%     maxIndices = persistent_features(:,1);
end

