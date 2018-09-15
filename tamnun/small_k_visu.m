k_mean=5;
k_stop=5*k_mean;
w_all=(-10:0.01:10)*sqrt(k_mean);
dist_fx = zeros(size(w_all));
N=500;
u=0.5;
figure;
gau = @(ss) exp(-w_all.^2/2/ss^2)/ss/sqrt(2*pi); 

for k=0:k_stop
    sigma_fx_eff = sqrt(k+u^2);
    sigma_flp = 1;
    p_binom = binopdf(k,N,k_mean/N)
    this_gauss=gau(sigma_fx_eff);
%     plot(w_all,this_gauss*sqrt(2*pi)*sigma_fx_eff);
%     hold on;
    dist_fx = dist_fx + p_binom*this_gauss;
end

plot(w_all,dist_fx);