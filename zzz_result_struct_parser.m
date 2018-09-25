% res_path='default_run_name_dehub0/default_run_name/';
%res_path='default_run_name_N1500/';
%res_path='up_run_name_N1500_km0p5_gamma_2p1/up_run_name_N1500_km0p5_gamma_2p1/'
% res_path='up_run_name_N1500/up_run_name_N1500/'
res_path='grid_star_nwk/grid_star_nwk/'
res_files=dir([res_path,'*.mat']);
all_results = {};
for rr=1:length(res_files)
    load([res_path res_files(rr).name]);
    all_results = {all_results{:} results{:}};
end
all_res_mat = cell2mat(all_results);

% uu=[all_res_mat.open_loop_sims];
% muu = [uu{:}];
% fc=[muu.frozen_core];
% mol=[muu.m_ol];
% fc_mat=reshape(fc,max(mol)-min(mol)+1,sum(mol==min(mol)));
%
% uu=[all_res_mat.closed_loop_dehub_sims];
% muu = [uu{:}];
% fc_dehub=[muu.frozen_core];
% m_dehub=[muu.m_dehub];
% fc_dehub_mat=reshape(fc_dehub,max(m_dehub)-min(m_dehub)+1,sum(m_dehub==min(m_dehub)));
%
% figure;
% scatter(mol,fc,'.');
% figure;
% binning=0:0.05:1;
% hold on;
% for ii=min(mol):max(mol)
%     stem(binning,hist(fc(mol==ii),binning)/sum(mol==ii));
% %     set(gco,'alpha',0.5,'facecolor',4);
% end

% fc_cl_p=[all_res_mat.sim];
% fc_cl=[fc_cl_p.frozen_core];
%
% orig_net_p=[all_res_mat.original_net];
% gamma_fit=[orig_net_p.gamma_fit];
% gamma_k_out=[orig_net_p.gamma_k_out];
%
% lumped_net_p=[all_res_mat.lumped_models];
% lumped_net_p=[lumped_net_p{:}];
% sigma_hub=[lumped_net_p.sigma_hub];
% mean_k_str=[lumped_net_p.mean_k_str];
% m_lump=[lumped_net_p.m_lump];

ff=fields(all_res_mat);

for ii=1:length(ff)
    qq=all_res_mat.(ff{ii});
    if iscell(qq)
        qq=cell2mat([all_res_mat.(ff{ii})]);
        disp(ff{ii})
    else 
        qq=[all_res_mat.(ff{ii})];
    end
    vv.(ff{ii})=organize_cell_of_structs(qq);   
end
% sim_p =  organize_cell_of_structs([all_res_mat.sim]);
% param_p =  organize_cell_of_structs([all_res_mat.param]);
% sim_str =  organize_cell_of_structs([all_res_mat.str_sim]);


% frozen_core=[sim_p.frozen_core];

% upnet_sim_p = organize_cell_of_structs([all_res_mat.upnet_sim]);
%frozen_core=[upnet_sim_p.frozen_core];
