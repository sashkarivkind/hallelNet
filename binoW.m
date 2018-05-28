function W=binoW(N,k)
W=(rand(N)<k/N).*randn(N)/sqrt(k);