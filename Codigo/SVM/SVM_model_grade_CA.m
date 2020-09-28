function [CAI_est var_C corr_test error_test]=SVM_model_grade_CA...
    (coeff_in,CAI_out,number_coeff,coeff_new,CAI_out_new,kernel_in,var_NU,var_sigma,n_folds)

    
    svm_kernel=svm(kernel(kernel_in));          %set a kernel type
    range_C=2.^[-10:1:10];                      %set a param C range
    svm_kernel_C=param(svm_kernel,'C',range_C); %set a param C range on a kernel
    a3=param(svm_kernel,'nu',[0:0.1:1]);
    %svm_kernel_C.nu=var_NU;                     %set a value of NU
    %svm_kernel_C.=var_sigma;                     %set a value of NU
    
    hyperparameters_grid=['score=cv;score.folds=' int2str(n_folds)];
    %set hyperparameters score cv and folds=n_folds
    
    svm_kernel_C_cv=gridsel(svm_kernel_C,{hyperparameters_grid});
    %returns a gridsel object initialized with algorithms svm_kernel_C and 
    
    data_train=data(coeff_in,CAI_out);          %input and output data set 
    
    [a r]=train(svm_kernel_C_cv,data_train);%training a SVM with a data set
    
    %disp('-----------------------')
    disp('-----------------------')
    var_C=log2(r.best.C)
    pause
    disp('-----------------------')
    data_test=data(coeff_new,CAI_out_new)
    CAI_est=test(r,data_test);
    
    %disp('-----------------------')
    
%     I=find(data_train.Y==1);clf;hold on;
%     plot(data_train.X(I,1),data_train.X(I,2),'ro');
%     
%     I=find(data_train.Y==-1);
%     plot(data_train.X(I,1),data_train.X(I,2),'bo');
%     
%     I=find(a.X==1);
%     plot(data_train.X(I,1),data_train.X(I,2),'r+');
%     I=find(a.X==-1);
%     plot(data_train.X(I,1),data_train.X(I,2),'b+');
%     close all
    
    I=find(data_test.Y==1);clf;hold on;
    plot(data_test.X(I,1),data_test.X(I,2),'ro');
    
    I=find(data_test.Y==-1);
    plot(data_test.X(I,1),data_test.X(I,2),'bo');
    
    I=find(CAI_est.X==1);
    plot(data_test.X(I,1),data_test.X(I,2),'r+');
    I=find(CAI_est.X==-1);
    plot(data_test.X(I,1),data_test.X(I,2),'b+');
    
    corr_train=corr(a.X==1,data_train.Y)
    corr_test=corr(CAI_est.X,data_test.Y)
    
    error_train=ecm_norm(a.X==1,data_train.Y)
    error_test=ecm_norm(CAI_est.X,data_test.Y)

    
end