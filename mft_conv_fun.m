function o=mft_conv_fun(c0,c12,opt)
if nargin<3
    opt = struct;
end
nom.N=1000;
nom.ntries=1000;
nom.t_max=1000;
nom.dinit=0.1;
nom.ana=1;
nom.ana_pupd=0.1;
nom.u=1;

nomfields=fields(nom);
for ff=1:length(nomfields)
    this_field=nomfields{ff};
    if ~isfield(opt,this_field)
        opt.(this_field)=nom.(this_field);
    end
end

N=opt.N;
k=opt.k;
ntries=opt.ntries;
t_max=opt.t_max;
dinit=opt.dinit;
u=opt.u;

dd12=0.5*(1-c12);
dd0=0.5*(1-c0);
conv=zeros(ntries,1);
d_min_vec=2*ones(ntries,1);
parfor this_try=1:ntries
    d=dinit;
    conv(this_try)=0;
    d_hist=2*ones(t_max,1);
    if ~opt.ana
        W=sparse(binoW(N,k));
        s12=sign(randn(N,1)*[1,1]);
        s12(1:round(N*d),1) = -s12(1:round(N*d),1);
        uu=u*randn(N,1)*[1,1];
    end
    for t=1:t_max
        if opt.ana
            [~,d_indx]=min(abs(dd0-d));
            d=binornd(N,dd12(d_indx))/N;
        else
            s12_temp=sign(W*s12+uu);
            upd_index=rand(N,1)<nom.ana_pupd;
            s12(upd_index,:)=s12_temp(upd_index,:);
            d=mean(s12(:,1)~=s12(:,2));
        end
        conv(this_try) = d<1/N;
        d_hist(t)=d;
        d_min_vec(this_try)=min(d_hist);
        if conv(this_try)
            break
        end
    end
end
o.conv=mean(conv);
o.d_min=d_min_vec;