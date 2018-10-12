figure;
hold on;
fie='frozen_core';
sym_sigma_vec='xo+';
col_N_vec = 'crgb';
stst='-';

N_vec=sort(unique(vv.param.N));
for nn=1:length(N_vec)
    N=N_vec(nn);
    colcol=col_N_vec(nn);
    c0=vv.param.N==N;
    kin_vec=4;%sort(unique(vv.param.kinhub_str_manu));
    for ii=1:length(kin_vec)
        kin=kin_vec(ii);
        c1=vv.param.kinhub_str_manu==kin;
        
        sigma_vec=sort(unique(vv.param.sighub_str_manu));
        for jj=1:length(sigma_vec)
            sigma=sigma_vec(jj);
            symsym=sym_sigma_vec(jj);
            c2=vv.param.sighub_str_manu==sigma;
            yy.(fie)=zeros(size(vv.param.k_str_manu(c0&c1&c2)));
            kk=0;
            xx=sort(vv.param.k_str_manu(c0&c1&c2));
            for kstr=xx
                kk=kk+1;
                c3=vv.param.k_str_manu==kstr;
                yy.(fie)(kk)=mean(vv.str_ol_sim.(fie)(c0&c1&c2&c3)>0.9);
            end
            plot(xx,yy.(fie),[symsym,colcol,stst],'linewidth',1.5);
        end
    end
end



%         k_str=sort(unique(vv.param.k_str_manu));
%         for
%         vv.str_sim.frozen_core