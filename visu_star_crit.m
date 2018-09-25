figure;
hold on;
fie='frozen_core';
kin_vec=sort(unique(vv.param.kinhub_str_manu));
for ii=1:length(kin_vec)
    kin=kin_vec(ii);
        c1=vv.param.kinhub_str_manu==kin;

    sigma_vec=sort(unique(vv.param.sighub_str_manu));
    for jj=1:length(sigma_vec)
        sigma=sigma_vec(jj);
        c2=vv.param.sighub_str_manu==sigma;
        yy.(fie)=zeros(size(vv.param.k_str_manu(c1&c2)));
        kk=0;
        xx=sort(vv.param.k_str_manu(c1&c2));
        for kstr=xx
            kk=kk+1;
            c3=vv.param.k_str_manu==kstr;
            yy.(fie)(kk)=mean(vv.str_sim.(fie)(c1&c2&c3)>0.95);
        end
        plot(xx,yy.(fie),'x-');
    end
end

        
        
        
%         k_str=sort(unique(vv.param.k_str_manu));
%         for 
%         vv.str_sim.frozen_core