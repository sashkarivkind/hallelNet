% figure; 
epsilon=1e-6;
ref=400;
mks=2;
run_prefix = 'core_over_m_v1_';
cc='rgbm'
ss='d*+xo'
N_vec=[1000, 2000, 4000];
gamma_k_out_vec = 2.0:0.2:2.4;
for ii=1:length(N_vec)
for jj=1:length(gamma_k_out_vec)
N=N_vec(ii);
gamma_k_out= gamma_k_out_vec(jj);
run_name = [run_prefix , 'N_' , num2str(N) , '_gamma_k_out_' ,num2str(gamma_k_out)];
load([run_name,'.mat']);
ccss=[cc(ii),ss(jj),'-'];
m_mat=repmat((1:m_max),mc_tries,1);
nfro_vec_normed=nfro_vec./(N-m_mat);
p_frozen_hubs=mean((nfro_vec_normed).^m_mat);
E_frozen_core=mean((nfro_vec_normed).^(m_mat+1));
% th_vec=0.85:0.01:1;
% for th=th_vec
% plot(mean(nfro_vec_normed>th-epsilon),'linewidth',2);
% hold on;
% end
% legend(num2str(th_vec'));
% 

figure(ref+3);
plot(p_frozen_hubs,ccss,'markersize',mks);
hold on;
% hold on;
% plot(E_frozen_core);

% figure; 
% % plot(bstat_L1(:),nfro_vec(:),'x'); 
% % hold on; 
% plot(bstat_L2(:)*sqrt(N)/N,nfro_vec_normed(:),'o');
bsmooth = smooth_xy(nfro_vec_normed(:),bstat_L2(:)*sqrt(N)/N,1000);
ksmooth = smooth_xy(nfro_vec_normed(:),k_mean(:),1000);

figure(ref+1);
plot(bsmooth.x,bsmooth.y,ccss,'markersize',mks);
hold on;
plot(bsmooth.x,bsmooth.ymsd,ccss,'markersize',mks);
plot(bsmooth.x,bsmooth.ypsd,ccss,'markersize',mks);

figure(ref+2);
plot(ksmooth.x,ksmooth.y,ccss,'markersize',mks)
hold on;
plot(ksmooth.x,ksmooth.ymsd,ccssd,'markersize',mks)
plot(ksmooth.x,ksmooth.ypsd,ccssd,'markersize',mks)

end
end
% figure;
% plot(k_mean(:),nfro_vec_normed(:),'x');