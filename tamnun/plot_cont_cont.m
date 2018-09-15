figure;
N_vec=[1500]%,5000,10000];
cc='rbgby';
for ii=1:length(N_vec)
    N=N_vec(ii);
    res_path=['default_run_name_N', num2str(N),'/'];
    zzz_result_struct_parser;
    div_d0_vec=zeros(size(frozen_core));
    for pp=1:length(div_d0_vec)
        div_d0_vec(pp) = div_d(mean_k_str(pp),sigma_hub(pp),N);
    end
    good_gamma=(gamma_k_out>2.2)&(gamma_k_out<2.7);
    qfp=frozen_core>0.9;
    supercrit=good_gamma&(div_d0_vec>1.00);
    subcrit=good_gamma&(div_d0_vec<1);

    psup=sum(qfp(supercrit))/sum(supercrit);
    psub=sum(qfp(~supercrit))/sum(~supercrit);
    fprintf('N=%d P_sup = %f, Psub = %f\n',N,psup,psub);
    hh=contour_by_xy(sigma_hub(good_gamma),mean_k_str(good_gamma),...
        cc(ii),'linewidth',1.5,'ShowText','on');
    hold on;
%     hold on;
%         hh=contour_by_xy(sigma_hub(good_gamma&qfp),mean_k_str(good_gamma&qfp),...
%         [cc(ii),'x-'],'linewidth',1);
%     hh=contour_by_xy(sigma_hub(good_gamma),mean_k_str(good_gamma),...
% cc(ii),'linewidth',1.5);
% hold on;
% hh=contour_by_xy(sigma_hub(good_gamma&qfp),mean_k_str(good_gamma&qfp),...
% [cc(ii),'x-'],'linewidth',1);
end
xlabel('\sigma_{hub}');
ylabel('<k_{star}>');
legend(num2str(N_vec'));