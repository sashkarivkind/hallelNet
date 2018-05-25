function [c_out] =c12_u_sparse(c,u,phi,mc_samples,N,k)
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
W_top = rand(mc_samples,N)<k/N;
W=randn(size(W_top)).*W_top/sqrt(k);
% my1=ones(size(c));
v1=ones(N,length(d));
v2=-1+2*(repmat((1:N)',1,length(d))>=repmat(round(d*N),N,1));
uu = (u+epsilon)*randn(mc_samples,length(d));
c_out=mean(...
    phi(W*v1+uu).*phi(W*v2+uu),...
    1);
% c_out=mean(...
%     phi(y*v1).*phi(y*v2),...
%     1);
