clear;

run_prefix = 'dyn_fro';
mc_tries=500;
m_max=10;

N_perturbations = 50;
k_m_out = 1; %minimal degree of power law ditribution of scale free out degree
N_vec=[1000,2000];
b_strength=zeros(length(N_vec),mc_tries,m_max);
for jj=1:length(N_vec);
    N=N_vec(jj);
    for gamma_k_out =2.2%
        for ii=1:mc_tries
            W_top = createNet(N, 'sf' , 'binom', k_m_out, gamma_k_out, [], 'sort', 'out') ~= 0; %create sf-out binom-in network
            for m=1:m_max
                b_strength(jj,ii,m)=sqrt(sum(sum(W_top(:,1:m),2)));
            end
            ii
        end
    end
end

figure;
for m=1:10
hist(b_strength(1,:,m)/sqrt(1000));
hold on;
end