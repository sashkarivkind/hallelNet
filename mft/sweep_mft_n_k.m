clear nk_table
ana=0; %doing sims, not analytic calculation
k_vec=[2     3     4     5     6];
N_vec=[100,500,1000,1500,3000,10000];
for nn=1:length(N_vec)
    for kk=1:length(k_vec)
        if ana
            nk_table{kk,nn}=mft_conv_fun(c0,c12_rec{kk},struct('N',N_vec(nn)));
        else
            opt_struct=struct('ana',0,'N',N_vec(nn),'k',k_vec(kk),'sim_pupd',sim_pupd);
            nk_table{kk,nn}=mft_conv_fun(0,0,opt_struct);
        end
        fprintf('k=%d, N=%d, conv: %.3f, f.p. %.3f \n',...
            k_vec(kk),N_vec(nn),...
            mean(nk_table{kk,nn}.conv),...
            mean(mean(nk_table{kk,nn}.fp))...
        );
    end
    save(['simulated_conv',num2str(sim_pupd,2)]); 
end
