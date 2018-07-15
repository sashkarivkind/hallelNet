xxx = ceil(100*sum(clock) + 7*run_ndx);
rng(xxx);



%% intilize
%clear all;
%close all;

set(0,'DefaultAxesFontSize',10); %set graphics
set(0,'defaultaxesfontsize',10)  %set graphics

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Network parameters
%%%%%%%%%%%%%%%%%%%%%%%%%

N =1500;
%% degree distributions parameters
%gamma_k_out = 2.1 + 0.8*rand(1,1); % power of power law ditribution of scale free out degree
%k_m_out = 1 + 0.5*rand(1,1); %minimal degree of power law ditribution of scale free out degree
k_m_out = 1;
gamma_k_in = 2.2; % power of power law ditribution of scale free in
% degree -  this is relevant only if network
% topology is sf-out and sf-in
avg_k = 4.8;
%% network interaction parameters
g_w = 10; %standard diviation of random matrix non zero wights
m_w = 0; % mean of random matrix non zero wights



%%%%%%%%%%%%%%
%% Other
%%%%%%%%%%%%%%
update_frac = 0.1;
t_int = 0;  %start simulation at t_int
t_max = 1000;  % if network does not converge end simulation at t=t_max
D = 10^-3; %random walk coefficient for W non zero wights,
%this relats f(s) to the RW, and detremines the relation
%between the x-dynamics time scale and the Random walk time
%scale.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation parameters and definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%dt = 0.01;
T_sim = round(t_max/update_frac)+1;

T_stop = 20; %if network f_s is below esp_quit for T_stop time units then the network
t_stop_i = round(T_stop/update_frac);
%T_stop = 20; %if network f_s is below esp_quit for T_stop time units then the network
%has converged and the simulation should be quit
esp_quit = 10^-1; %stoping creatirea for determining if a network has converged
T_track = 10;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Create Interaction Matrix, W
% %%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = 1;
N_hubs =  1;


k = 4;
%W_top = star_mat(N, k, 'binom_star', N_hubs) ~=0;

m_lump = 4;
%gamma_k_out = 2.1 + 0.8*rand(1,1); % power of power law ditribution of scale free out degree
for gamma_k_out = [2.2 2.4 2.6]
    switch gamma_k_out
        case 2.2
            gamma_str = '2_2';
        case 2.4
            gamma_str = '2_4';
        case 2.6
            gamma_str = '2_6';
        
    end;
    W_sf_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create network topology matrix
    
    [W_lamped_sf_top, W_str_top] = lump_net(W_sf_top, m_lump);
    N_small = length(W_str_top(1, :));
    mean_k = mean(sum(W_sf_top, 2));
    N_W_sf = sum(sum(W_sf_top));
    %     N_W_sf_lamped = sum(sum(W_lamped_sf_top));
    N_W_str = sum(sum(W_str_top));
    mean_k_str = mean(sum(W_str_top(2:end, 2:end)));
    sigma_hub = sqrt(sum(mean(W_sf_top(:, 1:m_lump))));
    
    results(1, ll) = sigma_hub;
    results(2, ll) = mean_k_str;
    results(3, ll) = gamma_k_out;
    % results(4, ll) = k_m_out;
    results(4, ll) = mean_k;
    
    a = log(flip(sum(W_sf_top)));
    l = length(a);
    b=log(1-[0:1/l:(1-1/l)]);
    
    gamma_fit = -((b*a')/(a*a')-1);
    results(5, ll) = gamma_fit;
    
    %W_top = createNet(N, 'binom' , 'sf', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create network topology matrix
    %W_top = createNet(N, 'binom' , 'binom', 5, [], [], 'sort', 'out') ~= 0; %create network topology matrix
    % net_type = 'binom_star';
    %W_top = star_mat(N, avg_k, net_type);
    %W_top = star_mat(N, 4, 'binom_star', 1) ~=0;
    %
    %mean_k = mean(sum(W_top));
    
    %W_top  = W_int ~=0;
    %N = length(W_top);
    %W_top = createNet(N, 'binom' , 'binom', mean_k, [], [], 'sort', 'out') ~= 0; %create network topology matrix
    W = sparse(N, N);
    mean_k = mean(sum(W_sf_top, 2));
    N_W_n_z = sum(sum(W_sf_top));
    W(W_sf_top) = (g_w/(sqrt(mean_k)))*randn(N_W_n_z, 1); %randomize interaction matrix, W_int, with given topology W_top
    %the variance of interaction strengths is g^2/<k>
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% intialaize simulation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% initilaize  open loop varibles
    x = NaN(N, T_sim); %initilazie x varibles of open loop  model with constant W
    x(: , 1)  = (g_w/sqrt(mean_k))*randn(N , 1) ; %I.C. for open  loop
    %x_w_const(: , 1) = IC;
    %W_c = w;
    %norm_x = zeros(1, T_sim-1);
    c_t=Inf;
    count_zero = 0;
    z = [];
    y = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Simulate Dynamics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    for ii = 1:T_sim-1
        
        %ii*dt
        up_date_nodes = randperm (N, round(N*update_frac));
        %x(1, ii) = 1;
        x(:, ii+1) = x(:,ii);
        x(up_date_nodes, ii+1) =  W(up_date_nodes, :)*sign(x(:, ii)); %update open loop constant W model, notice this is a simple forward Eular scheme
        %x(1, ii+1) = 1;
        
    end; % end Simulate Dynamics
    
    l = 200/update_frac;
    X = x(:, T_sim-1)*ones(1, l);
    
    
    
    
    
    B =  0.5*abs(sign(X)- sign(x(:, (end-3-l):(end-4))));
    D = sum(B, 2);
    
    
    forzen_core = sum(D==0)/N;
    results(6, ll) = forzen_core;
    
    
    save(['sf_b_gamma_' gamma_str 'run_ndx_' num2str(run_ndx) '.mat'], 'results');
    
    
end;







