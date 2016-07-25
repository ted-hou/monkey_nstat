%% plotSpikeLocation: Plot spiking location in predictor space (1-3 predictors)
function plotSpikeLocation(Neurons, covNames)

nCov = length(covNames);

for iCell = 1:length(Neurons)
	[spikeTimes, Mocap, time] = Neurons(iCell).N.splice();

	timestamps = [];
	% Convert timestamps to logical indexing
	for iSpike = 1:length(spikeTimes)
		[~, iTime] = min(abs(time - spikeTimes(iSpike)));
		timestamps = horzcat(timestamps, iTime);
	end

	covs = [];
	covsFull = [];
	for iCov = 1:nCov
		thisCov = Mocap.(covNames{iCov});
		covs = vertcat(covs, thisCov(timestamps));
		covsFull = vertcat(covsFull, thisCov);
	end

	figure(iCell)
	switch nCov
		case 1
			hist(covs(1, :));
			xlabel(covNames{1});
			ylabel('Spike Count');
			filename = ['spikeLocation_', covNames{1}];
		case 2
			scatter(covs(1, :), covs(2, :), 100, 'r.'); hold on;
			plot(covsFull(1, :), covsFull(2, :), '-.k', 'LineWidth', 0.01); hold off;
			xlabel(covNames{1});
			ylabel(covNames{2});
			legend('Spikes', 'Trajectory');
			xlim([min(Mocap.(covNames{1})), max(Mocap.(covNames{1}))]);
			ylim([min(Mocap.(covNames{2})), max(Mocap.(covNames{2}))]);
			axis equal;
			filename = ['spikeLocation_', covNames{1}, '_', covNames{2}];
		case 3
			scatter3(covs(1, :), covs(2, :), covs(3, :), 100, 'r.'); hold on;
			plot3(covsFull(1, :), covsFull(2, :), covsFull(3, :), '-.k', 'LineWidth', 0.01); hold off;
			xlabel(covNames{1});
			ylabel(covNames{2});
			zlabel(covNames{3});
			legend('Spikes', 'Trajectory');
			xlim([min(Mocap.(covNames{1})), max(Mocap.(covNames{1}))]);
			ylim([min(Mocap.(covNames{2})), max(Mocap.(covNames{2}))]);
			zlim([min(Mocap.(covNames{3})), max(Mocap.(covNames{3}))]);
			axis equal;
			filename = ['spikeLocation_', covNames{1}, '_', covNames{2}, '_', covNames{3}];
	end
    saveas(gcf,[filename, '_', num2str(iCell), '.jpg']);
end

% plotSpikeLocation(Neurons, {'GripAperture'})
% plotSpikeLocation(Neurons, {'StickPosX','StickPosY','StickPosZ'})
% plotSpikeLocation(Neurons, {'HandPosX','HandPosY','HandPosZ'})
% plotSpikeLocation(Neurons, {'HandVel'})
% plotSpikeLocation(Neurons, {'StickSize'})
% plotSpikeLocation(Neurons, {'DistStickChair'})
% plotSpikeLocation(Neurons, {'DistStickChairX', 'DistStickChairY', 'DistStickChairZ'})