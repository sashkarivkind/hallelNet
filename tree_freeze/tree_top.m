N=100; k=3; 

W_top=rand(N)<k/N;
net.W=W_top.*randn(size(W_top));
net.b=randn(N,1);

max_depth = 10;
net.total_steps = 0;
net.rule = @ rule_pick_from_fanin;%@rule_pick_randomly%@
net_tree=build_frozen_tree(net,[],max_depth);