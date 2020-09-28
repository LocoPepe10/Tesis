function [error_test]=linear_regression_model_grade_CA...
    (coeff_in,CAI_out,number_coeff,coeff_new,CAI_out_new)

    xb0=ones(length(coeff_in))'
    %length(CAI_out)
    
    
    x=[xb0;coeff_in]
    y=CAI_out
    x_test=[xb0;coeff_new]
    y_test=CAI_out_new
    
    %a=mvregress(coeff_in,CAI_out)
    [b bint e eint stats]=regress(y,x)
    
    yp_LR=x*b
    
    yp_test=x_test*b
    
    corr(yp_test,y_test)
    
    

%     plot(data_test.Y,CAI_est.X,'r+');
%     
%     corr_train=corr(a.X==1,data_train.Y)
%     
%     error_train=ecm_norm(a.X==1,data_train.Y)

    
end