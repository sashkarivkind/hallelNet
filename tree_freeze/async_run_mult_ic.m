function outstat = async_run_mult_ic(W,p)

if ~isfield(p,'update_frac')
    p.update_frac = 0.1;
end
if ~isfield(p,'frozen')
    p.frozen = zeros(size(W,1),1);
end
if ~isfield(p,'constr')
    p.constr = zeros(size(W,1),1);
end
if ~isfield(p,'t_max')
    p.t_max = 500;
end
if ~isfield(p,'N_ic')
    p.N_ic = 100;
end
if ~isfield(p,'preturbation_frac')
    p.preturbation_frac = 0.1;
end
if ~isfield(p,'x_0')
    p.x_0 = randn(size(W),p.N_ic);
end
N = length(W(1, :));
T_sim = round(p.t_max/p.update_frac)+1;
if ~isfield(p,'persist_th')
    p.persist_th = T_sim/3;
end
if ~isfield(p,'fro_conf')
    p.fro_conf=struct('sfro',p.frozen,'constr',p.constr);
end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation parameters and definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


x  = p.x_0 ; %Initial conditions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate Dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_persist=zeros(size(x));
for ii = 1:T_sim
    update_mask =rand(size(x))<p.update_frac;
    x_next = x;
    x_full_upd =  W*sign(x); 
    s_fixed = sign(x) == sign(x_full_upd);
    s_persist=s_persist.*s_fixed+s_fixed;
    x_next(update_mask) =  x_full_upd(update_mask);
    x=x_next;
    c_fp=all(s_fixed(:)); %reached f.p. in all the perturbation scenaria.
    if c_fp
        p.persist_th=0;
        break
    end;
end; % end Simulate Dynamics

%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot and save results
%%%%%%%%%%%%%%%%%%%%%%%%%%
fro_dyn=sum(s_persist>p.persist_th);
fro_preserve=sum(s_persist(~~p.frozen,:)>p.persist_th);
outstat=struct(...
    'fro_dyn',fro_dyn,...
    'fro_preserve', fro_preserve,...
    'hyper_param',p...
    );




