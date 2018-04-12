function sub_tree = read_from_tree(tree,con)
%return a subtree representing a specific set of constraints
sub_tree = tree;
flag=0;
if sub_tree.terminated == 1;
    if ~isequal(sub_tree.terminated_type, 'terminated_full')
        sub_tree = 0;
        return
    end
end
for i=1:length(con)
    if con(i)==1
        sub_tree = sub_tree.pchild;
    elseif con(i)==-1
        sub_tree = sub_tree.nchild;
    end
    if sub_tree.terminated == 1;
        flag=1;
        break
    end
end
if flag %check if terminated at full node
    if (i<length(con))||(~isequal(sub_tree.terminated_type, 'terminated_full'))
        sub_tree = 0;
    end
    return
end