figure; 
epsilon=1e-6;

m_mat=repmat((1:m_max),mc_tries,1);
nfro_vec_normed=nfro_vec./(N-m_mat);
p_frozen_hubs=mean((nfro_vec_normed).^m_mat);
E_frozen_core=mean((nfro_vec_normed).^(m_mat+1));
th_vec=0.85:0.01:1;
for th=th_vec
plot(mean(nfro_vec_normed>th-epsilon),'linewidth',2);
hold on;
end
legend(num2str(th_vec'));


figure;
plot(p_frozen_hubs);

hold on;
plot(E_frozen_core);

figure; 
% plot(bstat_L1(:),nfro_vec(:),'x'); 
% hold on; 
plot(bstat_L2(:)*sqrt(N)/N,nfro_vec_normed(:),'o');
figure;
plot(k_mean(:),nfro_vec_normed(:),'x');