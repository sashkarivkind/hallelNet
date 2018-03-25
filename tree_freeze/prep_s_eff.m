function s_eff = prep_s_eff(sfro,constr)
range = (sfro~=0) & (constr~=0); % indicates nodes that are either constrained or frozen
temp = sfro .* constr; 
if ismember(-1,temp(range))% will rise  -1 if constraints and frozen are inconsistent
    error('inconsistency between freezing and constraints');
end
s_eff = sfro+(sfro==0).*constr;