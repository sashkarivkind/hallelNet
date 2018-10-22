figure;
subplot(3,3,1);
pp=1;
for kk=1:1:length(k_vec)
subplot(3,3,pp);
pp=pp+1;
stem(div_d_bins,div_d_prob(kk,:));

title(['k=',num2str(k_vec(kk))]);
xlabel('\nabla d'); ylabel('Prob');
xlim([-1,8]);
end