function testnstat_univ(NeuronsDB, MoCap_Sessions, testmode, covDelay, percentile, plotType)
	if nargin < 3
		testmode = 'Touch'; % Can also be 'Release'
	end
	if nargin < 4
		covDelay = 0; % Covariate delay in seconds
	end
	if nargin < 5
		percentile = 0; % 0~100, This percentile (neurons with lowest firing rates are discarded) 
	end
	if nargin < 6
		plotType = 'Full'; % Can be 'Full', 'KS'
	end

	numCells = 40;
	spikeRate = zeros(1, numCells);

	switch testmode
		case 'Touch'
			interval = [-1, 0.4];
		case 'Release'
			interval = [-.4, .5];
	end

	% NstCollObj: Create nstColl object containing all neurons

	disp('Creating spike train objects...')

	% Only use cells with high firing rates
	for iCell = 1:numCells
		ThisNeuron = Neuron(NeuronsDB,MoCap_Sessions,iCell + 25, 1);
		[spikeTimes, Mocap, time] = ThisNeuron.splice(testmode, interval, covDelay);
		spikeRate(iCell) = numel(spikeTimes)/(1.2*20);
	end

	skippedCells 	= find(spikeRate<prctile(spikeRate,percentile));
	keptCells 		= find(spikeRate>=prctile(spikeRate,percentile));

	% NstCollObj: Create nstColl object containing all neurons
	for iCell = 1:numCells
		if sum(skippedCells == iCell) == 0
			% Splice out the parts w/o MoCap data
			ThisNeuron = Neuron(NeuronsDB,MoCap_Sessions,iCell + 25, 1);
			[spikeTimes, Mocap, time] = ThisNeuron.splice(testmode, interval, covDelay);

			if iCell == keptCells(1)
				NstCollObj = nstColl({nspikeTrain(spikeTimes)});
			else
				NstCollObj.addToColl(nspikeTrain(spikeTimes));
			end
		end
	end

	switch testmode
		case 'Touch'
			center = ThisNeuron.ObjTouchTimes;
		case 'Release'
			center = ThisNeuron.ObjReleaseTimes;
	end

	% CovCollObj: Create CovColl object containing all MoCap data
	disp(['Creating covariate objects with ',num2str(round(covDelay*1000)),'ms delay','...'])

	covariateNames = {...
		'StickSize',...
		'StickPosX',...
		'StickPosY',...
		'StickPosZ',...
		'GripAperture',...
		'HandPosX',...
		'HandPosY',...
		'HandPosZ',...
		'HandVel',...
		'DistStickChairX',...
		'DistStickChairY',...
		'DistStickChairZ',...
		'DistStickChair',...
		'DistHandStickX',...
		'DistHandStickY',...
		'DistHandStickZ',...
		'DistHandStick',...
		'HandVelStickX',...
		'HandVelStickY',...
		'HandVelStickZ',...
		'HandSpeedStick'...
	};

	CovCollObj = CovColl({Covariate(time, ones(size(time)), 'Baseline', 'Time', 's', '', {'Baseline'})});

	for iCov = 1:length(covariateNames)
		covName = covariateNames{iCov};	
		CovCollObj.addToColl(Covariate(time, Mocap.(covName), covName, 'Time', 's', '', {covName}));
	end

	% EventsObj: Create Events object containing ObjTouch and ObjRelease Times
	eLabels = {};
	eTimes = [];
	for iTrial = 1:length(center);
		eTimes = horzcat(eTimes, [center(iTrial)]);
		eLabels = horzcat(eLabels, {['T_', num2str(iTrial)]});
	end
	EventsObj = Events(eTimes, eLabels);

	% HistoryObj: Create History object
	windowTimes = [0, .06, .5];
	HistoryObj = History(windowTimes);

	% TrialObj: Create Trial object containing CovCollObj, NstCollObj, EventsObj and HistoryObj
	% TrialObj = Trial(NstCollObj, CovCollObj, EventsObj, HistoryObj);
	TrialObj = Trial(NstCollObj, CovCollObj, EventsObj, HistoryObj);

	% ConfigCollObj: Create ConfigColl object, which is a collenction of TrialConfig objects specifying how to analyze the data.
	ConfigCollObj = ConfigColl(...
		{...
			TrialConfig(...
				{...
					{'Baseline', 'Baseline'},...
				},...
				1000, [], [], [], 'All' ...
			),...
			TrialConfig(...
				{...
					{'Baseline', 'Baseline'},...
					{'GripAperture', 'GripAperture'},...
					{'DistHandStick', 'DistHandStick'},...
					{'HandVel', 'HandVel'}...
				},...
				1000, [], [], [], 'All' ...
			),...
			TrialConfig(...
				{...
					{'Baseline', 'Baseline'},...
					{'GripAperture', 'GripAperture'},...
					{'DistHandStick', 'DistHandStick'},...
					{'HandVel', 'HandVel'}...
				},...
				1000, windowTimes, [], [], 'All' ...
			)...
		}...
	);

	% Analyze the data
	disp('Performing pp-GLM fit...')
	switch plotType
		case 'Full'
			Analysis.RunAnalysisForAllNeurons(TrialObj, ConfigCollObj, 1);
		case 'KS'
			ResultsObj = Analysis.RunAnalysisForAllNeurons(TrialObj, ConfigCollObj, 0);
			for iCell = 1:length(ResultsObj);
				figure(iCell)
				Analysis.KSPlot(ResultsObj{iCell});			
			end
	end
	
	disp('Saving figures to disk...')
	iFig = 1;
	iCells = 1:numCells; iCells(skippedCells) = [];

	for iCell = iCells
		figure(iFig);
		if strcmp(plotType, 'KS')
			title(['KS Plot (', testmode, ', ', num2str(round(covDelay*1000)),'ms)']);
		end
		saveas(gcf,['nStat_',num2str(iCell),'_',testmode,'_',num2str(round(covDelay*1000)),'ms','.jpg']);
		iFig = iFig + 1;
	end

	close all

	disp('Done!')

end