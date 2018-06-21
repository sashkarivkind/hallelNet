function o=recursive_param_sweep(fun,sweeped_param, inherited_param,verbose)
if nargin<3
    inherited_param=struct;
end
if nargin<4
    verbose = struct('enable',1,'fun',@default_verbose_fun);
end
if ~isstruct(verbose)
    verbose = struct('enable',verbose,'fun',@default_verbose_fun);
end

sweeped_param_names = fields(sweeped_param);
if ~length(sweeped_param_names)
    o.result=fun(inherited_param);
    o.param = inherited_param;
    if verbose.enable
        o.verbose=verbose.fun(o);
        fprintf(o.verbose);
    end
else
    o={};
    new_sweeped_param=sweeped_param;
    new_sweeped_param=rmfield(new_sweeped_param,sweeped_param_names{end});
    for pp=sweeped_param.(sweeped_param_names{end})
        inherited_param.(sweeped_param_names{end})=pp;
        o{end+1}=recursive_param_sweep(fun,new_sweeped_param, inherited_param);
    end
end
end

function s=default_verbose_fun(o)
    s=sprintf([prepare_struct_to_log(o.param),'|',prepare_struct_to_log(o.result),'\n']);
end
function prep_out=prepare_struct_to_log(s)
    field_names=fields(s);
    prep_out = '';
    for ii=1:length(field_names)
        prep_out=[prep_out,scalar_prep(s.(field_names{ii}))];
    end
end
function prep=scalar_prep(a)
if isscalar(a)
    prep=sprintf('%.3f| ',a);
elseif ismatrix(a)
    prep=sprintf('%.3f(mean)| ',mean(a(:)));
elseif isstruct(a)
    prep=prepare_struct_to_log(a);
end
end