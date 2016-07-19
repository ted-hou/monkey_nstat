function arrFlat = spliceSingleCovariate(arr, centers, interval, sampleRate)
	arrFlat = [];
	for iTrial = 1:size(arr, 1)
		arrFlat = vertcat(arrFlat, arr(iTrial, (1 + (centers(iTrial) + interval(1))*sampleRate):(1 + (centers(iTrial) + interval(2))*sampleRate)));
	end
	arrFlat = reshape(ctranspose(arrFlat), 1, numel(arrFlat));
end
