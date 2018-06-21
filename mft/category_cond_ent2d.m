function [h,p_rep]=category_cond_ent2d(x,y,flag,nbins)
if nargin<4
    nbins=[10,10];
end
epsilon=1e-30;
if isempty(y)
    [a,b]=hist([x'],nbins);
[af_rep,bf_rep]=hist([x(flag)'],b);
    
else
[a,b]=hist3([x',y'],nbins);
[af_rep,bf_rep]=hist3([x(flag)',y(flag)'],b);
end
p_rep=af_rep./(a+epsilon);
p_repc=1-p_rep;
h=sum(sum((p_rep.*log(p_rep+epsilon)+p_repc.*log(p_repc+epsilon)).*a))/sum(sum(a));