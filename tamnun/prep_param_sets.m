function param_set=prep_param_sets(params_to_loop)
fie = fields(params_to_loop);
if length(fie) == 0
    param_set{1}=struct;
else
    param_set={};
    this_param_to_loop=fie{1};
    param_set_m1=prep_param_sets(rmfield(params_to_loop,this_param_to_loop));
    for pp = 1:length(param_set_m1)        
        for qq=1:length(params_to_loop.(this_param_to_loop))
            param_set{end+1}=param_set_m1{pp};
            param_set{end}.(this_param_to_loop)=params_to_loop.(this_param_to_loop)(qq);
        end
    end
end
