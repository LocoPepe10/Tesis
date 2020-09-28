function test_LR(X_train,Y_train,X_test,Y_test,num_coeff)
    
    ErrorMin=Inf;
    C_opt_error=0;
    Sigma_opt_error=0;
    NU_opt_error=0; 
    
    CorrMax=-100;
    C_opt_corr=0;
    Sigma_opt_corr=0;
    NU_opt_corr=0;
    
       
            [error_test]...
                =linear_regression_model_grade_CA...
                (X_train,Y_train,num_coeff,...
                X_test,Y_test)


    
    
end