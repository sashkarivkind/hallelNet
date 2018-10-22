%load('T_mats.mat');
addpath('../misc/')
runname = 'deleteme5';
if ~isdir(runname)
    mkdir(runname)
end

fixed_param.metered_perturb_vec = [1,750];%[1,3,10,30,100,300,750];
fixed_param.upstar = 1;
% params_to_loop.sim_orig_net = 1;
% params_to_loop.save_detailed_info = 0;
% params_to_loop.k_m_out = 1;%0.5:0.05:2.1;
% params_to_loop.gamma_k_out = 1;%[2.2 2.4 2.6];
params_to_loop.manu_star=1;
params_to_loop.k_str_manu=[2,4];%[1.5:0.1:4];
params_to_loop.sighub_str_manu=0.5;%[0.5,1.5];
params_to_loop.kinhub_str_manu=10;%[4,8,12];
param_sets = prep_param_sets(params_to_loop);
for ll=1:length(param_sets);
    results{ll}=run_single_realization(mergestruct(param_sets{ll},fixed_param),run_ndx);    
    ll
end;
save([runname '/results_from_run_ndx_' num2str(run_ndx) '.mat'], 'results');
