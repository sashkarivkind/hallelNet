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
nom.do_gstr_sim=1;
nom.do_gstr_ol_sim=1;
nom.do_gfstr_sim=1;
nom.do_gfstr_ol_sim=1;
nom.save_detailed_info=0;
nom.k_lump_max = 10;
nom.upstar = 0;
nom.manu_star = 0;
nom.number_of_weight_realizations = 1;
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

%% creating random weighs realization: MOVED DOWN
N_W_n_z = sum(sum(W_sf_top));
%the variance of interaction strengths is g^2/<k>


m_lump_vec = param.m_lump;%todo
%for qq=1:length(m_lump_vec)
% Loop over m is discarded.
% Index qq that was running over m_lump_vec is now
% used to count realizations of random gaussian weights.
% In places which are out of the loop on random gaussian weights a variable
% qq_legacy is used. It is forced to 1:
qq_legacy = 1;
m_lump = m_lump_vec(qq_legacy);%todo
sigma_hub = sqrt(sum(mean(W_sf_top(:, 1:m_lump))));
f = mean(sum(W_sf_top(:, 1:m_lump),2)>1e-6);

if param.manu_star
    %setting star network manually using:
    %!!!!
    %!!!!! NOTE: sigma^2 of hub is defined not as in the paper. Here it
    %is the total variance of the hub's outputs with zeros included.
    %!!!!
    %In paper it is variance taken only across non-zero entries.
    %sighub_str_manu - sigma hub
    %k_str_manu - bulk k
    %f_str_manu - hub sparseness
    W_str_top=1.0*(rand(param.N)<param.k_str_manu/param.N);
    W_str_top(:,1)=0;
    W_str_top(1:min(round(param.f_str_manu*param.N),size(W_str_top,1)),1)=param.sighub_str_manu*sqrt(1/param.f_str_manu);
    W_str_top(1,:)=rand(param.N,1)<param.kinhub_str_manu/param.N;
else
    %lumped hub that perserves detailed connectivity patterns of hubs it was lumped from
    [~, W_str_top] = lump_net(W_sf_top, m_lump);
end
mean_k_str = mean(sum(W_str_top(2:end, 2:end)));
k_in_hub = sum(W_str_top(1, :)~=0);
%% taking care of gaussian hub
W_gstr_top = W_str_top;
W_gstr_top(:,1)=sigma_hub;
W_gstr_top(1,1)=0;
%% taking care of sparse gaussian hub (the one that we used in paper)
W_gfstr_top = W_str_top;
W_gfstr_top(:,1)=0;
W_gfstr_top(1:min(round(f*param.N),size(W_str_top,1)),1)=sigma_hub*sqrt(1/f);
W_gfstr_top(1,1)=0;
%% recording details about the lumped model
results.(['lumped_models', num2str(qq_legacy)])=struct('sigma_hub',sigma_hub,'mean_k_str',mean_k_str,'m_lump',m_lump,'k_in_hub',k_in_hub,'f',f);
if param.save_detailed_info
    results.(['lumped_models', num2str(qq_legacy)]).detailed_star_info = create_detailed_star_info(W_sf_top,m_lump,param.k_lump_max);
end
%% done with topology related stuff, now applying actual  realization random weights
for qq=1:param.number_of_weight_realizations
    W = sparse(param.N, param.N);
    W(W_sf_top) = (param.g_w/(sqrt(mean_k)))*randn(N_W_n_z, 1); %randomize interaction matrix, W_int, with given topology W_top
    W_str = sparse(W_str_top.*randn(size(W_str_top)));
    W_gstr = sparse(W_gstr_top.*randn(size(W_gstr_top)));
    W_gfstr = sparse(W_gfstr_top.*randn(size(W_gfstr_top)));
    
    
    if param.upstar
        %this flag enforces a fixed point at s=11111111....1
        %implemented for "realistic star", i.e. fig. 4A, only
        W_str=diag(sign(sum(W_str,2)))*W_str;
    end
    
    %simulate the original network
    if param.sim_orig_net
        results.(['sim', num2str(qq)]) = sim_dyn(W);
    end
    
    %Realistic star (fig 4A)
    if param.do_str_sim
        results.(['str_sim', num2str(qq)])=sim_dyn(W_str);
    end
    
    %Gaussian dense hub (legacy, not in use):
    if param.do_gstr_sim
        results.(['gstr_sim', num2str(qq)])=sim_dyn(W_gstr);
    end
    
    %Gaussian sparse hub:
    if param.do_gfstr_sim
        results.(['gfstr_sim', num2str(qq)])=sim_dyn(W_gfstr);
    end
    
    
    for ic_index = 1:param.iterate_random_ic_sim
        % option for trying more than one initial condition on the ORIGINAL network
        results.(['str_sim_ic', num2str(qq),'_',num2str(ic_index)])=sim_dyn(W_str);
    end
    
    if param.do_str_ol_sim
        % the realistic star (as for Aug. 2019 used in figure 4A)
        results.(['str_ol_sim', num2str(qq)])=sim_dyn(W_str,struct('constr',(1:size(W_str,1))'==1));
    end
    
    if param.do_gstr_ol_sim
        % the dense Gaussian star, NOT used  paper
        results.(['gstr_ol_sim', num2str(qq)])=sim_dyn(W_gstr,struct('constr',(1:size(W_gstr,1))'==1));
    end
    
    if param.do_gfstr_ol_sim
        % the star used in paper (sparse Gaussian)
        results.(['gfstr_ol_sim', num2str(qq)])=sim_dyn(W_gfstr,struct('constr',(1:size(W_gfstr,1))'==1));
    end
    
    if param.do_ol_sim
        this_ol_sim=sim_dyn(W,...
            struct('constr',(1:param.N)'<=m_lump));
        this_ol_sim.m_ol=m_lump; %option for sweeping m, currently discarded
        results.(['open_loop_sims', num2str(qq)])=this_ol_sim;
    end
    
    if ~isempty(param.metered_perturb_vec)
        %This option was not maintained for a long time. Use with care!
        %requires upstar option enabled. Then enables controlled
        %perturbation to the fixed point state (which is guaranteed at
        %s=1\forall s, (by param.upstar)
        for pert_index = 1:length(param.metered_perturb_vec)
            x0=ones(param.N,1);
            x0(1+randperm(param.N-1,param.metered_perturb_vec(pert_index)))=-1;
            simopt=struct('x0',x0);
            results.(['str_sim_cl_metered', num2str(qq),'_',num2str(pert_index)])=sim_dyn(W_str,simopt);
            simopt.constr=(1:size(W_str,1))'==1;
            results.(['str_sim_ol_metered', num2str(qq),'_',num2str(pert_index)])=sim_dyn(W_str,simopt);
        end
    end
end %qq - this index was originally representing

%% Simulation of the original (Scale free) network and of its variants
results.original_net=struct('gamma_k_out',param.gamma_k_out,'k_m_out',param.k_m_out,... %todo - fix redundant save
    'mean_k', mean_k,'gamma_fit',gamma_fit,'xxx',xxx);
results.param = param;

%simulate the original network
%to support legacy
if param.sim_orig_net
    results.sim = results.sim1;
end


if param.do_upnet
    %this is a network with a guaranteed fixed point at s=(1,1,1,1,1,1,1....1)
    %note that this is the original Scale-Free network, NOT a "star" (i.e.
    %lumped hub)approximation!
    results.upnet_sim=sim_dyn(diag(sign(sum(W,2)))*W);
end




