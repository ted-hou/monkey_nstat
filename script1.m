if ~(exist('NeuronsDB', 'var') & exist('MoCap_Sessions', 'var'))
	load('workspace.mat')
end

%% Generate Neuron class
for iCell = 26:65
	Neurons(iCell - 25).N = Neuron(NeuronsDB,MoCap_Sessions,iCell,1);
end
clear iCell

%% Calculate covariates
% plotSpikeLocation(Neurons, {'DistHandStickX', 'DistHandStickY', 'DistHandStickZ'});
% plotSpikeLocation(Neurons, {'HandVelStickX', 'HandVelStickY', 'HandVelStickZ'});
% plotSpikeLocation(Neurons, {'HandSpeedStick'});
% plotSpikeLocation(Neurons, {'GripAperture'});

for iCell = 1:40
	Neurons(iCell).N.alignAndPlot([-3,4],[-0.1, 0.1], 1000);
end