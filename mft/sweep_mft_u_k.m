clear uk_table
ana=0; %doing sims, not analytic calculation
k_vec=[2     3     4     5     6];
N_vec=[1500];%[100,500,1000,1500,3000,10000];
u_vec=0.5:0.25:2;
for uu=1:length(u_vec)
for nn=1:length(N_vec)
    for kk=1:length(k_vec)
        if ana
            uk_table{kk,uu}=mft_conv_fun(c0,c12_rec{kk},struct('N',N_vec(nn)));
        else
            opt_struct=...
                struct('ana',0,...
                'N',N_vec(nn),...
                'k',k_vec(kk),...
                'u',u_vec(uu),...
                'sim_pupd',sim_pupd,...
                'enforce_fp',enforce_fp);
            uk_table{kk,uu}=mft_conv_fun(0,0,opt_struct);
        end
        fprintf('k=%d, N=%d, u=%.2f conv: %.3f, f.p. %.3f \n',...
            k_vec(kk),N_vec(nn),u_vec(uu),...
            mean(uk_table{kk,uu}.conv),...
            mean(mean(uk_table{kk,uu}.fp))...
        );
    end
end
    save(['simulated_conv_uk2',num2str(sim_pupd,2)]); 
end
