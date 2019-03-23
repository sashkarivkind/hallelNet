%load('T_mats.mat');
addpath('../misc/')
runname = 'sweep_sigma_fixk_star';
if ~isdir(runname)
    mkdir(runname)
end

fixed_param.do_gstr_sim=0;
fixed_param.do_gstr_ol_sim=0;
fixed_param.do_str_sim=1;
fixed_param.do_str_ol_sim=1;
%fixed_param.metered_perturb_vec = [1,3,10,30,100,300,750];
%fixed_param.upstar = 1
%fixed_param.sim_orig_net = 1;
% params_to_loop.save_detailed_info = 0;
params_to_loop.N = [1500];%[300,1000, 1500, 3000, 5000, 7000, 10000];
params_to_loop.k_m_out = 1;%0.5:0.05:2.1;
params_to_loop.gamma_k_out = [2.2 2.4 2.6];
params_to_loop.manu_star=1;
params_to_loop.k_str_manu=(2.0:1:7);%2.6:0.05:3.4;%[1.5:0.1:4];
params_to_loop.sighub_str_manu=0:0.05:3;%[0.0001, 0.5:0.5:1.5];%1.5;%0.5:0.5:1;%[0.5,1.5];
params_to_loop.kinhub_str_manu=20;%[12,1000];%[4,8,12];

param_sets = prep_param_sets(params_to_loop);
for ll=1:length(param_sets);
    results{ll}=run_single_realization(mergestruct(param_sets{ll},fixed_param),run_ndx);    
    ll
end;
save([runname '/results_from_run_ndx_' num2str(run_ndx) '.mat'], 'results');
