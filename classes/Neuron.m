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
					cellId = 1;
					actionId = 1;
				case 3
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

		function spikeFreqAligned = alignFreq(N, alignMode, interval, freqInterval, sampleRate)
			switch nargin
				case 2
					interval = [-3, 4];
					freqInterval = [-0.5, 0.5];
					sampleRate = 1000;
				case 3
					freqInterval = [-0.5, 0.5];
					sampleRate = 1000;
				case 4
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

			freq = zeros(1, N.SpikeTimes(end)*sampleRate);
			for i = 1:N.SpikeTimes(end)*sampleRate
				freq(i) = sum(N.SpikeTimes >= i/sampleRate + freqInterval(1) & N.SpikeTimes <= i/sampleRate + freqInterval(2))/(freqInterval(2) - freqInterval(1));
			end

			spikeFreqAligned = [];

			for iTrial = 1:length(centers);
				center 	= centers(iTrial);
				left 	= center + interval(1);
				right 	= center + interval(2);

				freqThisTrial = freq(left*sampleRate:right*sampleRate);
				spikeFreqAligned = vertcat(spikeFreqAligned, freqThisTrial); 
			end

		end

	end
	
end

