%load('T_mats.mat');
addpath('../misc/')
runname = 'default_run_name';
if ~isdir(runname)
    mkdir(runname)
end
N_cpu_runs = 1; %Number of runs per CPU

for run_ndx = (N_cpu_runs*(cpu_ind-1)+1):(N_cpu_runs*cpu_ind) 
   for ll=1:100;
       run_sf_binom;
	ll
   end;
end;