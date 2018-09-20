%load('T_mats.mat');
addpath('../misc/')
runname = 'dddd';
if ~isdir(runname)
    mkdir(runname)
end

params_to_loop.k_m_out = 0.5:0.05:1.1;
params_to_loop.gamma_k_out = [2.2 2.4 2.6];

param_sets = prep_param_sets(params_to_loop);

for ll=1:length(param_sets);
    results{ll}=run_single_realization(param_sets{ll},run_ndx);    
    ll
end;
save([runname '/results_from_run_ndx_' num2str(run_ndx) '.mat'], 'results');
