Nhigh = 200;
fracCross = 0.8;
reps = 20;
res = nan(2,2,reps);
res1 = nan(reps,4);

for r=1:1
    W = randn(Nhigh,2);
    I = k_min_out >= 1;
    x{1} = [mean_k_str(I);sigma_hub(I)];
    x{2} = [k_min_out(I);gamma_k_out(I)];
    z = sign(frozen_core(I)-0.5);
    z=zscore(z);
    for i=1:2
        for j=1:2
            %             x{i}(:,j) = zscore(x{i}(:,j));
            x{i}(j,:) = zscore(x{i}(j,:));
        end
    end
    
    M = round(fracCross*sum(I));
    for i=1:2
        y = tanh( W*x{i} );
        ww = z(1:M)*pinv( y(:,1:M) );
        a=ww*y(:,M:end);
        b=z(M:end);
        res(1,i,r)=mean( b( a>0)>0 );
        res(2,i,r)=mean( b( a<0)>0 );
        x1_grid=linspace(min(x{i}(1,:)),max(x{i}(1,:)),100);
        x2_grid=linspace(min(x{i}(2,:)),max(x{i}(2,:)),100);
        x1_grid=repmat(x1_grid,100,1);
        x2_grid=repmat(x2_grid',1,100);
        y_grid=tanh(W*[x1_grid(:)';x2_grid(:)']) ;
        a_all=ww*y_grid;
        a_all=min(a_all,1);
        a_all=max(a_all,0);
        uu=reshape(a_all,100,100);
        figure; imagesc(uu)
        disp('bum')
        %  figure;plot3(x{i}(1,:),x{i}(2,:),a_all,'x')
        %  zlim([0,1])
    end
    res1(r,1) = res(1,1,r);
    res1(r,2) = res(2,1,r);
    res1(r,3) = res(1,2,r);
    res1(r,4) = res(2,2,r);
    
end

% boxplot(res1);
