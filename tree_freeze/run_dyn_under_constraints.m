function s= run_dyn_under_constraints(W,b,constr,steps,s_ini)
% run network dynamics with some nodes being constrained
if nargin<5
    s = sign(rand(size(b))-0.5);
else
    s = s_ini;
end

for t=0:steps
    s_eff = s;
    s_eff(constr~=0) = constr(constr~=0); % impose constraints
    s = sign(W*s_eff + b);
end
    