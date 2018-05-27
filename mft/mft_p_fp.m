kk=4 ;
k=k_vec(kk);
ntries=1000;
t_max=1000;
dinit=0.1;
dd12=0.5*(1-c12_rec{kk});
dd0=0.5*(1-c0);
conv=zeros(ntries,1);
d_min_vec=2*ones(ntries,1);
parfor this_try=1:ntries
    d=dinit;
    conv(this_try)=0;
    d_hist=-ones(t_max,1);
    for t=1:t_max
        [~,d_indx]=min(abs(dd0-d));
        d=binornd(N,dd12(d_indx))/N;
        conv(this_try) = d<1/N;
        d_hist(t)=d;
        d_min_vec(this_try)=min(d_hist);
        if conv(this_try)
            break
        end
    end
%     figure; plot(d_hist,'x-');pause;
end
disp(mean(conv));