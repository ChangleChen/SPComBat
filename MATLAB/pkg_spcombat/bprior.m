% This script is an adaptation of Dr. J. Fortin's original source code.
% The original source code can be found at https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab

function y = bprior(gamma_hat)
	m = mean(gamma_hat);
  	s2 = var(gamma_hat);
  	y=(m*s2+m^3)/s2;
end