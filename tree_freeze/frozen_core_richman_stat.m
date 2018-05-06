clear;
run_prefix = 'tamn2k_richman_run_T100_';
mc_tries=500;
m_max=0;
T_max=50;
N_perturbations = 100;
k_m_out = 1; %minimal degree of power law ditribution of scale free out degree


for N=[1000, 2000, 4000]
    for gamma_k_out = 2.1:0.2:2.3%2.0:0.2:2.4; % 2.2=power of power law ditribution of scale free out degree
        
	if m_max
		m_max_tag = m_max;
	else
		m_max_tag = N;
	end

        run_name = [run_prefix , 'N_' , num2str(N) , '_gamma_k_out_' ,num2str(gamma_k_out)];
        %nfro_vec=zeros(mc_tries,m_max);
        %k_mean=zeros(mc_tries,m_max);
        %bstat_L1=zeros(mc_tries,m_max);
        %bstat_L2=zeros(mc_tries,m_max);
        p_conv = -ones(mc_tries,1);
        d_conv = -ones(N_perturbations,mc_tries);
        m_conv = -ones(mc_tries,1);
        fc_conv = -ones(mc_tries,1);
        %     W_top=raplnd(N)<k/N;
        parfor ii=1:mc_tries
            W_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create sf-out binom-in network
            W=W_top.*randn(size(W_top));
            fro_constr = zeros(N,1);
            for m=1:m_max_tag,
                fro_sfro = zeros(N,1);
                fro_constr(1:m)=1; 
                fro_constr(m+1:end)=0; 
                ksi=ones(m,1);
                W_eff=W(m+1:end,m+1:end);
                b_eff=W(:,1:m)*ksi;
                [nfro,steps,fro_conf_out]=...
                    fc_calc_synch(W,0*b_eff,...
                    struct('sfro',fro_sfro,'constr',fro_constr),0);
                fro_sfro=fro_conf_out.sfro;
                %bstat_L1(ii,m)=norm(b_eff,1);
                %bstat_L2(ii,m)=norm(b_eff,2);
                %k_mean(ii,m)=mean(sum(W_eff~=0));
                if all(fro_sfro(~~fro_constr))
                    W_fix=W;
                    W_fix(~~fro_constr,:)=...
                        diag(fro_sfro(~~fro_constr))*W_fix(~~fro_constr,:);
                    s_eff = prep_s_eff(fro_sfro,fro_constr,0);
                    x_0=diag(~s_eff)*randn(N,N_perturbations)...
                        +repmat(s_eff,1,N_perturbations);
                    pp=async_pertube_fun(W_fix,...
                        struct('x_0',x_0,'frozen',fro_sfro,'t_max',T_max,'N_perturbations',N_perturbations));
                    p_conv(ii)=mean(pp.pert_diff_fro==0);
                    d_conv(:,ii)=pp.pert_diff_fro';
                    m_conv(ii)=m;
                    fc_conv(ii)=nfro;
                    break
                end
            end
            disp(ii);
        end
        p_inv=mean(d_conv/diag(fc_conv)>1-1e-10); %probability of getting the pattern itself
        p_dir=mean(d_conv/diag(fc_conv)<0+1e-10); %probability of getting an inverted pattern
        p_tot=p_inv+p_dir;
        save([run_name,'.mat']);
    end
end
