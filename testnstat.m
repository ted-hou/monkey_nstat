%% Load data
load('MoCap_Sessions.mat');
load('NeuronsDB.mat');

%% Generate Neuron class and plot firing frequency vs touch/release events
for iCell = 26:65
	Neurons(iCell - 25).N = Neuron(NeuronsDB,MoCap_Sessions,iCell,1);
end
clear iCell
% Some neurons seemed to respond to touch/release. Some did not differ from
% baseline. A few had too few spikes throughout the session.

%% Some GLM magic with nSTAT
for iCell = 1:length(Neurons)
	% Let's start with 'neuron' 1, splice together the chunks with mocap data
	[spikeTimesSpliced, MoCapSpliced, timeSpliced] = Neurons(iCell).N.splice();

	% Create nSTAT Trial obj
	nstCollObj = nstColl({nspikeTrain(spikeTimesSpliced)});
	covCollObj = CovColl({...
		Covariate(timeSpliced, MoCapSpliced.StickSize, 'StickSize', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.StickPosX, 'StickPosX', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.StickPosY, 'StickPosY', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.StickPosZ, 'StickPosZ', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.GripAperture, 'GripAperture', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.HandPosX, 'HandPosX', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.HandPosY, 'HandPosY', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.HandPosZ, 'HandPosZ', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.HandVel, 'HandVel', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.DistStickChairX, 'DistStickChairX', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.DistStickChairY, 'DistStickChairY', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.DistStickChairZ, 'DistStickChairZ', 'Time', 's'),...
		Covariate(timeSpliced, MoCapSpliced.DistStickChair, 'DistStickChair', 'Time', 's')...
	});
	Neurons(iCel

	% GLM Fit
	[Neurons(iCell).GLMFit.lambda, Neurons(iCell).GLMFit.b, Neurons(iCell).GLMFit.dev, Neurons(iCell).GLMFit.stats, Neurons(iCell).GLMFit.AIC, Neurons(iCell).GLMFit.BIC, Neurons(iCell).GLMFit.distribution] = Analysis.GLMFit(Neurons(iCell).tObj, 1, 1);
end
clear iCell nstCollObj covCollObj spikeTimesSpliced MoCapSpliced timeSpliced

%% Plot glm fit results
for iCell = 1:length(Neurons)
	Neurons(iCell).N.alignAndPlot([-3,4],[-0.1, 0.1], 1000);
	subplot(3,1,3);
	bar(Neurons(iCell).GLMFit.stats.p);
	ax = gca;
	ax.XTickLabel = {'StickSize', 'StickPosX', 'StickPosY', 'StickPosZ', 'GripAperture', 'HandPosX', 'HandPosY', 'HandPosZ', 'HandVel', 'DistStickChairX', 'DistStickChairY', 'DistStickChairZ', 'DistStickChair'};
	ax.XTickLabelRotation=45;
	ylabel('p value'); xlabel('Covariates - MoCap');
	title(['Electrode ', num2str(Neurons(iCell).N.Electrode), ' Channel ', num2str(Neurons(iCell).N.Channel),' Unit', num2str(Neurons(iCell).N.Unit), ' GLM Fit']);
	saveas(gcf,['GLM_pValue_',num2str(iCell),'.jpg']);
end
clear iCell ax

%% Plot spiking location in predictor space
% Stick Pos
% Hand Pos
% Hand Pos - Stick Pos
% DistStickChairXYZ
% Hand Velocity (not speed)
% Hand Speed