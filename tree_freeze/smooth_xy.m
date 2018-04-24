function s = smooth_xy(x,y,w)
if nargin<3
    w=10;
end
[s.x,order_x]=sort(x);
s.y=smooth(y(order_x),w);
s.ysd=sqrt(smooth((y(order_x)-s.y).^2,w));
s.ymsd=s.y-s.ysd;
s.ypsd=s.y+s.ysd;