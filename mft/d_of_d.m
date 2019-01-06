function dd = d_of_d(k_mean,u,d,N)
k_max_equal = min((1-d)*k_mean*10,N-1); %nodes that are equal for both states
k_max_different = min(d*k_mean*10,N-1);
dd=0;
%what happens to a single row
for k_eq=0:k_max_equal
    pkeq=pdf('Poisson',k_eq,(1-d)*k_mean);
    for k_diff=0:k_max_different
        pkdiff=pdf('Poisson',k_diff,d*k_mean);
        sqrtkeq_eff = sqrt(u^2+k_eq);
        pz1togglesrow= atan(sqrt(k_diff)/sqrtkeq_eff)*2/pi;
        dd=dd+pz1togglesrow*pkeq*pkdiff;
    end
end
