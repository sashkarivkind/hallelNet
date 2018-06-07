f1=figure;
f2=figure;
c0=[-1:0.01:1];
N_vec=[1000]%,2000];
u_vec=[1];%,1];
log10_k=[0];%:0.5:2];
% k_vec=10.^log10_k;
k_vec=[2,3,4,5,6,7];%[2,3,4,1000];
c12_rec={};
c12_fun_vec={@c12_u_sparse};%,@c12_u_sparse_ana}; %@c12_u};
mk_vec='xod';
clr_vec='rgbm';
leg={};
h=[];
leg_i=0;
for nn=1:length(N_vec)
    for ii=1:length(k_vec)
        for jj=1:length(u_vec)
            for ff=1:length(c12_fun_vec)
                N=N_vec(nn);
                k=k_vec(ii);
                u=u_vec(jj)/sqrt(k);
                mk=mk_vec(ff);
                clr=clr_vec(nn);
                c12_fun=c12_fun_vec{ff};
                leg_i=leg_i+1;
                %  plot(c0,c12_u(c0,u,@sign,1e5),'x-');
                
                c12=c12_fun(c0,u,@sign,1e5,N,k);
                c12_rec{ii}=c12;
                figure(f1);
                h(leg_i)=plot(c0,c12,[mk,clr]);
                hold on;
                figure(f2);
                plot(c0,c12-c0,[mk,clr]);
                hold on;
                leg{leg_i}=sprintf('k=%.1f u=%.1f N=%d',k,u,N);
                disp(k);
            end
        end
    end
end
xlabel('c_{t}');
ylabel('c_{t+1}-c_{t}');
% legend(num2str(log10_k'));
legend(leg);
figure(f1);
plot(c0,c0,':k');
legend(leg);
xlabel('c_{t}');
ylabel('c_{t+1}');
