function test_SVM1(X_train,Y_train,X_test,Y_test,num_coeff)
    
    ErrorMin=Inf;
    C_opt_error=0;
    Sigma_opt_error=0;
    NU_opt_error=0; 
    
    CorrMax=-100;
    C_opt_corr=0;
    Sigma_opt_corr=0;
    NU_opt_corr=0;
    
    folds=2;

    NUmin=0.3;
    NUmax=0.3;
    CMin=5;
    CMax=5;
% 
%     NUmin=0.1;
%     NUmax=0.9;
%     CMin=-10;
%     CMax=10;


    count=0;
    
    for var_NU = NUmin:0.1:NUmax
        for var_C = 2.^[CMin:1:CMax]
           
            [out var_sigma corr_test error_test]...
                =SVM_model_grade_CA_RBF...
                (X_train,Y_train,num_coeff,...
                X_test,Y_test,'rbf',var_NU,var_C,folds)
            
            if ErrorMin>error_test || count==0
                ErrorMin=error_test
                C_opt_error=var_C;
                Sigma_opt_error=var_sigma;
                NU_opt_error=var_NU;
            end
            if CorrMax<corr_test || count==0
                CorrMax=corr_test
                C_opt_corr=var_C;
                Sigma_opt_corr=var_sigma;
                NU_opt_corr=var_NU;
            end
            count=count+1;
        end

    end;
    CorrMax
    C_opt_corr
    Sigma_opt_corr
    NU_opt_corr
    
    ErrorMin
    C_opt_error
    Sigma_opt_error
    NU_opt_error
    
end
