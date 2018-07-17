xxx = ceil(100*sum(clock) + 7*run_ndx);
rng(xxx);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Network parameters
%%%%%%%%%%%%%%%%%%%%%%%%%

N =1500;
%% degree distributions parameters
%gamma_k_out = 2.1 + 0.8*rand(1,1); % power of power law ditribution of scale free out degree
%k_m_out = 1 + 0.5*rand(1,1); %minimal degree of power law ditribution of scale free out degree
k_m_out = 1;
gamma_k_in = 2.2; % power of power law ditribution of scale free in
% degree -  this is relevant only if network
% topology is sf-out and sf-in
avg_k = 4.8;
%% network interaction parameters
g_w = 10; %standard diviation of random matrix non zero wights
m_w = 0; % mean of random matrix non zero wights
m_lump_vec=1:5; %m_lump nodes are lumped into a hub. m_lump_vec is an array of values m_lump assumes. to lump into the hub

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Create Interaction Matrix, W
% %%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = 1;
k = 4;

gamma_k_out = 2.1 + 0.8*rand(1,1); % power of power law ditribution of scale free out degree
W_sf_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create network topology matrix
N_W_sf = sum(sum(W_sf_top));
mean_k = mean(sum(W_sf_top, 2));

%computing empirical gamma_k_out, which is referred to as gamma_fit
a = log(flip(sum(W_sf_top)));
l = length(a);
b=log(1-[0:1/l:(1-1/l)]);
gamma_fit = -((b*a')/(a*a')-1);

for qq=1:length(m_lump_vec)
    m_lump = m_lump_vec(qq);
    sigma_hub = sqrt(sum(mean(W_sf_top(:, 1:m_lump))));
    [W_lamped_sf_top, W_str_top] = lump_net(W_sf_top, m_lump);
    mean_k_str = mean(sum(W_str_top(2:end, 2:end)));
    
    this_lumped_model=struct('sigma_hub',sigma_hub,'mean_k_str',mean_k_str,'m_lump',m_lump);
    results{ll}.lumped_models{qq}=this_lumped_model;
    this_ol_sim=sim_dyn(W,...
        struct('constr',(1:N)'<=m_lump));
    this_ol_sim.m_ol=m_lump;
    results{ll}.open_loop_sims{qq}=this_ol_sim;
end
results{ll}.original_net=struct('gamma_k_out',gamma_k_out,'k_m_out',k_m_out,...
    'mean_k', mean_k,'gamma_fit',gamma_fit);

W = sparse(N, N);
mean_k = mean(sum(W_sf_top, 2));
N_W_n_z = sum(sum(W_sf_top));
W(W_sf_top) = (g_w/(sqrt(mean_k)))*randn(N_W_n_z, 1); %randomize interaction matrix, W_int, with given topology W_top
%the variance of interaction strengths is g^2/<k>

%simulate
o=sim_dyn(W);
results{ll}.sim.frozen_core = o.frozen_core;

save([runname '/results_from_run_ndx_' num2str(run_ndx) '.mat'], 'results');







