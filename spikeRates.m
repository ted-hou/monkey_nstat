load('workspace.mat')

numCells = 40;
spikeRate = zeros(1, numCells);

% NstCollObj: Create nstColl object containing all neurons
for iCell = 1:numCells
	ThisNeuron = Neuron(NeuronsDB,MoCap_Sessions,iCell + 25, 1);
	[spikeTimes, Mocap, time] = ThisNeuron.splice('Touch', [-.8, .4]);
	spikeRate(iCell) = numel(spikeTimes)/(1.2*20);
end

find(spikeRate<prctile(spikeRate,75))