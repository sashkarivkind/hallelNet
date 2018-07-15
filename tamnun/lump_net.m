function [lamped_sf_net, str_net] = lump_net(W, N_lamp)
    lamped_sf_net = double(W);
    lamped_sf_net(:,1) = sqrt(sum(W(:, 1:N_lamp), 2));
    lamped_sf_net(1,:) = sqrt(sum(W(1:N_lamp, :), 1));
    lamped_sf_net(1,1) = 0;
    lamped_sf_net(:, 2:N_lamp) = [];
    lamped_sf_net(2:N_lamp, :) = [];
    
    
    N_str = length(W(1, :))-N_lamp+1;
    mean_k_in_net = mean(sum(lamped_sf_net(:, 2:end)));
    str_net_small = createNet(N_str-1, 'binom' , 'binom',  mean_k_in_net, [], [], 'no_sort', 'out') ~= 0;
    str_net = [lamped_sf_net(2:end,1) str_net_small];
    str_net = [lamped_sf_net(1, :); str_net ];
    
end