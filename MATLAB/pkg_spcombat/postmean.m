% This script is an adaptation of Dr. J. Fortin's original source code.
% The original source code can be found at https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab

function y = postmean(g_hat ,g_bar, n,d_star, t2)
	y=(t2*n.*g_hat+d_star.*g_bar)./(t2*n+d_star);
end