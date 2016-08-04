testmode = 'Touch'; % Can also be 'Release'
covDelay = 0.1; % Covariate delay in seconds
percentile = 0; % 0~100, This percentile (neurons with lowest firing rates are discarded) 
plotType = 'Full'; % Can be 'Full', 'KS'

numCells = 40;
spikeRate = zeros(1, numCells);

switch testmode
	case 'Touch'
		interval = [-1, 0.4];
	case 'Release'
		interval = [-.4, .5];
end
iCell = 1;
covName = 'GripAperture';

ThisNeuron = Neuron(NeuronsDB,MoCap_Sessions,iCell + 25, 1);

for covDelay = 0
	[spikeTimes0, Mocap0, time0] = ThisNeuron.splice(testmode, interval, covDelay);
end

for covDelay = 0.1
	[spikeTimesPos, MocapPos, timePos] = ThisNeuron.splice(testmode, interval, covDelay);
end

for covDelay = -0.1
	[spikeTimesNeg, MocapNeg, timeNeg] = ThisNeuron.splice(testmode, interval, covDelay);
end
clear covDelay iCell interval numCells percetile plotType spikeRate testmode ThisNeuron

figure
plot(time0, Mocap0.(covName), 'k'), hold on
plot(timePos, MocapPos.(covName), 'g')
plot(timeNeg, MocapNeg.(covName), 'r'), hold off
legend('0 ms', '+100 ms', '-100 ms')
xlabel('Time (s)')
ylabel(covName)
title('Time-shifted MoCap Data')

figure
plot(spikeTimes0, 'k'), hold on
plot(spikeTimesPos, 'g')
plot(spikeTimesNeg, 'r'), hold off
legend('0 ms', '+100 ms', '-100 ms')
ylabel('Spike Time (s)')
title('Time-shifted SpikeTime Data')
