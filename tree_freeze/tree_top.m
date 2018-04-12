N=200; k=3; 

gamma_k_out = 2.5; % 2.2=power of power law ditribution of scale free out degree
k_m_out = 1; %minimal degree of power law ditribution of scale free out degree
W_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create sf-out binom-in network


bias_enable=0;


% W_top=rand(N)<k/N;

fprintf('k_mean: %4.3f\n',N*mean(W_top(:))); 
net.W=W_top.*randn(size(W_top));
net.b=bias_enable*randn(N,1);




max_depth = 15;
net.total_steps = 0;
net.rule = @rule_pick_by_eff_fanout;%@rule_pick_by_fanout;% rule_pick_from_fanin;%@rule_pick_randomly%@
net_tree=build_frozen_tree(net,[],max_depth);