function o=mft_conv_fun(c0,c12,opt)
if nargin<3
    opt = struct;
end
nom.N=1000;
nom.ntries=1000;
nom.t_max=1000;
nom.dinit=0.1;
nom.ana=1;
nom.sim_pupd=0.1;
nom.u=1;
nom.save_hist=0;
nom.enforce_fp=0;

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
fp=zeros(ntries,2);
d_min_vec=2*ones(ntries,1);
if opt.save_hist
    d_hist_matrix=zeros(ntries,t_max);
end
parfor this_try=1:ntries
    d=dinit;
    conv(this_try)=0;
    fp(this_try,:)=[0,0];
    d_hist=2*ones(1,t_max);
    if ~opt.ana
        W=sparse(binoW(N,k));
        s12=sign(randn(N,1)*[1,1]);
        s12(1:round(N*d),1) = -s12(1:round(N*d),1);
        uu=u*randn(N,1)*[1,1]/sqrt(k);
        if opt.enforce_fp
            smat=sign(W*s12(:,1)+uu(:,1));
            smat=smat.*s12(:,1);
            uu=diag(smat)*uu;
            W=sparse(diag(smat)*W);
        end
    end
    for t=1:t_max
        if opt.ana
            [~,d_indx]=min(abs(dd0-d));
            d=binornd(N,dd12(d_indx))/N;
        else
            s12_temp=sign(W*s12+uu);
            fp(this_try,:)=all(s12_temp==s12,1);
            upd_index=rand(N,1)<opt.sim_pupd;
            s12(upd_index,:)=s12_temp(upd_index,:);
            d=mean(s12(:,1)~=s12(:,2));
        end
        conv(this_try) = d<1/N;
        d_hist(t)=d;
        d_min_vec(this_try)=min(d_hist);
        if all(fp(this_try,:)) %breaking only if both trajectories reached a fixed point
            break
        end
    end
    if opt.save_hist
        d_hist_matrix(this_try,:)=d_hist;
    end
end
o.conv=conv;
o.d_min=d_min_vec;
o.fp=fp;
if opt.save_hist
    o.d_hist_matrix=d_hist_matrix;
end