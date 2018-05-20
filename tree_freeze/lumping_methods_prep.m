function o=lumping_methods_prep(N,m);
    function [W_,x_,fro_,constr_]=fun1(W,x,fro,constr)
        W_=W;
        x_=x;
        fro_=fro;
        constr_=constr;
    end
    function [W_,x_,fro_,constr_]=fun2(W,x,fro,constr)
        tmp=[[ones(1,m);zeros(N-m,m)], [zeros(1,N-m);eye(N-m)]];
        W_=tmp*W*tmp';
        x_=x(m:end,:);
        fro_=fro(m:end);
        constr_=constr(m:end);
    end
o{1}=@fun1;
o{2}=@fun2;
end