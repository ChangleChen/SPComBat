% This script is an adaptation of Dr. J. Fortin's original source code.
% The original source code can be found at https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab

function y = postvar(sum2,n,a,b)
	y=(.5.*sum2+b)./(n/2+a-1);
end