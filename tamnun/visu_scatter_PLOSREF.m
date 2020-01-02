% temprec={}
clear yy;
figure;

% plotting options
fie='frozen_core';
sym_sigma_vec='xo+';
col_N_vec = 'bcrgbbcrgb';
loop_style=':';

sim_result_type={'sim','str_sim','gstr_sim','gfstr_sim'};
sim_result_type_name={'Scale Free','Lumped Hub','Gaussian Lumped Hub','Sparse Gaussian Lumped Hub'};
num_w_realizations = 50;
num_topology_realizations = 100;


for jj=1:length(sim_result_type)
    simres=sim_result_type{jj};
    yy.(simres)=zeros(num_w_realizations,num_topology_realizations);
    
    for w_realization_index=1:num_w_realizations;
        w_re_str=num2str(w_realization_index);
        % yy is realizations by topologies matrix
        yy.(simres)(w_realization_index,:)=(vv.([simres,w_re_str]).(fie));
    end
    
end
figure;
for jj=2:length(sim_result_type)
    simres=sim_result_type{jj};
    subplot(1,3,jj-1);
    plot(mean(yy.sim,1), mean(yy.(simres),1),'.');
    xlabel('mean frozen core SF');
    ylabel(['mean frozen core ',sim_result_type_name{jj}]);
end

    