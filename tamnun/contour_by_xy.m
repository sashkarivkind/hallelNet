function oo=contour_by_xy(x,y,varargin)
% [n,c] = hist3([x',y'],{0:0.1:1.5,2:0.1:5});
[n,c] = hist3([x',y'],{0:0.1:1.5,3.5:0.1:8});
n=n/max(max(n));
oo=contour(c{1},c{2},n',max(n(:))*[0.8 0.6 0.4 0.2],varargin{:});
% oo=contour(c{1},c{2},n',max(n(:))*[0:0.1:1],varargin{:});