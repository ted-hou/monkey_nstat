function mergeJpegs(iCell, delays)
if nargin < 2
	delays = [400, 200, 0, -200, -400];
end

imgdown = [];

img_freq = imresize(imread(['nStat_', num2str(iCell), '_freq.jpg']), [NaN, 1920]);

for iDelay = 1:length(delays)
	fname = ['nStat_', num2str(iCell), '_Release_', num2str(delays(iDelay)), 'ms.jpg'];
	if exist(fname, 'file')
		img_touch 	= imresize(imread(fname), [NaN, 1920/length(delays)]);
	else
		img_touch 	= uint8(255*ones([round(288*5/length(delays)), 1920/length(delays), 3]));
	end
	fname = ['nStat_', num2str(iCell), '_Touch_', num2str(delays(iDelay)), 'ms.jpg'];
	if exist(fname, 'file')
		img_release = imresize(imread(fname), [NaN, 1920/length(delays)]);
	else
		img_release = uint8(255*ones([round(288*5/length(delays)), 1920/length(delays), 3]));
	end

	imgdown = horzcat(imgdown, vertcat(img_touch, img_release));
end

imgout = vertcat(img_freq, imgdown);

imwrite(imgout, ['merged_', num2str(iCell), '.jpg']);