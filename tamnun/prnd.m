function f = prnd(a, x_m, m, n)  %random number ganerator from pareto dist (a*x_m^a)/(x^(a+1)) with support [x_m, inf]

f = gprnd(1./a,x_m./a,x_m, m, n);

