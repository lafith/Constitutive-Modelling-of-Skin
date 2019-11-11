function U = OF_exp_regr(c)
global x y 

% try coefficients
y2 = c(1) * exp(c(2) * x); 

% try to match original data, and return difference
U = norm(y2 - y, 1);