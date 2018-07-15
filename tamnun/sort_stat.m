
clear all;

num_of_tries = 118;
N = 1500;
g = 10;


data = [];
for gamma_k_out = [2.2 2.4 2.6]
    switch gamma_k_out
        case 2.2
            gamma_str = '2_2';
        case 2.4
            gamma_str = '2_4';
        case 2.6
            gamma_str = '2_6';
            
    end;
    data = [];
    for run_ndx = 17: num_of_tries
        
        if exist(['/u/omrilab/hallel/run/temp/' 'sf_b_gamma_' gamma_str 'run_ndx_' num2str(run_ndx) '.mat'], 'file') == 2
            load(['/u/omrilab/hallel/run/temp/' 'sf_b_gamma_' gamma_str 'run_ndx_' num2str(run_ndx) '.mat']);
            
            run_ndx
            
            data = [data results];
            
            
            %             del_indx = find([data{1, :}] == -1);
            %             data(:, del_indx) = [];
        end;
        
    end;
    
    
    
    
    eval(['gamma_' gamma_str '_all=' 'data;']);
    save(['gamma_' gamma_str '_all'], ['gamma_' gamma_str '_all']);
    % end;
    
end;







