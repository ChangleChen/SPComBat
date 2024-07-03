% This script is an adaptation of Dr. J. Fortin's original source code.
% The original source code can be found at https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab

function y = aprior(gamma_hat)
	m = mean(gamma_hat);
  	s2 = var(gamma_hat);
  	y=(2*s2+m^2)/s2;
end