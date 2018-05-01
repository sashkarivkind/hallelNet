function outstat = async_pertube_fun(W,p)

if ~isfield(p,'update_frac')
    p.update_frac = 0.1;
end
if ~isfield(p,'x_0')
    p.x_0 = randn(size(W));
end
if ~isfield(p,'frozen')
    p.frozen = zeros(size(W,1),1);
end
if ~isfield(p,'t_max')
    p.t_max = 500;
end
if ~isfield(p,'N_perturbations')
    p.N_perturbations = 100;
end
if ~isfield(p,'preturbation_frac')
    p.preturbation_frac = 0.1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation parameters and definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(W(1, :));
T_sim = round(p.t_max/p.update_frac)+1;
N_perturbations=p.N_perturbations;

% for preturbation_frac = [1/N, 0.05, 0.1 0.2]
    pert_diff = zeros(1, N_perturbations);
    pert_diff_fro = zeros(1, N_perturbations);
    pert_diff_2 = zeros(1, N_perturbations);
    x_0_pert = zeros(N, N_perturbations);
    x_f_p_pert = zeros(N, N_perturbations);
    for ind_pert = 1:N_perturbations
        %% initilaize  open loop varibles
        x = zeros(N, T_sim); %initilazie x varibles of open loop  model with constant W
        x(: , 1)  = p.x_0 ; %I.C. for open  loop
        
        N_perturbe_nodes = round(p.preturbation_frac*N);
        ind_perturbe = randperm(N-1, N_perturbe_nodes)+1;
        
        x(ind_perturbe , 1)  = -x(ind_perturbe , 1) ;
        
        c_t=Inf;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Simulate Dynamics
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for ii = 1:T_sim-1
            up_date_nodes = randperm (N, round(N*p.update_frac));
            x(:, ii+1) = x(:,ii);
            x_full_upd =  W*sign(x(:, ii)); %update open loop constant W model, notice this is a simple forward Euler scheme
            x(up_date_nodes, ii+1) =  x_full_upd(up_date_nodes); %update open loop constant W model, notice this is a simple forward Eular scheme
            dlast = sign(x_full_upd)-sign(x(:, ii));
            dx0 = sign(p.x_0)-sign(x(:, ii));
            if ~any(dlast)||~any(dx0(~~p.frozen))
                break
            end;
        end; % end Simulate Dynamics
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %% plot and save results
        %%%%%%%%%%%%%%%%%%%%%%%%%%
%         x(: ,ii+1:T_sim) = [];
        i_fin = max(ii-1,1);

        if ii<T_sim-1 %which means that we reached a fixed point of frozen core
            %                 c_t = (ii-t_stop_i)*update_frac;
            x_0_pert(:, ind_pert) = x(:, 1);
            x_f_p_pert(:, ind_pert) = x(:, i_fin);
            pert_diff(ind_pert) = sum(abs(sign(p.x_0)-sign(x(:, i_fin))) ~= 0);
            pert_diff_fro(ind_pert) = sum(abs(sign(p.x_0(~~p.frozen))-sign(x(~~p.frozen, i_fin))) ~= 0);
        end;
        pert_diff_2(ind_pert) = sum(abs(sign(p.x_0)-sign(x(:, i_fin))) ~= 0);
    end;
% end;
outstat=struct('x_0_pert',x_0_pert,...
    'x_f_p_pert',x_f_p_pert,...
    'pert_diff',pert_diff,...
    'pert_diff_fro',pert_diff_fro,...
    'pert_diff_2',pert_diff_2);




