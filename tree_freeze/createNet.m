function net_mat = createNet(N, out_dist, in_dist, dist_parm1, dist_parm2, dist_parm3, sort_net, sort_type, TryNdx)

%%Input Error check and asign defult values

if (N < 1)
    error('createNet:distCheck', 'N < 1');
end;
if  ~strcmp(out_dist,'sf') && ~strcmp(out_dist,'exp') && ~strcmp(out_dist,'binom')
    error('createNet:distCheck', 'No such out distribution');
end;
if  ~strcmp(in_dist,'sf') && ~strcmp(in_dist,'exp') && ~strcmp(in_dist,'binom')
    error('createNet:distCheck', 'No such in distribution');
end;
if strcmp(in_dist,'sf') || strcmp(out_dist,'sf')
    if ~exist('dist_parm2', 'var')
        error('createNet:distCheck', 'SF dist needs two parameters');
    end;
    if strcmp(in_dist,'sf') && strcmp(out_dist,'sf')
        if ~exist('dist_parm3', 'var')
            error('createNet:distCheck', 'duoble SF dist needs three parameters');
        end;
    end;
end;
if ~exist('sort_net', 'var')
    sort_net = 'no_sort';
    
else
    if ~strcmp(sort_net,'sort') && ~strcmp(sort_net,'no_sort')
        error('createNet:distCheck', 'Bad sort command');
    end;
end;

if ~exist('sort_type', 'var')
    sort_type = 'out';
else
    if ~strcmp(sort_type,'out') && ~strcmp(sort_type,'in')
        error('createNet:distCheck', 'No such sort option');
    end;
end;

if ~exist('TryNdx', 'var')
    TryNdx = 0;
end;
switch out_dist
    case 'sf'
        switch in_dist
            case 'sf'
                str = 's_s';
            case 'exp'
                str = 's_e';
            case 'binom'
                str = 's_b';
        end;
    case 'exp'
        switch in_dist
            case 'sf'
                str = 'e_s';
            case 'exp'
                str = 'e_e';
            case 'binom'
                str = 'e_b';
        end;
    case 'binom'
        switch in_dist
            case 'sf'
                str = 'b_s';
            case 'exp'
                str = 'b_e';
            case 'binom'
                str = 'b_b';
        end;
end;

%% create Deg List
net_mat = zeros(N,N);
graphical = 0;
binom_net = false;
while ~graphical
    
    switch out_dist
        
        case 'sf'
            out_gamma = dist_parm2;
            out_k_m = dist_parm1;
%             if (out_gamma < 2) |  (out_k_m<=0)
%                 %error('creatOut_SF_In_SF_Net:distCheck', 'Illigal ditribution parameters')
%             end;
            deg(:, 2) = round(prnd(out_gamma-1, out_k_m, N, 1) );
            deg(deg(:, 2) > N-1, 2) = N-1;
            mean_out_deg = mean(deg(:, 2));
            deg_diff = 1;
            
            while abs(deg_diff) > 0 & ~binom_net
                switch in_dist
                    case 'sf'
                        in_gamma = dist_parm3;
                        mean_out_deg = out_k_m*(out_gamma-1)/(out_gamma-2); %compute out theorectical degree mean
                        in_k_m = out_k_m*((out_gamma-1)*(in_gamma-2))/((out_gamma-2)*(in_gamma-1));
                        deg(:, 1) = round(prnd(in_gamma-1, in_k_m, N, 1) );
                    case 'exp'
                        mu = mean_out_deg;
                        deg(:, 1) = round(exprnd(mu, N, 1) ); %in degree
                    case 'binom'
%                         p = mean_out_deg/N;
%                         deg(:, 1) = round(binornd(N,p, N, 1) );
                          for kk=1:N
                             
                              ind_binom = randperm(N, deg(kk, 2));
                              colum_kk = zeros(N, 1);
                              colum_kk(ind_binom) = ones(1, length(ind_binom));
                              net_mat(:, kk) = colum_kk;
                              
                          end;
                          binom_net = true;
                          graphical = true;
                        
                end;
                deg(deg(:, 1) > N-1, 1) = N-1;
                deg_diff = sum(deg(:, 1)) - sum(deg(:, 2));
                
            end;
            
            
        case 'exp'
            
            out_mu = dist_parm1;
            deg(:, 2) = round(exprnd(out_mu, N, 1) );
            deg(deg(:, 2) > N-1, 2) = N-1;
            
            mean_out_deg = mean(deg(:, 2));
            deg_diff = 1;
            
            while abs(deg_diff) > 0 & ~binom_net
                switch in_dist
                    case 'sf'
                        net_mat = createNet(N, 'sf', 'exp', dist_parm1, dist_parm2, [], sort_net, sort_type, [str num2str(TryNdx)])';
                        return;
                    case 'exp'
                        mu = mean_out_deg;
                        deg(:, 1) = round(exprnd(mu, N, 1) ); %in degree
                    case 'binom'
                        %deg(:, 1) = round(binornd(N,mean_out_deg/N, N, 1) );
                        for kk=1:N
                            ind_binom = randperm(N, deg(kk, 2));
                            colum_kk = zeros(N, 1);
                            colum_kk(ind_binom) = ones(1, length(ind_binom));
                            net_mat(:, kk) = colum_kk;
                            
                            
                        end;
                        binom_net = true;
                        graphical = true;
                end;
                deg(deg(:, 1) > N-1, 1) = N-1;
                deg_diff = sum(deg(:, 1)) - sum(deg(:, 2));
                
            end;
            
        case 'binom'
            
            avg = dist_parm1;
            deg(:, 2) = round(binornd(N,avg/N, N, 1) );
            deg(deg(:, 2) > N-1, 2) = N-1;

            
            mean_out_deg = mean(deg(:, 2));
            deg_diff = 1;
            
            while abs(deg_diff) > 0 & ~binom_net
                switch in_dist
                    case 'sf'
                        net_mat = createNet(N, 'sf', 'binom', dist_parm1, dist_parm2, [], sort_net, sort_type, [str num2str(TryNdx)])';
                        return;
                    case 'exp'
                        net_mat = createNet(N, 'exp', 'binom', dist_parm1, [], [], sort_net, sort_type, [str num2str(TryNdx)])';
                        return;
                    case 'binom'
                        %deg(:, 1) = round(binornd(N,mean_out_deg/N, N, 1) );
                        for kk=1:N
                            ind_binom = randperm(N, deg(kk, 2));
                            colum_kk = zeros(N, 1);
                            colum_kk(ind_binom) = ones(1, length(ind_binom));
                            net_mat(:, kk) = colum_kk;
                            
                        end;
                        binom_net = true;
                        graphical = true;
                end;
                deg(deg(:, 1) > N-1, 1) = N-1;
                deg_diff = sum(deg(:, 1)) - sum(deg(:, 2));
                
            end;
    end;
    deg = sortrows(deg);
    deg = flipud (deg);
    if ~graphical
        for kk = 1:N-1
            C = bsxfun(@min,deg(:, 2),(kk-1)*ones(N,1));
            D = bsxfun(@min,deg(:, 2),(kk)*ones(N,1));
            graphical = sum(deg(1:kk, 1)) <= (sum(C(1:kk)) + sum(D(kk+1:N)));
            %sum(deg(1:kk, 1)) - (sum(C(1:kk)) + sum(D(kk+1:N)))
        end;
    end
end;


%% create Network
if ~binom_net
    net_mat = DegList2Graph_T(deg, [str num2str(TryNdx)]);
end;

net_mat = net_mat(:,randperm(N));
net_mat = net_mat(randperm(N), :);

if strcmp(sort_net,'sort')
    if strcmp(sort_type,'out')
        net_mat = net_mat';
    end;
    net_mat(:, N+1) = sum(net_mat, 2);
    net_mat = sortrows(net_mat,N+1);
    net_mat(:, N+1)=[];
    net_mat = flipud (net_mat);
    net_mat = net_mat(:,randperm(N));
    if strcmp(sort_type,'out')
        net_mat = net_mat';
    end;

end;