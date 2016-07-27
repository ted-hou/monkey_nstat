%% Load data
load('MoCap_Sessions.mat');
load('NeuronsDB.mat');

%% Generate Neuron class
for iCell = 26:65
	Neurons(iCell - 25).N = Neuron(NeuronsDB,MoCap_Sessions,iCell,1);
end
clear iCell

%% Calculate covariates
plotSpikeLocation(Neurons, {'DistHandStickX', 'DistHandStickY', 'DistHandStickZ'});
plotSpikeLocation(Neurons, {'HandVelStickX', 'HandVelStickY', 'HandVelStickZ'});
plotSpikeLocation(Neurons, {'HandSpeedStick'});
plotSpikeLocation(Neurons, {'GripAperture'});
