for kk=1:(length(k_vec))
    for nn=1:length(N_vec)
            fprintf('k=%d, N=%d, conv: %f \n',k_vec(kk),N_vec(nn),oo{kk,nn}.conv);
            gg(kk,nn)=oo{kk,nn}.conv;
%         disp(oo{kk,nn});
    end

%     disp('------------------------')
end
figure; 
semilogy(N_vec,gg','x-'); 
xlabel('N');
legend(num2str(k_vec'));