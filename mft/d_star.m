function [dfp,dndx]=d_star(d0,d12)
%find fixed point of function d12(d0).
%the stable fixed point with highest d12 is returned
[d0,dxdx]=sort(d0,2); 
d12=d12(:,dxdx);
d0=repmat(d0,size(d12,1),1);
% uppmx=repmat(1:size(d12,2),size(d12,1),1);
dd=d12-d0;%find when the difference switches sign
ddd=diff(sign(dd),[],2);
[dfp,dndx]=max(d0(:,1:end-1).*(ddd<0),[],2);

