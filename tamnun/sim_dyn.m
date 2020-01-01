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
nom.tfro = 200; % time for node to be frozen to be included in frozen core
nom.tauto = 200; %time for which autocorrelation is computed
nom.do_autocorr = 0;

opt=nom_opt_assigner(opt,nom);
clear nom; % to avoid any bugs from using nominal values rather instead of the set ones.

T_sim = round(opt.t_max/opt.update_frac)+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate Dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = NaN(N, T_sim); %initilazie x varibles of open loop  model with constant W
x(: , 1)  = opt.x0;
T_conv=-1;
for ii = 1:T_sim-1
    up_date_nodes = randperm (N, round(N*opt.update_frac));
    x(:, ii+1) = x(:,ii);
    s_eff = sign(x(:, ii));
    s_eff(opt.constr~=0) = opt.constr(opt.constr~=0); % impose constraints
    x_all = W*s_eff; %update open loop constant W model, notice this is a simple forward Euler scheme
    s_all = sign(x_all);
    if (all(s_all(opt.constr==0) == s_eff(opt.constr==0)))&&T_conv<0
        T_conv=ii;
    end
    x(up_date_nodes, ii+1) =  x_all(up_date_nodes);
end; % end Simulate Dynamics

l = opt.tfro/opt.update_frac;
X = x(:, T_sim-1)*ones(1, l);

B =  0.5*abs(sign(X)- sign(x(:, (end-3-l):(end-4))));%note this is l, (small L), not 1
D = sum(B, 2);
o.frozen_core = sum(D==0)/N;
o.final_dist_from_ones = mean(s_eff~=1);
o.T_conv=T_conv;
if opt.do_autocorr
    o.autocorr =1/N* sign(x(:, (end-3-l):(end-4)))' * sign(x(:, (end-3-l):(end-4)));
end