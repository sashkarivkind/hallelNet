function o=mergestruct(struct1,struct2)
o=struct1;
fie=fields(struct2);
for ff=1:length(fie)
    o.(fie{ff})=struct2.(fie{ff});
end