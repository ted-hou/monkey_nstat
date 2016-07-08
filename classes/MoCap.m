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
		end

		function MCSpliced = splice(MC)
			MCSpliced.StickSize = reshape(ctranspose(MC.StickSize), 1, numel(MC.StickSize));
			MCSpliced.StickPosX = reshape(ctranspose(MC.StickPosX), 1, numel(MC.StickPosX));
			MCSpliced.StickPosY = reshape(ctranspose(MC.StickPosY), 1, numel(MC.StickPosY));
			MCSpliced.StickPosZ = reshape(ctranspose(MC.StickPosZ), 1, numel(MC.StickPosZ));
			MCSpliced.GripAperture = reshape(ctranspose(MC.GripAperture), 1, numel(MC.GripAperture));
			MCSpliced.HandPosX = reshape(ctranspose(MC.HandPosX), 1, numel(MC.HandPosX));
			MCSpliced.HandPosY = reshape(ctranspose(MC.HandPosY), 1, numel(MC.HandPosY));
			MCSpliced.HandPosZ = reshape(ctranspose(MC.HandPosZ), 1, numel(MC.HandPosZ));
			MCSpliced.HandVel = reshape(ctranspose(MC.HandVel), 1, numel(MC.HandVel));
			MCSpliced.DistHandObj = reshape(ctranspose(MC.DistHandObj), 1, numel(MC.DistHandObj));
			MCSpliced.DistStickChairX = reshape(ctranspose(MC.DistStickChairX), 1, numel(MC.DistStickChairX));
			MCSpliced.DistStickChairY = reshape(ctranspose(MC.DistStickChairY), 1, numel(MC.DistStickChairY));
			MCSpliced.DistStickChairZ = reshape(ctranspose(MC.DistStickChairZ), 1, numel(MC.DistStickChairZ));
			MCSpliced.DistStickChair = reshape(ctranspose(MC.DistStickChair), 1, numel(MC.DistStickChair));
		end
	end
	
end

