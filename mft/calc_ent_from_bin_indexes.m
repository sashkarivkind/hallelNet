function [h,p]=calc_ent_from_bin_indexes(c,sel)
epsilon=1e-30;
N=length(sel);
bin_mask = repmat(c,1,length(unique(c)))==repmat(unique(c)',N,1);
bin_tot=sum(bin_mask,1)';
p_bin=bin_tot/sum(bin_tot);
bin_sel=double(bin_mask')*sel;
p=bin_sel./(bin_tot+epsilon);
h=sum((p.*log(p+epsilon)+(1-p).*log(1-p+epsilon)).*p_bin);