N=1000;%1500;
% mc_tries=100;
% k_vec=2:5;
% nfro=zeros(length(k_vec),mc_tries);

k=3;%k_vec(jj);
W_top=rand(N)<k/N;
net.W=W_top.*randn(size(W_top));
net.b=randn(N,1);
net.total_steps = 0;
max_depth = 10;
net.rule = @rule_pick_randomly;
net_tree=build_frozen_tree(net,[],max_depth);