for run_ndx=1:100 %100 %21:256
    tic
    disp('------------------------------------------------');
    disp(run_ndx);
%     deleteme_script;
    run_matlab_script_postREF;
    toc
end