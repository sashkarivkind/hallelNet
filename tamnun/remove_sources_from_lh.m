function [o,W]=remove_sources_from_lh(W)
epsilon=1e-11; %to avoid comparing reals with '=='
orig_params = estim_lh_params(W);

source_counter=0;
stop_flag=0;
while ~stop_flag
    sources=all(abs(W)<epsilon,2);
    W=W(~sources,~sources);
    src=sum(sources);
    source_counter=source_counter+src;
    stop_flag = src==0;
end
%this part is taylored to lumped hub model
pruned_params = estim_lh_params(W);
fie=fields(pruned_params);
for ff=1:length(fie) 
    this_field_name=fie{ff};
    o.([this_field_name,'_orig'])=orig_params.(this_field_name);
    o.([this_field_name,'_pruned'])=pruned_params.(this_field_name);
end
o.source_counter=source_counter;