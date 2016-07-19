classdef Neuron < handle
	%NEURON Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		Day
		Session
		Electrode
		Channel
		Unit
		SpikeShapes
		SpikeTimes
		ObjTouchTimes
		ObjReleaseTimes
		MC
	end
	
	methods
		function N = Neuron(DB, MoCap_Session, cellId, actionId)
			switch nargin
				case 2
					actionId = 1;
				case 3
			end

			if nargin < 3
				cellId = 1;
			end
			if nargin < 4
				actionId = 1;
			end

			N.Day 				= DB(cellId).day;
			N.Session 			= DB(cellId).session;
			N.Electrode 		= DB(cellId).electrode;
			N.Channel 			= DB(cellId).channel;
			N.Unit 				= DB(cellId).unit;
			N.SpikeShapes 		= DB(cellId).spikeShapes;
			N.SpikeTimes 		= DB(cellId).spikeTimes;
			N.ObjTouchTimes 	= DB(cellId).VisualResps_ActObs.EventsByAction(actionId).ObjTouch;
			N.ObjReleaseTimes 	= DB(cellId).VisualResps_ActObs.EventsByAction(actionId).ObjRelease;
			N.MC                = MoCap(MoCap_Session, actionId);
		end

		function [spikeFreqAligned, spikeFreqBaseAligned] = alignFreq(N, alignMode, interval, freqInterval, sampleRate)
			if nargin < 3
				interval = [-3, 4];
			end
			if nargin < 4
				freqInterval = [-0.5, 0.5];
			end
			if nargin < 5
				sampleRate = 1000;
			end

			switch lower(alignMode)
				case 'touch'
					centers = N.ObjTouchTimes;
				case 'release'
					centers = N.ObjReleaseTimes;
				otherwise
					centers = N.ObjReleaseTimes;
			end

			spikeFreqAligned = [];
			spikeFreqBaseAligned = [];

			for iTrial = 1:length(centers)
				center 	= centers(iTrial);
				left 	= center + interval(1);
				right 	= center + interval(2);

				centerBase 	= N.ObjTouchTimes(iTrial) - (right - left);
				leftBase 	= centerBase + interval(1);
				rightBase 	= centerBase + interval(2);

				freqThisTrial = zeros(1, (right - left)*sampleRate + 1);
				freqThisTrialBase = freqThisTrial;
				for iFrame = 1:(right - left)*sampleRate + 1
					tFrame = left + iFrame/sampleRate;
					tFrameBase = leftBase + iFrame/sampleRate;
					freqThisTrial(iFrame) = sum(N.SpikeTimes >= tFrame + freqInterval(1) & N.SpikeTimes <= tFrame + freqInterval(2))/(freqInterval(2) - freqInterval(1));
					freqThisTrialBase(iFrame) = sum(N.SpikeTimes >= tFrameBase + freqInterval(1) & N.SpikeTimes <= tFrameBase + freqInterval(2))/(freqInterval(2) - freqInterval(1));
				end
				spikeFreqAligned = vertcat(spikeFreqAligned, freqThisTrial); 
				spikeFreqBaseAligned = vertcat(spikeFreqBaseAligned, freqThisTrialBase);
			end
		end

		function [freqTouch, freqRelease, freqBase] = alignAndPlot(N, interval, freqInterval, sampleRate)
			if nargin < 3
				interval = [-3, 4];
			end
			if nargin < 4
				freqInterval = [-0.5, 0.5];
			end
			if nargin < 5
				sampleRate = 1000;
			end

			[freqTouch, freqBase] = N.alignFreq('touch', interval, freqInterval, sampleRate);			
			[freqRelease, ~] = N.alignFreq('release', interval, freqInterval, sampleRate);

			hTouch = ttest2(freqTouch, freqBase, 'Alpha', 0.01);
			hRelease = ttest2(freqRelease, freqBase, 'Alpha', 0.01);

			t = interval(1):1/sampleRate:interval(2);

			figure('MenuBar', 'none', 'ToolBar', 'none', 'units', 'normalized', 'outerposition', [0 0.1 1 0.8]);
			subplot(3,1,1)
			h = shadedErrorBar(t, mean(freqTouch), std(freqTouch), 'r', 1); hold on;
			hBase = shadedErrorBar(t, mean(freqBase), std(freqBase),'k', 1); 
			hStar = scatter(t(find(hTouch)), mean(freqTouch(:, find(hTouch))), 1, '*'); hold off;
			ylabel('Firing frequency (Hz)'); xlabel('Time (s)');
			title(['Electrode ', num2str(N.Electrode), ' Channel ', num2str(N.Channel),' Unit', num2str(N.Unit),' (Touch)']);
			legend([h.mainLine, hBase.mainLine, hStar], {'Trial', 'Base', 'p < 0.01'});

			subplot(3,1,2)
			h = shadedErrorBar(t, mean(freqRelease), std(freqRelease), 'r', 1); hold on;
			hBase = shadedErrorBar(t, mean(freqBase), std(freqBase),'k', 1); 
			hStar = scatter(t(find(hRelease)), mean(freqRelease(:, find(hRelease))), 1, '*'); hold off;
			ylabel('Firing frequency (Hz)'); xlabel('Time (s)');
			title(['Electrode ', num2str(N.Electrode), ' Channel ', num2str(N.Channel),' Unit', num2str(N.Unit),' (Release)']);
			legend([h.mainLine, hBase.mainLine, hStar], {'Trial', 'Base', 'p < 0.01'});
		end

		function [spikeTimesSpliced, MoCapSpliced, timeSpliced] = splice(N, alignMode, interval)
			if nargin < 2
				alignMode = 'touch';
			end
			if nargin < 3
				interval = N.MC.Interval;
			end

			sampleRate = N.MC.SampleRate;
			spikeTimes = N.SpikeTimes;

			switch lower(alignMode)
				case 'touch'
					centers = N.ObjTouchTimes;
					centersMoCap = repmat(abs(N.MC.Interval(1)), size(centers));
				case 'release'
					centers = N.ObjReleaseTimes;
					centersMoCap = abs(N.MC.Interval(1)) + (N.ObjReleaseTimes - N.ObjTouchTimes);
			end

			spikeTimesSpliced = [];
			timeSpliced = [];
			MoCapSpliced = N.MC.splice(centersMoCap, interval);

			for iTrial = 1:length(centers)
				center 	= centers(iTrial);
				left 	= center + interval(1);
				right 	= center + interval(2);

				spikeTimesThisTrial = spikeTimes(spikeTimes>=left & spikeTimes <= right);
				spikeTimesSpliced = horzcat(spikeTimesSpliced, spikeTimesThisTrial); 
				timeSpliced = horzcat(timeSpliced, left:(1/sampleRate):right);
			end
		end
	end
end

