for depth=1:max_depth-1
conf_vec=0:2^depth-1;
nfro=zeros(size(conf_vec)); %counting total frozen elements
alive=zeros(size(conf_vec)); %counting total frozen elements
full_consist=zeros(size(conf_vec)); %spotting cases where frozen core fully consistent with constraints

for uu=conf_vec
    constr_conf =sign(de2bi(uu,depth)-0.5);
    sub_tree = read_from_tree(net_tree,constr_conf);
    if isstruct(sub_tree)
        nfro(uu+1)=sum(sub_tree.fro_conf.sfro~=0);
        alive(uu+1)=1;
        full_consist(uu+1) = all(sub_tree.fro_conf.sfro(sub_tree.fro_conf.constr~=0));
    end
end
fprintf('depth %d, alive:%d,(%1.2f%%), max: %d,self consist: %d\n',depth,sum(alive), 100*mean(alive),max(nfro), sum(full_consist))
if sum(full_consist)>0
    fprintf('\t\t frozen size: %2g (%2g) \n', [nfro(full_consist~=0);conf_vec(full_consist~=0)]);
else 
    fprintf('');
end
end