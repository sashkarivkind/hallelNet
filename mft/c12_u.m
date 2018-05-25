function [c_out, cc_out] =c12_u(c,u,phi,mc_samples,vargin)
%given correlation c between two states
%compute the resulting correlation 
if nargin<3
    phi=@sign;
end
if nargin<4
    mc_samples=10000;
end
y=randn(mc_samples,3); %s1,s2,u
b=sqrt(1-c.^2);
my1=ones(size(c));
v1=[my1;0*my1;u*my1];
v2=[c;b;u*my1];
c_out=mean(...
    phi(y*v1).*phi(y*v2),...
    1);
c_out=mean(...
    phi(y*v1).*phi(y*v2),...
    1);
