function [Xo,iio,bbo]=kd_tree_with_min_backet(X,min_backet,ii,bb)
%INPUT
%X - N x d matrix
%minimal bin size allowed
%ii - original indexes
%bb - original binning
%OUTPUT:
%Xo - X reordered according to bins
%iio - indexes
%bbo - bin (cluster) number assigned
if nargin<4
    bb=zeros(size(X,1),1);
end
if nargin<3
    ii=(1:size(X,1))';
end
d=size(X,2);

if size(X,1)<=(2^d)*min_backet
    Xo=X;
    iio=ii;
    bbo=bb;
else
    Xo=[];
    iio=[];
    bbo=[];
    onesN=ones(size(X,1),1);
    greaterThanMedian = (onesN*median(X)) < X;
    for branch=0:(2^d-1)
        branch_mask=onesN*de2bi(branch,d);
        final_mask=all(xor(branch_mask,greaterThanMedian),2);
        bb_new=(2^d)*bb(final_mask)+branch;
        [X_tmp,ii_tmp,bb_tmp] = kd_tree_with_min_backet(X(final_mask,:),min_backet,ii(final_mask),bb_new);
        Xo=[Xo;X_tmp];
        iio=[iio;ii_tmp];
        bbo=[bbo;bb_tmp];
    end %for
end %if

