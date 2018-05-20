function [nf,steps,fro_conf,...
    inconsist_flag,inconsist_nodes]=fc_calc_dyn(W,b,fro_conf,strict,opt);
%computes 'empirical' frozen core based on transient simulation
%inputs:
%W the matrix of interest
%b the extrnal bias
%fro_conf -  frozen core configuration
%outputs:
%nf - stands for n frozen, the size of the frozen core
%sfro - signed  binary vector of frozen bits (+/-1), zero entries indicate nonfrozen bits
%----- the effective bias consists from the actual external bias and from
%the one that is induced by the frozen core
%inconsist_flag - rised if one or more of bits that are assumed frozen flip
%inconsist_nodes -  of these bits
if ~isfield(opt,'select_rule')
    opt.select_rule = @max_core;
end
opt.fro_conf=fro_conf; %todo: merge these two structures at the interface
steps=0;
inconsist_flag = 0;
inconsist_nodes=[];
outstat = async_run_mult_ic(W,opt);

fro_conf.sfro = opt.select_rule(outstat.fro_full);
% fro_conf.constr = outstat.constr;
nf=sum(fro_conf.sfro~=0);
end
function fc=max_core(fro_mat)
[~,ii]=max(sum(~~fro_mat,1)); %count frozen core size per column
fc= fro_mat(:,ii);
end

