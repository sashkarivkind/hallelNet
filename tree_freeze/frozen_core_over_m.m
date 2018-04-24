run_prefix = 'core_over_m_v2_';

mc_tries=100;
m_max=30;

k_m_out = 1; %minimal degree of power law ditribution of scale free out degree


for N=[1000, 2000, 4000]
    for gamma_k_out = 2.2:0.1:2.4; % 2.2=power of power law ditribution of scale free out degree
        
        run_name = [run_prefix , 'N_' , num2str(N) , '_gamma_k_out_' ,num2str(gamma_k_out)];
        nfro_vec=zeros(mc_tries,m_max);
        k_mean=zeros(mc_tries,m_max);
        bstat_L1=zeros(mc_tries,m_max);
        bstat_L2=zeros(mc_tries,m_max);
        %     W_top=raplnd(N)<k/N;
        parfor ii=1:mc_tries
            W_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create sf-out binom-in network
            W=W_top.*randn(size(W_top));
            for m=1:m_max
                ksi=ones(m,1);
                W_eff=W(m+1:end,m+1:end);
                b_eff=W(m+1:end,1:m)*ksi;
                [nfro_vec(ii,m),steps]=fc_calc_synch(W_eff,b_eff);
                bstat_L1(ii,m)=norm(b_eff,1);
                bstat_L2(ii,m)=norm(b_eff,2);
                k_mean(ii,m)=mean(sum(W_eff~=0));
            end
            disp(ii);
        end
        save([run_name,'.mat']);
    end
end
% figure;
% % plot(bstat_L1(:),nfro_vec(:),'x');
% % hold on;
% plot(bstat_L2(:)*sqrt(N)/N,nfro_vec(:)/N,'o');
% fro_visu;