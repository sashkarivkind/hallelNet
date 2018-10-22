N=1500;
u0=0.5;
matrix_per_param=10;
patterns_per_net=10;
%nodes_per_pattern=N;
k_vec=2:0.25:4;
max_div_d=round(5*max(k_vec));
div_d_rec={};
div_d_bins = 0:max_div_d;
for kk=1:length(k_vec)
    k=k_vec(kk);
    div_d_rec{kk}=zeros(size(div_d_bins));
    for ii=1:matrix_per_param
        tic;
        W_top=rand(N)<k/N;
        W=W_top.*randn(N);
        u=u0*repmat(randn(N,1),1,patterns_per_net*N);
        patterns=sign(randn(N,patterns_per_net));
        patterns_p = kron(patterns,ones(1,N));
        toggle_one_bit=repmat(ones(N)-2*eye(N),1,patterns_per_net);
        patterns_n = patterns_p.*toggle_one_bit;
        Xp=W*patterns_p+u;
        Xn=W*patterns_n+u;
        div_d_rec{kk}=div_d_rec{kk}+...
            hist(sum(sign(Xp)~=sign(Xn),1),div_d_bins);
        disp(ii);
        toc;
    end
end