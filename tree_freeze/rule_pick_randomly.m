function root=rule_pick_randomly(net)
N=length(net.b);
na_nodes=(net.fro_conf.sfro~=0)|(net.fro_conf.constr~=0); %nodes that are not avaliable for being set as root
if sum(na_nodes)==N
    root=0;
else
    topick_nodes=N-sum(na_nodes);
    root_prep=zeros(N,1);
    root_prep(~na_nodes)=(1:topick_nodes==randi(topick_nodes));
    root=find(root_prep);
end

