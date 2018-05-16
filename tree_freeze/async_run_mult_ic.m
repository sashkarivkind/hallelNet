function outstat = async_run_mult_ic(W,p)

if ~isfield(p,'update_frac')
    p.update_frac = 0.1;
end
if ~isfield(p,'t_max')
    p.t_max = 500;
end

if all(isfield(p,{'N_ic','x_0'}))
    error('contradicting definitions for initial conditions');
end

if isfield(p,'N_ic')
    p.x_0 = randn(size(W,1),p.N_ic);
elseif isfield(p,'x_0')
    p.N_ic = size(p.x_0,2);
else
    p.N_ic = 100;
    p.x_0 = randn(size(W,1),p.N_ic);
end

if ~isfield(p,'preturbation_frac')
    p.preturbation_frac = 0.1;
end
N = length(W(1, :));
T_sim = round(p.t_max/p.update_frac)+1;
if ~isfield(p,'persist_th')
    p.persist_th = T_sim/3;
end

%Defined double interface for the frozen/constraints to ensure backward
%compatability
if isfield(p,'fro_conf') && any(isfield(p,{'constr','frozen'}))
    error('contradicting definitions for frozen core');
end
if ~isfield(p,'frozen')
    p.frozen = zeros(size(W,1),1);
end
if ~isfield(p,'constr')
    p.constr = zeros(size(W,1),1);
end
if ~isfield(p,'fro_conf')
    p.fro_conf=struct('sfro',p.frozen,'constr',p.constr);
end
p.constr = p.fro_conf.constr;
p.frozen = p.fro_conf.sfro;

for fldn={'constr','frozen'}
    ff=fldn{1};
    if size(p.(ff),2)==1
        p.(ff)=repmat(p.(ff),1,p.N_ic);
    end
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
    x_full_upd =  W*prep_s_eff(sign(x),p.constr,0);
    s_fixed = sign(x) == sign(x_full_upd);
    s_persist=s_persist.*s_fixed+s_fixed; % count timesteps without a change at this position
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
fro_min=sum(all(s_persist>p.persist_th,2));
fro_preserve=sum(s_persist(~~p.frozen(:,1),:)>p.persist_th);
fro_full = sign(x).*(s_persist>p.persist_th);
outstat=struct(...
    'fro_dyn',fro_dyn,...
    'fro_preserve', fro_preserve,...
    'fro_min', fro_min,...
    'fro_full', fro_full,...
    'hyper_param',p...
    );




