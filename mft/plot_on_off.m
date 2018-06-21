function plot_on_off(a,b,on_index,opt)
if nargin < 4
 opt=struct;
end

nom.size_on=8;
nom.size_off=8;
nom.newfig=1;
nom.dolegend=1;
nom.legend_fields={'on','off'};

nomfields=fields(nom);
for ff=1:length(nomfields)
    this_field=nomfields{ff};
    if ~isfield(opt,this_field)
        opt.(this_field)=nom.(this_field);
    end
end

if opt.newfig
    figure; 
end

if isfield(opt,'process_subset')
    qq=opt.process_subset;
    a=a(qq);
    b=b(qq);
    on_index=on_index(qq);
end

plot(a(on_index),b(on_index),'.','markersize',opt.size_on)
hold on; 
plot(a(~on_index),b(~on_index),'.','markersize',opt.size_off)

if opt.dolegend
    legend(opt.legend_fields);
end