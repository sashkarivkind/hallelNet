%load('T_mats.mat');
addpath('../misc/')
runname = 'fig4_repro_try1';
if ~isdir(runname)
    mkdir(runname)
end

params_to_loop.save_detailed_info = 0;
params_to_loop.k_m_out = 1.0;
params_to_loop.N = 1500;
params_to_loop.number_of_weight_realizations=50;
params_to_loop.gamma_k_out = [2.4]; %[2.2 2.4 2.6];
params_to_loop.sim_orig_net = 1;

params_to_loop.manu_star=0;
% params_to_loop.k_str_manu=[1.5:0.1:6];
% params_to_loop.f_str_manu=[0.25,0.5];
% params_to_loop.sighub_str_manu=[0.5,1.5];
params_to_loop.do_ol_sim=0;
params_to_loop.do_str_sim=1;
params_to_loop.do_str_ol_sim=0;
params_to_loop.do_gstr_sim=1;
params_to_loop.do_gstr_ol_sim=0;
params_to_loop.do_gfstr_sim=1;
params_to_loop.do_gfstr_ol_sim=0;
% params_to_loop.kinhub_str_manu=20;%[4,8,12];
param_sets = prep_param_sets(params_to_loop);

for ll=1:length(param_sets);   
    results{ll}=run_single_realization(param_sets{ll},run_ndx);    
    ll
end;
save([runname '/results_from_run_ndx_' num2str(run_ndx) '.mat'], 'results','-v7.3');
