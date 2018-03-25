% a script for validating that indeed a network converges to the frozen
% core
max_tries = 1000;
for mctry=1:max_tries
    depth = randi(max_depth);
    constr_conf =sign(randn(depth,1));
    sub_tree = read_from_tree(net_tree,constr_conf);
    %sanity check - todo
    if isstruct(sub_tree)
        s = run_dyn_under_constraints(...
            sub_tree.W,sub_tree.b,sub_tree.fro_conf.constr,sub_tree.total_steps);
        sfro=sub_tree.fro_conf.sfro;
        if any(s(sfro~=0)~=sfro(sfro~=0))
            error('spotted inconsistent freezing');
        end
    end
end
disp('no bugs spotted');

