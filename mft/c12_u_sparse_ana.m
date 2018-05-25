function [c_out] =c12_u_sparse_ana(c,u,phi,mc_samples,N,k)
%given correlation c between two states
%compute the resulting correlation 
epsilon=1e-8;
if nargin<3
    phi=@sign;
end
if nargin<4
    mc_samples=10000;
end
d=0.5*(1-c);
v1=binornd(repmat(round(d*N),mc_samples,1),k/N);
v2=binornd(repmat(round((1-d)*N),mc_samples,1),k/N);

v1=sqrt(v1).*randn(size(v1));
v2=sqrt(v2).*randn(size(v2));

uu = (u+epsilon)*randn(mc_samples,length(d));
c_out=mean(...
    phi(v2+v1+uu).*phi(v2-v1+uu),...
    1);
% c_out=mean(...
%     phi(y*v1).*phi(y*v2),...
%     1);
