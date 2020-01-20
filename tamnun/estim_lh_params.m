function o=estim_lh_params(W);
%measure statistics of a given realization W
%W can be either weight matrix or topology matrix
epsilon=1e-15;
o.N_eff=size(W,1);
o.kb_eff=sum(sum(abs(W(2:end,2:end))>epsilon))/(o.N_eff-1);
o.f_eff=mean(abs(W(:,1))>epsilon);
o.s_eff=mean(W(:,1).^2);