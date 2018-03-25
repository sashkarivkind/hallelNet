function o=build_frozen_tree(parent,new_root_signed,max_depth)
o.W=parent.W;
o.b=parent.b;
o.rule=parent.rule;
o.total_steps = parent.total_steps; 
o.terminated = 0;
N=size(o.W,1);
if (max_depth==0)
    o.terminated = 1;
    o.terminated_type='terminated_max_depth';
else
    if ~isempty(new_root_signed)
        fro_conf_in=parent.fro_conf;
        fro_conf_in.constr = fro_conf_in.constr+new_root_signed;
        [~,o.steps,o.fro_conf,o.incf,o.incn]= fc_calc_synch(o.W,o.b,fro_conf_in);
    else
        [~,o.steps,o.fro_conf,o.incf,o.incn]= fc_calc_synch(o.W,o.b);
    end
    
    o.total_steps = parent.total_steps + o.steps;
    
    if o.incf==1
        %         warning('inconsistency found');
        o.terminated = 1;        
        o.terminated_type = 'terminated_due_to_inconsistency';
    else
        o.root=parent.rule(o);
        if o.root==0
        o.terminated = 1;        
        o.terminated_type = 'terminated_full';
        else
            o.pchild=build_frozen_tree(o, 1*((1:N)==o.root)',max_depth-1);
            o.nchild=build_frozen_tree(o,-1*((1:N)==o.root)',max_depth-1);
            o.terminated=0;
        end
    end
end
