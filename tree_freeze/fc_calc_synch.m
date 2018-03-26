function [nf,steps,fro_conf,...
    inconsist_flag,inconsist_nodes]=fc_calc_synch(W,b,fro_conf);
%inputs:
%W the matrix of interest
%b the extrnal bias
%fro frozen core boolean
%sfro frozen core with signs
%outputs:
%nf - stands for n frozen, the size of the frozen core
%sfro - signed  binary vector of frozen bits (+/-1), zero entries indicate nonfrozen bits 
%----- the effective bias consists from the actual external bias and from
%the one that is induced by the frozen core
%inconsist_flag - rised if one or more of bits that are assumed frozen flip
%inconsist_nodes -  of these bits
steps=0;
inconsist_flag = 0;
inconsist_nodes=[];
if nargin<3
%     fro=logical(zeros(size(W,1),1));
    sfro=(zeros(size(W,1),1));
    constr=(zeros(size(W,1),1));
else
%     fro = fro_conf.fro;
    sfro = fro_conf.sfro;
    constr = fro_conf.constr;
end

evolving = 1; % indicates whether the frozen core changes from step to step
while evolving
    %[1]: checking for toggling of nodes that are assumed constrained 
    if ismember(-1,sfro.*constr)
        inconsist_nodes=find(sfro.*constr==-1);
        inconsist_flag=1;
        break
    end
    
    prev_sfro = sfro;
    s_eff = prep_s_eff(sfro,constr);
    this_b=b+W*s_eff;
    
    %[2]: checking for toggling in nodes that assumed frozen
    if ismember(-1,sign(this_b).*sfro)
        error('sign is not preserved at one or more of frozen nodes')
    end

    next_fro=abs(this_b)>sum(abs(W(:,~s_eff)),2);
    sfro = sign(this_b).*next_fro;
       
    %[3]: sanity check, after checks [1,2] we assume that the only thing that can happen to the core is an increase
    if ~isequal(sfro&prev_sfro,prev_sfro~=0)
        error('the freezing is not strictly monotonous!');
    end
    evolving = ~isequal(sfro,prev_sfro);
    steps=steps+1;
end
nf=sum(sfro~=0);
fro_conf.sfro = sfro;
fro_conf.constr = constr;


