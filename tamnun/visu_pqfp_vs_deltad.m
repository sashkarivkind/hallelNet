zzz_result_struct_parser
k_max=10;
div_red=zeros(size(vv.lumped_models.sigma_hub));
for ii=1:length(div_red)
if ~mod(ii,100)
toc;
disp(ii)
tic;
end
div_red(ii)=div_d(vv.lumped_models.mean_k_str(ii),vv.lumped_models.sigma_hub(ii),1500);
end
fro_red=smooth_plot(div_red,vv.sim.frozen_core,0.05);
qfp_red=smooth_plot(div_red,vv.sim.frozen_core>0.9,0.05);
figure;plot(qfp_red.x(qfp_red.n>10),qfp_red.y(qfp_red.n>10),'linewidth',2);
xlabel('\nabla d'); ylabel('P_{qpf}');
qfpSTR_red=smooth_plot(div_red,vv.str_sim.frozen_core>0.9,0.05);
hold on;
plot(qfpSTR_red.x(qfpSTR_red.n>10),qfpSTR_red.y(qfpSTR_red.n>10),'linewidth',2);
%%
this_point=(vv.param.gamma_k_out==2.4)&(vv.param.k_m_out==1.0);
qfp_this=smooth_plot(div_red(this_point),vv.sim.frozen_core(this_point)>0.9,0.05);
figure; plot(qfp_this.x,qfp_this.y,'o')
qfpSTR_this=smooth_plot(div_red(this_point),vv.str_sim.frozen_core(this_point)>0.9,0.05);
hold on; plot(qfpSTR_this.x,qfpSTR_this.y,'o')