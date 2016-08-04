if ~(exist('NeuronsDB', 'var') & exist('MoCap_Sessions', 'var'))
	load('workspace.mat')
end

alignment = 'Release';
percentile = 50;
plotType = 'KS';

% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, .400, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, .200, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, .064, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, .016, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, .004, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, 0, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.700, percentile, plotType);	
testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.600, percentile, plotType);
testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.500, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.400, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.200, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.064, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.016, percentile, plotType);
% testnstat_univ(NeuronsDB, MoCap_Sessions, alignment, -.004, percentile, plotType);

clear alignment percentile plotType