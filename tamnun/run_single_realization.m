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
nom.sim_orig_net=0;
nom.do_upnet=0;
nom.do_ol_sim=0;
nom.do_str_sim=1;
nom.do_str_ol_sim=1;
nom.save_detailed_info=0;
nom.k_lump_max = 10;
nom.upstar = 0;
nom.manu_star = 0;
nom.iterate_random_ic_sim=0;
nom.metered_perturb_vec=[];
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
    if param.manu_star
        W_str_top=1.0*(rand(param.N)<param.k_str_manu/param.N);
        W_str_top(:,1)=param.sighub_str_manu;
        W_str_top(1,:)=rand(param.N,1)<param.kinhub_str_manu/param.N;
    else
        [W_lumped_sf_top, W_str_top] = lump_net(W_sf_top, m_lump);
    end
    mean_k_str = mean(sum(W_str_top(2:end, 2:end)));
    k_in_hub = sum(W_str_top(1, :)~=0);
    results.(['lumped_models', num2str(qq)])=struct('sigma_hub',sigma_hub,'mean_k_str',mean_k_str,'m_lump',m_lump,'k_in_hub',k_in_hub);
    if param.save_detailed_info
        results.(['lumped_models', num2str(qq)]).detailed_star_info = create_detailed_star_info(W_sf_top,m_lump,param.k_lump_max);
    end
    W_str = sparse(W_str_top.*randn(size(W_str_top)));
    if param.upstar
        W_str=diag(sign(sum(W_str,2)))*W_str;
    end
    if param.do_str_sim
        results.(['str_sim', num2str(qq)])=sim_dyn(W_str);
    end
    for ic_index = 1:param.iterate_random_ic_sim
        results.(['str_sim_ic', num2str(qq),'_',num2str(ic_index)])=sim_dyn(W_str);
    end
    
    
    if param.do_str_ol_sim
        results.(['str_ol_sim', num2str(qq)])=sim_dyn(W_str,struct('constr',(1:size(W_str,1))'==1));
    end
    if param.do_ol_sim
        this_ol_sim=sim_dyn(W,...
            struct('constr',(1:param.N)'<=m_lump));
        this_ol_sim.m_ol=m_lump;
        results.(['open_loop_sims', num2str(qq)])=this_ol_sim;
    end
    
    if ~isempty(param.metered_perturb_vec)
        for pert_index = 1:length(param.metered_perturb_vec)
            x0=ones(param.N,1);
            x0(1+randperm(param.N-1,param.metered_perturb_vec(pert_index)))=-1;
            simopt=struct('x0',x0);
            results.(['str_sim_cl_metered', num2str(qq),'_',num2str(pert_index)])=sim_dyn(W_str,simopt);
            simopt.constr=(1:size(W_str,1))'==1;
            results.(['str_sim_ol_metered', num2str(qq),'_',num2str(pert_index)])=sim_dyn(W_str,simopt);
        end
    end
end

results.original_net=struct('gamma_k_out',param.gamma_k_out,'k_m_out',param.k_m_out,... %todo - fix redundant save
    'mean_k', mean_k,'gamma_fit',gamma_fit,'xxx',xxx);
results.param = param;

%simulate
if param.sim_orig_net
    results.sim = sim_dyn(W);
end

if param.do_upnet
    results.upnet_sim=sim_dyn(diag(sign(sum(W,2)))*W); %this is a network with a guaranteed fixed point at s=(1,1,1,1,1,1,1....1)
end




