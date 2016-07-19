classdef MoCap < handle
	%MOCAP Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		Day
		Session
		SampleRate
		Interval
		Xs
		Ys
		Zs
		StickSize
		StickPosX
		StickPosY
		StickPosZ
		GripAperture
		HandPosX
		HandPosY
		HandPosZ
		HandVel
		DistHandObj
		DistStickChairX
		DistStickChairY
		DistStickChairZ
		DistStickChair
		DistHandStickX
		DistHandStickY
		DistHandStickZ
		DistHandStick
		HandVelStickX
		HandVelStickY
		HandVelStickZ
		HandSpeedStick
	end
	
	methods
		function MC = MoCap(MoCap_Session, actionId)
			if nargin == 1
				actionId = 1;
			end

			MC.Day 				= MoCap_Session.day;
			MC.Session 			= MoCap_Session.session;
			MC.SampleRate		= 1/MoCap_Session.MoCap_Trials(actionId).resolution;
			MC.Interval			= MoCap_Session.MoCap_Trials(actionId).interval;
			MC.Xs				= MoCap_Session.MoCap_Trials(actionId).Xs;
			MC.Ys				= MoCap_Session.MoCap_Trials(actionId).Ys;
			MC.Zs				= MoCap_Session.MoCap_Trials(actionId).Zs;
			MC.StickSize		= MoCap_Session.MoCap_Trials(actionId).StickSize;
			MC.StickPosX		= MoCap_Session.MoCap_Trials(actionId).StickPosX;
			MC.StickPosY		= MoCap_Session.MoCap_Trials(actionId).StickPosY;
			MC.StickPosZ		= MoCap_Session.MoCap_Trials(actionId).StickPosZ;
			MC.GripAperture		= MoCap_Session.MoCap_Trials(actionId).GripAperture;
			MC.HandPosX			= MoCap_Session.MoCap_Trials(actionId).HandPosX;
			MC.HandPosY			= MoCap_Session.MoCap_Trials(actionId).HandPosY;
			MC.HandPosZ			= MoCap_Session.MoCap_Trials(actionId).HandPosZ;
			MC.HandVel			= MoCap_Session.MoCap_Trials(actionId).HandVel;
			MC.DistHandObj		= MoCap_Session.MoCap_Trials(actionId).DistHandObj;
			MC.DistStickChairX	= MoCap_Session.MoCap_Trials(actionId).DistStickChairX;
			MC.DistStickChairY	= MoCap_Session.MoCap_Trials(actionId).DistStickChairY;
			MC.DistStickChairZ	= MoCap_Session.MoCap_Trials(actionId).DistStickChairZ;
			MC.DistStickChair 	= MoCap_Session.MoCap_Trials(actionId).DistStickChair;
			MC.DistHandStickX	= MC.HandPosX - MC.StickPosX;
			MC.DistHandStickY	= MC.HandPosY - MC.StickPosY;
			MC.DistHandStickZ	= MC.HandPosZ - MC.StickPosZ;
			MC.DistHandStick	= sqrt(MC.DistHandStickX.^2 + MC.DistHandStickY.^2 + MC.DistHandStickZ.^2);
			MC.HandVelStickX	= [diff(MC.DistHandStickX, 1, 2), diff(MC.DistHandStickX(:, end-1:end), 1, 2)];
			MC.HandVelStickY	= [diff(MC.DistHandStickY, 1, 2), diff(MC.DistHandStickY(:, end-1:end), 1, 2)];
			MC.HandVelStickZ	= [diff(MC.DistHandStickZ, 1, 2), diff(MC.DistHandStickZ(:, end-1:end), 1, 2)];
			MC.HandSpeedStick	= sqrt(MC.HandVelStickX.^2 + MC.HandVelStickY.^2 + MC.HandVelStickZ.^2);
		end

		function MCSpliced = splice(MC, centers, interval)
			MCSpliced.StickSize 		= spliceSingleCovariate(MC.StickSize, centers, interval, MC.SampleRate);
			MCSpliced.StickPosX 		= spliceSingleCovariate(MC.StickPosX, centers, interval, MC.SampleRate);
			MCSpliced.StickPosY 		= spliceSingleCovariate(MC.StickPosY, centers, interval, MC.SampleRate);
			MCSpliced.StickPosZ 		= spliceSingleCovariate(MC.StickPosZ, centers, interval, MC.SampleRate);
			MCSpliced.GripAperture 		= spliceSingleCovariate(MC.GripAperture, centers, interval, MC.SampleRate);
			MCSpliced.HandPosX 			= spliceSingleCovariate(MC.HandPosX, centers, interval, MC.SampleRate);
			MCSpliced.HandPosY 			= spliceSingleCovariate(MC.HandPosY, centers, interval, MC.SampleRate);
			MCSpliced.HandPosZ 			= spliceSingleCovariate(MC.HandPosZ, centers, interval, MC.SampleRate);
			MCSpliced.HandVel 			= spliceSingleCovariate(MC.HandVel, centers, interval, MC.SampleRate);
			MCSpliced.DistHandObj 		= spliceSingleCovariate(MC.DistHandObj, centers, interval, MC.SampleRate);
			MCSpliced.DistStickChairX 	= spliceSingleCovariate(MC.DistStickChairX, centers, interval, MC.SampleRate);
			MCSpliced.DistStickChairY 	= spliceSingleCovariate(MC.DistStickChairY, centers, interval, MC.SampleRate);
			MCSpliced.DistStickChairZ 	= spliceSingleCovariate(MC.DistStickChairZ, centers, interval, MC.SampleRate);
			MCSpliced.DistStickChair 	= spliceSingleCovariate(MC.DistStickChair, centers, interval, MC.SampleRate);
			MCSpliced.DistHandStickX 	= spliceSingleCovariate(MC.DistHandStickX, centers, interval, MC.SampleRate);
			MCSpliced.DistHandStickY 	= spliceSingleCovariate(MC.DistHandStickY, centers, interval, MC.SampleRate);
			MCSpliced.DistHandStickZ 	= spliceSingleCovariate(MC.DistHandStickZ, centers, interval, MC.SampleRate);
			MCSpliced.DistHandStick 	= spliceSingleCovariate(MC.DistHandStick, centers, interval, MC.SampleRate);
			MCSpliced.HandVelStickX 	= spliceSingleCovariate(MC.HandVelStickX, centers, interval, MC.SampleRate);
			MCSpliced.HandVelStickY 	= spliceSingleCovariate(MC.HandVelStickY, centers, interval, MC.SampleRate);
			MCSpliced.HandVelStickZ 	= spliceSingleCovariate(MC.HandVelStickZ, centers, interval, MC.SampleRate);
			MCSpliced.HandSpeedStick 	= spliceSingleCovariate(MC.HandSpeedStick, centers, interval, MC.SampleRate);
		end

	end
	
end

