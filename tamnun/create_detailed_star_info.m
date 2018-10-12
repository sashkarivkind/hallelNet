function o=create_detailed_star_info(W_top,m_lump,k_max);
s_vec=0:m_lump;
k_vec=0:k_max;

o=zeros(size(s_vec'*k_vec));

ss=sum(W_top(:,1:m_lump),2);
kk=min(...
    sum(W_top(:,m_lump+1:end),2),...
    k_max);
for ii=1:length(kk)
    o(s_vec==ss(ii),k_vec==kk(ii))=o(s_vec==ss(ii),k_vec==kk(ii))+1;
end