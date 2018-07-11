f_th=0.9;
uu=[];
gamma_fit<
ppre=[gamma_fit(top_r);mean_k()];
ppost=[sigma_hub(); mean_k_str()];
prand=randn(size(ppost));
binning_vec=[2,5,10,20,30,100,200,300];
N1=size(ppre(1,:));
N=length(ppre(1,:));
rand_labels=randperm(N);
for bb=binning_vec
    uu=[uu ;[...
        category_cond_ent2d(ppre(1,:),ppre(2,:),frozen_core(rand_labels)>f_th,[bb,bb]),...
        category_cond_ent2d(ppre(1,:),ppre(2,:),frozen_core>f_th,[bb,bb]),...
        category_cond_ent2d(ppost(1,:),ppost(2,:),frozen_core(rand_labels)>f_th,[bb,bb]),...
        category_cond_ent2d(ppost(1,:),ppost(2,:),frozen_core>f_th,[bb,bb]),...
        category_cond_ent2d(prand(1,:),prand(2,:),prand(1,rand_labels)>f_th,[bb,bb]),...
        category_cond_ent2d(prand(1,:),prand(2,:),prand(1,:)>f_th,[bb,bb])]];
end
disp('rand_on_orig/orig/rand_rep/rep')
disp( uu )
i1=diff(uu(:,1:2),[],2);
i2=diff(uu(:,3:4),[],2);
i3=diff(uu(:,5:6),[],2);

% disp([i1,i2,i3,i4]);
disp([i1,i2,i3]);
figure;
plot(binning_vec,[i1,i2,i3],'o-');
legend({'orig','repa'});
xlabel('#number of bins')
ylabel('MI')
