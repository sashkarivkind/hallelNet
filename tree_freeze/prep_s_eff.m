function s_eff = prep_s_eff(sfro,constr,strict)
if nargin<3
    strict = 1;
end
range = (sfro~=0) & (constr~=0); % indicates nodes that are either constrained or frozen
temp = sfro .* constr;
if strict
    if ismember(-1,temp(range))% will rise  -1 if constraints and frozen are inconsistent
        error('inconsistency between freezing and constraints');
    end
end
s_eff = constr+(constr==0).*sfro;