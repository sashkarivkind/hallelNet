function results = run_single_realization(param,run_ndx)
xxx = ceil(100*sum(clock) + 7*run_ndx);
rng(xxx);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Network nominal parameters
%%%%%%%%%%%%%%%%%%%%%%%%%
%% degree distributions parameters
nom.N =1500;
nom.k_m_out = 1;
gamma_k_in = 2.2; % power of power law ditribution of scale free in
nom.avg_k = 4.8;
%% network interaction parameters
nom.g_w = 10; %standard diviation of random matrix non zero wights
nom.m_w = 0; % mean of random matrix non zero wights
nom.gamma_k_out = 2.4; % power of power law ditribution of scale free out degree
%% star network parameters
nom.m_lump=4;
%% simulation options
nom.do_upnet=0;
nom.do_ol_sim=0;

%% Assigning nominal parameters where needed
param=nom_opt_assigner(param,nom);
clear nom; % to avoid any bugs from using nominal values rather instead of the set ones.



%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Create Interaction Matrix, W
% %%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W_sf_top = createNet(param.N, 'sf' , 'binom', param.k_m_out, param.gamma_k_out, [], 'sort', 'out') ~= 0; %create network topology matrix

%% computing empirical topological parameters
%computing empirical gamma_k_out, which is referred to as gamma_fit
a = log(flip(sum(W_sf_top)));
l = length(a);
b=log(1-[0:1/l:(1-1/l)]);
gamma_fit = -((b*a')/(a*a')-1);
%other empirical parameters
N_W_sf = sum(sum(W_sf_top));
mean_k = mean(sum(W_sf_top, 2));

%% creating random weighs realization
W = sparse(param.N, param.N);
N_W_n_z = sum(sum(W_sf_top));
W(W_sf_top) = (param.g_w/(sqrt(mean_k)))*randn(N_W_n_z, 1); %randomize interaction matrix, W_int, with given topology W_top
%the variance of interaction strengths is g^2/<k>


m_lump_vec = param.m_lump;%todo
for qq=1:length(m_lump_vec)
    m_lump = m_lump_vec(qq);%todo
    sigma_hub = sqrt(sum(mean(W_sf_top(:, 1:m_lump))));
    [W_lamped_sf_top, W_str_top] = lump_net(W_sf_top, m_lump);
    mean_k_str = mean(sum(W_str_top(2:end, 2:end)));
    
    if param.do_ol_sim
        this_ol_sim=sim_dyn(W,...
            struct('constr',(1:N)'<=m_lump));
        this_ol_sim.m_ol=m_lump;
        results.open_loop_sims{qq}=this_ol_sim;
    end
end
results.original_net=struct('gamma_k_out',param.gamma_k_out,'k_m_out',param.k_m_out,... %todo - fix redundant save
    'mean_k', mean_k,'gamma_fit',gamma_fit);

%simulate
results.sim = sim_dyn(W);

    this_lumped_model=struct('sigma_hub',sigma_hub,'mean_k_str',mean_k_str,'m_lump',m_lump);
    results.lumped_models{qq}=this_lumped_model;

if param.do_upnet
    results.upnet_sim=sim_dyn(diag(sign(sum(W,2)))*W); %this is a network with a guaranteed fixed point at s=(1,1,1,1,1,1,1....1)
end


results.param = param;


