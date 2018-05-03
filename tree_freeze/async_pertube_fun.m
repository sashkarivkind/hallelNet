function outstat = async_pertube_fun(W,p)

if ~isfield(p,'update_frac')
    p.update_frac = 0.1;
end
if ~isfield(p,'x_0')
    p.x_0 = randn(size(W));
end
if ~isfield(p,'frozen')
    p.frozen = zeros(size(W,1),1);
end
if ~isfield(p,'t_max')
    p.t_max = 500;
end
if ~isfield(p,'N_perturbations')
    p.N_perturbations = 100;
end
if ~isfield(p,'preturbation_frac')
    p.preturbation_frac = 0.1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation parameters and definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(W(1, :));
T_sim = round(p.t_max/p.update_frac)+1;
N_perturbations=p.N_perturbations;

% for preturbation_frac = [1/N, 0.05, 0.1 0.2]
pert_diff = zeros(1, N_perturbations);
pert_diff_fro = zeros(1, N_perturbations);
% pert_diff_2 = zeros(1, N_perturbations);
% x_0_pert = zeros(N, N_perturbations);
% x_f_p_pert = zeros(N, N_perturbations);
%     for ind_pert = 1:N_perturbations
%% initilaize  open loop varibles
% x = zeros(N, T_sim); %initilazie x varibles of open loop  model with constant W
x  = p.x_0 ; %I.C. for open  loop

% N_perturbe_nodes = round(p.preturbation_frac*N);
ind_perturbe = rand(size(x))<p.preturbation_frac;

x(ind_perturbe)  = -x(ind_perturbe) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate Dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1:T_sim
    update_mask =rand(N, N_perturbations)<p.update_frac;
    x_next = x;
    x_full_upd =  W*sign(x); %update open loop constant W model, notice this is a simple forward Euler scheme
    x_next(update_mask) =  x_full_upd(update_mask);
    x=x_next;
    dlast = sign(x_full_upd)-sign(x);
    dx0 = sign(p.x_0)-sign(x);
    c_fp=~any(dlast(:)); %reached f.p. in all perturbation scenaria.
    c_fc=~any(any(dx0(~~p.frozen,:))); %recapped the original frozen core
    c_fcb=all(all(dx0(~~p.frozen,:))); %recapped inverse frozen core
    if c_fp||c_fc||c_fcb
        break
    end;
end; % end Simulate Dynamics

%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot and save results
%%%%%%%%%%%%%%%%%%%%%%%%%%

pert_diff = sum(abs(sign(p.x_0)-sign(x)) ~= 0);
pert_diff_fro = sum(abs(sign(p.x_0(~~p.frozen,:))-sign(x(~~p.frozen, :))) ~= 0);
% pert_diff_2(ind_pert) = sum(abs(sign(p.x_0)-sign(x(:, i_fin))) ~= 0);

outstat=struct(...%'x_0_pert',x_0_pert,...
    ...%'x_f_p_pert',x_f_p_pert,...
    'pert_diff',pert_diff,...
    'pert_diff_fro',pert_diff_fro...
    ...%'pert_diff_2',pert_diff_2...
    );




