function o=sim_dyn(W,opt)
N=size(W,1);
if nargin < 2
    opt = struct();
end
%%%%%%%%%%%%%%
%% Default parameters
%%%%%%%%%%%%%%
nom.update_frac = 0.1;
nom.t_int = 0;  %start simulation at t_int
nom.t_max = 1000;  % if network does not converge end simulation at t=t_max
nom.x0 = randn(N , 1) ; %I.C. for open  loop
nom.constr=zeros(N,1);

opt=nom_opt_assigner(opt,nom);


T_sim = round(opt.t_max/opt.update_frac)+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate Dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = NaN(N, T_sim); %initilazie x varibles of open loop  model with constant W
x(: , 1)  = opt.x0;

for ii = 1:T_sim-1
    up_date_nodes = randperm (N, round(N*opt.update_frac));
    x(:, ii+1) = x(:,ii);
    s_eff = sign(x(:, ii));
    s_eff(opt.constr~=0) = opt.constr(opt.constr~=0); % impose constraints
    x(up_date_nodes, ii+1) =  W(up_date_nodes, :)*s_eff; %update open loop constant W model, notice this is a simple forward Eular scheme
    
end; % end Simulate Dynamics

l = 200/opt.update_frac;
X = x(:, T_sim-1)*ones(1, l);

B =  0.5*abs(sign(X)- sign(x(:, (end-3-l):(end-4))));
D = sum(B, 2);
o.frozen_core = sum(D==0)/N;