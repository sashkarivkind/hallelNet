N=20; k=3;
max_mag=3;
min_mag=-1;
mc_tries=1000;
nfro_vec=zeros(1,mc_tries);
nfp_vec=zeros(1,mc_tries);
for ii=1:mc_tries
    mag=min_mag+rand*(max_mag-min_mag);
    W_top=rand(N)<k/N;
    W=W_top.*randn(size(W_top));
    b=10^mag*randn(N,1);
    [nfro_vec(ii),steps]=fc_calc_synch(W,b);
    [~,h_fp,x,y]=exhaustive_fp_stat_drive(W,b);
    nfp_vec(ii)=sum(h_fp);
    if (nfro_vec(ii)==0)&&(nfp_vec(ii)==1)
        disp('spotted one');
        break
    end
    disp(ii)
end