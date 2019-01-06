function dd = div_d(k_mean,u,N)
k_max = min(k_mean*3,N-1);
dd=0;
%what happens to a single row
for k=0:k_max
    %pk=binopdf(k,N-1,k_mean/N);
    pk=pdf('Poisson',k,k_mean);
    sqrtk_eff = sqrt(u^2+k);
%     pz1togglesrow= 1-atan(sqrtk_eff)*2/pi;
    pz1togglesrow= atan(sqrtk_eff^-1)*2/pi;
    dd=dd+pz1togglesrow*pk;
end
%now multiplying by an affective number of rows 
dd = dd*k_mean;