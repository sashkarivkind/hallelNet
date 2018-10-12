k_vec=1:0.05:5;
a0=0.5; a1=0;
s_vec=a0+a1*k_vec;
ds=0.2;
dk=0.1;
fz_th=0.9;
qfp_vec=zeros(size(s_vec));
n_vec =zeros(size(s_vec)); 
for ii=1:length(s_vec)
    condcond=(abs(sigma_hub-s_vec(ii))<ds)&...
        (abs(mean_k_str-k_vec(ii))<dk);
    n_vec(ii)=sum(condcond);
    qfp_vec(ii)=mean(frozen_core(condcond)>fz_th);
end
figure;
subplot 311
plot(1:length(s_vec),n_vec);
xlabel('step');
ylabel('# pts/bin');
subplot 312
plot(1:length(s_vec),qfp_vec);
xlabel('step');
ylabel('Pqfp');
subplot 313
plot(k_vec,s_vec,'--o');
xlabel('k_{mean}');
ylabel('\sigma');
