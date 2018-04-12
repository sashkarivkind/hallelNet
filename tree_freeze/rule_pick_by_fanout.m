function root=rule_pick_by_fanout(net)
%this rule picks the node with maximal fanout
na_nodes=(net.fro_conf.sfro~=0)|(net.fro_conf.constr~=0); %nodes that are not avaliable for being set as root
fanout = sum(net.W~=0,1);
if ~any(fanout(~na_nodes))
    root = rule_pick_randomly(net);
else
   [~,root] = max(fanout.*(~na_nodes'));
end

