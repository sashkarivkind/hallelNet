function sub_tree = read_from_tree(tree,con)
%return a subtree representing a specific set of constraints
sub_tree = tree;
if sub_tree.terminated == 1;
    sub_tree = 0;
    return
end
for i=1:length(con)
    if con(i)==1
        sub_tree = sub_tree.pchild;
    elseif con(i)==-1
        sub_tree = sub_tree.nchild;
    end
    if sub_tree.terminated == 1;
        sub_tree = 0;
        break
    end
end
