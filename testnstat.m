% %% Load
% load('NeuronsDB.mat');
% 
% %% Convert spike trains (SLOW).
% nst=nspikeTrain(NeuronsDB(26).spikeTimes, 'Neuron 1'); % Original sample
% rate: 30kHz resampled to 1000 Hz

%% Prep test data
Test.ObjTouch = NeuronsDB(26).VisualResps_ActObs.EventsByAction(1).ObjTouch;
Test.ObjRelease = NeuronsDB(26).VisualResps_ActObs.EventsByAction(1).ObjRelease;
Test.SpikeTimesAll = NeuronsDB(26).spikeTimes();

Test.Interval = MoCap_Sessions.MoCap_Trials(1).interval;
Test.SampleRate = 1/MoCap_Sessions.MoCap_Trials(1).resolution;
Test.StickSize = MoCap_Sessions.MoCap_Trials(1).StickSize;
Test.StickPosX = MoCap_Sessions.MoCap_Trials(1).StickPosX;
Test.StickPosY = MoCap_Sessions.MoCap_Trials(1).StickPosY;
Test.StickPosZ = MoCap_Sessions.MoCap_Trials(1).StickPosZ;
Test.DistStickChairX = MoCap_Sessions.MoCap_Trials(1).DistStickChairX;
Test.DistStickChairY = MoCap_Sessions.MoCap_Trials(1).DistStickChairY;
Test.DistStickChairZ = MoCap_Sessions.MoCap_Trials(1).DistStickChairZ;
Test.DistStickChair = MoCap_Sessions.MoCap_Trials(1).DistStickChair;
Test.GripAperture = MoCap_Sessions.MoCap_Trials(1).GripAperture;
Test.HandPosX = MoCap_Sessions.MoCap_Trials(1).HandPosX;
Test.HandPosY = MoCap_Sessions.MoCap_Trials(1).HandPosY;
Test.HandPosY = MoCap_Sessions.MoCap_Trials(1).HandPosZ;
Test.HandVel = MoCap_Sessions.MoCap_Trials(1).HandVel;
Test.DistHandObj = MoCap_Sessions.MoCap_Trials(1).DistHandObj;
Test.SpikeTimes = [];

% Get spikeTimes for these trials
for iTrial = 1:length(Test.ObjTouch)
    t0 = Test.ObjTouch(iTrial);
    i1 = find(Test.SpikeTimesAll >= t0 - Test.Interval(1), 1, 'first');
    i2 = find(Test.SpikeTimesAll <= t0 + Test.Interval(2), 1, 'last');
    Test.SpikeTimes = horzcat(Test.SpikeTimes, Test.SpikeTimesAll(i1:i2));
end

% Load spike train object
% load('nst1.mat');

% Prepare some covariates
% First convert event times into binary time series
