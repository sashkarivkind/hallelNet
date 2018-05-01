run_prefix = 'richman_run3_';

mc_tries=200;
m_max=30;

k_m_out = 1; %minimal degree of power law ditribution of scale free out degree


for N=[1000];%, 2000, 4000]
    for gamma_k_out = 2.2:0.2:2.4; % 2.2=power of power law ditribution of scale free out degree
        
        run_name = [run_prefix , 'N_' , num2str(N) , '_gamma_k_out_' ,num2str(gamma_k_out)];
        nfro_vec=zeros(mc_tries,m_max);
        k_mean=zeros(mc_tries,m_max);
        bstat_L1=zeros(mc_tries,m_max);
        bstat_L2=zeros(mc_tries,m_max);
        p_conv = -ones(mc_tries,1);
        m_conv = -ones(mc_tries,1);
        fc_conv = -ones(mc_tries,1);
        %     W_top=raplnd(N)<k/N;
        for ii=1:mc_tries
            W_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create sf-out binom-in network
            W=W_top.*randn(size(W_top));
            fro_conf.sfro = zeros(N,1);
            fro_conf.constr = zeros(N,1);
            for m=1:m_max
                fro_conf.constr(m)=1; 
                ksi=ones(m,1);
                W_eff=W(m+1:end,m+1:end);
                b_eff=W(:,1:m)*ksi;
                [nfro_vec(ii,m),steps,fro_conf_out]=fc_calc_synch(W,0*b_eff,fro_conf,0);
                bstat_L1(ii,m)=norm(b_eff,1);
                bstat_L2(ii,m)=norm(b_eff,2);
                k_mean(ii,m)=mean(sum(W_eff~=0));
                if all(fro_conf_out.sfro(~~fro_conf_out.constr))
                    W_fix=W;
                    W_fix(~~fro_conf_out.constr,:)=...
                        diag(fro_conf_out.sfro(~~fro_conf_out.constr))*W_fix(~~fro_conf_out.constr,:);
                    s_eff = prep_s_eff(fro_conf_out.sfro,fro_conf_out.constr,0);
                    x_0=randn(N,1).*(~s_eff)+s_eff;
                    pp=async_pertube_fun(W_fix,struct('x_0',x_0,'frozen',fro_conf_out.sfro,'t_max',40));
                    p_conv(ii)=mean(pp.pert_diff_fro==0);
                    m_conv(ii)=m;
                    fc_conv(ii)=nfro_vec(ii,m);
                    break
                end
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