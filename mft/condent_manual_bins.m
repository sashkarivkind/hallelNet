sel=frozen_core'>f_th;
binning_adj=binning_vec(1:end-4);
minbinvol_vec2=length(sel)*(binning_adj).^(-2);
paraset={ppre,ppost,randn(size(ppost))};
paramlab={'orig','repa','rand'};
% %debug
% prate=1.0;
% randn(size(prand));
% paraset={prand};
% paramlab={'debug'}
% sel=( (prand(1,:)>0)&...0.75*median(prand(1,:)))&...
%     (rand(size(prand(1,:)))<prate) )';
% %end debug
rand_sel=rand(size(sel))<mean(sel);
immat=zeros(length(paraset),length(minbinvol_vec2));
for kk=1:length(paraset)
    this_paraset=paraset{kk};
for bb=1:length(minbinvol_vec2)
    minbinvol=minbinvol_vec2(bb);
    [X,ii,c]=kd_tree_with_min_backet(this_paraset',minbinvol);
    %     sel=frozen_core(ii)';
    [h_uncond,p_uncond]=calc_ent_from_bin_indexes(c,rand_sel(ii));
    [h_cond,p_cond]=calc_ent_from_bin_indexes(c,sel(ii));
%     [h_uncond,p_uncond]=calc_ent_from_bin_indexes(c,rand_sel);
%     [h_cond,p_cond]=calc_ent_from_bin_indexes(c,sel);
    disp(-[h_uncond,h_cond,h_uncond-h_cond]);
    immat(kk,bb)=-(h_uncond-h_cond);
end
disp('------');
end
figure;
plot(binning_adj,immat','--');
legend(paramlab)