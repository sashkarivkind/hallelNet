function root=rule_pick_from_fanin(net)
%this rule picks one of the nodes that belong to the constrained set fanin
N=length(net.b);
unfrozen_constr=(net.fro_conf.sfro==0)&(net.fro_conf.constr~=0); %nodes that are not avaliable for being set as root
na_nodes=(net.fro_conf.sfro~=0)|(net.fro_conf.constr~=0); %nodes that are not avaliable for being set as root

if ~any(unfrozen_constr)
    root = rule_pick_randomly(net);
    return
else
    candidates=any(net.W(unfrozen_constr,:),1);
    if ~any(candidates)
        root = rule_pick_randomly(net);
        return
    end
%     size(candidates)
%     size(~na_nodes)
    candidates=candidates & ~na_nodes';
    if ~any(candidates)
        root = rule_pick_randomly(net);
        return
    end
    temp = find(candidates);
    if length(temp)>1
        root=randsample(find(candidates),1);
    else
        root = temp;
    end
    if net.fro_conf.constr(root)~=0
        error('debug')
    end
end

