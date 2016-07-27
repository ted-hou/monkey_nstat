load('workspace.mat')

numCells = 40;
skippedCells = [];

% NstCollObj: Create nstColl object containing all neurons
for iCell = 1:numCells
	if sum(skippedCells == iCell) == 0
		% Splice out the parts w/o MoCap data
		ThisNeuron = Neuron(NeuronsDB,MoCap_Sessions,iCell + 25, 1);
		[spikeTimes, Mocap, time] = ThisNeuron.splice('Release', [-1, 1]);

		if iCell == 1
			NstCollObj = nstColl({nspikeTrain(spikeTimes)});
		else
			NstCollObj.addToColl(nspikeTrain(spikeTimes));
		end
	end
end

% CovCollObj: Create CovColl object containing all MoCap data
CovCollObj = CovColl({...
	Covariate(time, ones(size(time)), 'Baseline', 'Time', 's', '', {'Baseline'}),...
	Covariate(time, Mocap.StickSize, 'StickSize', 'Time', 's', '', {'StickSize'}),...
	Covariate(time, Mocap.StickPosX, 'StickPosX', 'Time', 's', '', {'StickPosX'}),...
	Covariate(time, Mocap.StickPosY, 'StickPosY', 'Time', 's', '', {'StickPosY'}),...
	Covariate(time, Mocap.StickPosZ, 'StickPosZ', 'Time', 's', '', {'StickPosZ'}),...
	Covariate(time, Mocap.GripAperture, 'GripAperture', 'Time', 's', '', {'GripAperture'}),...
	Covariate(time, Mocap.HandPosX, 'HandPosX', 'Time', 's', '', {'HandPosX'}),...
	Covariate(time, Mocap.HandPosY, 'HandPosY', 'Time', 's', '', {'HandPosY'}),...
	Covariate(time, Mocap.HandPosZ, 'HandPosZ', 'Time', 's', '', {'HandPosZ'}),...
	Covariate(time, Mocap.HandVel, 'HandVel', 'Time', 's', '', {'HandVel'}),...
	Covariate(time, Mocap.DistStickChairX, 'DistStickChairX', 'Time', 's', '', {'DistStickChairX'}),...
	Covariate(time, Mocap.DistStickChairY, 'DistStickChairY', 'Time', 's', '', {'DistStickChairY'}),...
	Covariate(time, Mocap.DistStickChairZ, 'DistStickChairZ', 'Time', 's', '', {'DistStickChairZ'}),...
	Covariate(time, Mocap.DistStickChair, 'DistStickChair', 'Time', 's', '', {'DistStickChair'}),...
	Covariate(time, Mocap.DistHandStickX, 'DistHandStickX', 'Time', 's', '', {'DistHandStickX'}),...
	Covariate(time, Mocap.DistHandStickY, 'DistHandStickY', 'Time', 's', '', {'DistHandStickY'}),...
	Covariate(time, Mocap.DistHandStickZ, 'DistHandStickZ', 'Time', 's', '', {'DistHandStickZ'}),...
	Covariate(time, Mocap.DistHandStick, 'DistHandStick', 'Time', 's', '', {'DistHandStick'}),...
	Covariate(time, Mocap.HandVelStickX, 'HandVelStickX', 'Time', 's', '', {'HandVelStickX'}),...
	Covariate(time, Mocap.HandVelStickY, 'HandVelStickY', 'Time', 's', '', {'HandVelStickY'}),...
	Covariate(time, Mocap.HandVelStickZ, 'HandVelStickZ', 'Time', 's', '', {'HandVelStickZ'}),...
	Covariate(time, Mocap.HandSpeedStick, 'HandSpeedStick', 'Time', 's', '', {'HandSpeedStick'})...
});

% EventsObj: Create Events object containing ObjTouch and ObjRelease Times
eLabels = {};
eTimes = [];
for iTrial = 1:length(ThisNeuron.ObjReleaseTimes);
	eTimes = horzcat(eTimes, [ThisNeuron.ObjReleaseTimes(iTrial)]);
	eLabels = horzcat(eLabels, {['R_', num2str(iTrial)]});
end
EventsObj = Events(eTimes, eLabels);

% HistoryObj: Create History object
windowTimes = [0, .002, .005];
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
				{'DistHandStickX', 'DistHandStickX'},...
				{'DistHandStickY', 'DistHandStickY'},...
				{'DistHandStickZ', 'DistHandStickZ'},...
				{'HandVelStickX', 'HandVelStickX'},...
				{'HandVelStickY', 'HandVelStickY'},...
				{'HandVelStickZ', 'HandVelStickZ'}...
			},...
			1000, [], [], [], 'All' ...
		),...
		TrialConfig(...
			{...
				{'Baseline', 'Baseline'},...
				{'GripAperture', 'GripAperture'},...
				{'DistHandStickX', 'DistHandStickX'},...
				{'DistHandStickY', 'DistHandStickY'},...
				{'DistHandStickZ', 'DistHandStickZ'},...
				{'HandVelStickX', 'HandVelStickX'},...
				{'HandVelStickY', 'HandVelStickY'},...
				{'HandVelStickZ', 'HandVelStickZ'}...
			},...
			1000, windowTimes, [], [], 'All' ...
		)...
	}...
);

% Analyze the data
ResultsObj = Analysis.RunAnalysisForAllNeurons(TrialObj, ConfigCollObj, 1);

iFig = 1;
iCells = 1:numCells; iCells(skippedCells) = [];

for iCell = iCells
	figure(iFig);
	saveas(gcf,['nStat_',num2str(iCell),'_Release.jpg']);
	iFig = iFig + 1;
end


clear iCell spikeTimes Mocap time iTrial eTimes eLabels windowTimes numCells iFig iCells

