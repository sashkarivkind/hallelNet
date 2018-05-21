run_prefix = 'core_over_m_dyn_';

mc_tries=100;
m_max=20;
t_max=100;
k_m_out = 1; %minimal degree of power law ditribution of scale free out degree
barbara_core = 0;
pack_identity=@(x) struct('pack',x);

if barbara_core
    fc_calc=@fc_calc_synch;
    fc_opt=struct();
    nfro_vec=zeros(mc_tries,m_max);
else
    fc_calc=@fc_calc_dyn;
    fc_opt=struct('t_max',t_max,'select_rule',identity);
    clear nfro_vec;
    nfro_vec(1:mc_tries,1:m_max)=struct('pass',0);
end

for N=[1000, 2000, 4000]
    for gamma_k_out = [2.2,2.1,2.3]%:0.1:2.4; % 2.2=power of power law ditribution of scale free out degree
        
        run_name = [run_prefix , 'N_' , num2str(N) , '_gamma_k_out_' ,num2str(gamma_k_out)];
        k_mean=zeros(mc_tries,m_max);
        bstat_L1=zeros(mc_tries,m_max);
        bstat_L2=zeros(mc_tries,m_max);
        %     W_top=raplnd(N)<k/N;
        parfor ii=1:mc_tries
            fro_conf=struct();
            W_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create sf-out binom-in network
            W=W_top.*randn(size(W_top));
            fro_conf.sfro = zeros(N,1);
            fro_conf.constr = zeros(N,1);
            for m=1:m_max
                fro_conf.constr(m)=1;
                ksi=ones(m,1);
                W_eff=W(m+1:end,m+1:end);
                b_eff=W(:,1:m)*ksi;
                [nfro_vec(ii,m),~,~]=...
                    fc_calc(W,0*b_eff,fro_conf,0,fc_opt);
                bstat_L1(ii,m)=norm(b_eff,1);
                bstat_L2(ii,m)=norm(b_eff,2);
                k_mean(ii,m)=mean(sum(W_eff~=0));
            end
            disp(ii);
        end
    end 
            save([run_name,'.mat']);
end
