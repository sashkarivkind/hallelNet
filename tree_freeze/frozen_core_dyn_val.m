clear;

run_prefix = 'dyn_fro';
mc_tries=500;
m_max=10;
T_max=50;
N_perturbations = 50;
k_m_out = 1; %minimal degree of power law ditribution of scale free out degree


%%output initialization
% p_conv=cell(mc_tries);%,num_lumping_methods,length(perturb_hubs_vec));
% % d_conv{ii,jj,kk} = -ones(N_perturbations);
% % m_conv{ii,jj,kk} = -1;
% % fc_conv{ii,jj,kk} = -1;


for N=[1000, 2000]
    
    for gamma_k_out =2.2% 2.1:0.1:2.3%2.0:0.2:2.4; % 2.2=power of power law ditribution of scale free out degree
        
        if m_max
            m_max_tag = m_max;
        else
            m_max_tag = N;
        end
        
        run_name = [run_prefix , 'N_' , num2str(N) , '_gamma_k_out_' ,num2str(gamma_k_out)];

        for ii=1:mc_tries
            W_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create sf-out binom-in network
            W=W_top.*randn(size(W_top));
            fro_constr = zeros(N,1);
            for m=1:m_max_tag,
                fro_sfro = zeros(N,1);
                fro_constr(1:m)=1;
                fro_constr(m+1:end)=0;
                ksi=ones(m,1);
                [nfro,steps,fro_conf_out]=...
                    fc_calc_synch(W,zeros(N,1),...
                    struct('sfro',fro_sfro,'constr',fro_constr),0);
                fro_sfro=fro_conf_out.sfro;
                if all(fro_sfro(~~fro_constr))
                    W_fix=W;
                    W_fix(~~fro_constr,:)=...
                        diag(fro_sfro(~~fro_constr))*W_fix(~~fro_constr,:);
                    s_eff = prep_s_eff(fro_sfro,fro_constr,0);
                    x_0=diag(~s_eff)*randn(N,N_perturbations)...
                        +repmat(s_eff,1,N_perturbations);
                    lumping_methods = lumping_methods_prep(N,m);
                    for jj=1
                        for kk=1

                            
                            pp=async_run_mult_ic(W_fix,...
                                struct('x_0',x_0,...
                                'frozen',fro_sfro,...
                                't_max',T_max));
                        figure(3); 
                        hist(pp.fro_dyn)    ;
                        title(['nfro = ', num2str(nfro)]);
                        drawnow;
                        pause;
                        end
                    end
                    break
                else
                       uuuuuuuuu=8; %placeholder
                end
            end
            disp(ii);
        end
        %             p_inv=mean(d_conv/diag(fc_conv)>1-1e-10); %probability of getting the pattern itself
        %             p_dir=mean(d_conv/diag(fc_conv)<0+1e-10); %probability of getting an inverted pattern
        %             p_tot=p_inv+p_dir;
        save([run_name,'.mat'],'','','','');
    end
end
