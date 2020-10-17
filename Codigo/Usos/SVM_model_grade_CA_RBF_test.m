function [CAI_est var_sigma corr_test error_test]=SVM_model_grade_CA_RBF_test(coeff_in,CAI_out,number_coeff,coeff_new,CAI_out_new,kernel_in,var_NU,var_C,n_folds)

    
    svm_kernel=svr(kernel(kernel_in));          %set a kernel type
    %range_sigma=2.^[4:1:5];                    %set a param sigma range
    range_sigma=2.^4; 
    svm_kernel_sigma=param(svm_kernel,'rbf',range_sigma); %set a param sigma range on a kernel
    %a3=param(svm_kernel,'nu',[0:0.1:1]);
    svm_kernel_sigma.nu=var_NU;                     %set a value of NU
    svm_kernel_sigma.C =var_C;                      %set a value of C
    svm_kernel_sigma.optimizer='andre';
    
    hyperparameters_grid=['score=cv;score.folds=' int2str(n_folds)];
    %set hyperparameters score cv and folds=n_folds
    
    svm_kernel_cv=gridsel(svm_kernel_sigma,{hyperparameters_grid});
    %returns a gridsel object initialized with algorithms svm_kernel_C and 
    
    data_train=data(coeff_in,CAI_out);          %input and output data set 
    
    %[a r]=train(svm_kernel_sigma,data_train);%training a SVM with a data set
    
    %[a r]=train(svm_kernel_cv,data_train);%training a SVM with a data set
    %[a r]=train(svm_kernel_cv,coeff_in,CAI_out);%training a SVM with a data set
    
    
    disp('-----------------------')
    %save('svm_net.mat','r')
    
    %var_sigma=log2(r.best.rbf)
    %pause
    disp('-----------------------')
    net_=load('svm_net.mat');
    r=net_.r;
    data_test=data(coeff_new,CAI_out_new);
    CAI_est=test(r,data_test);
    
    %disp('-----------------------')
    mitad=length(CAI_out_new)/2;
    n=0;
    CAI_out_new_nc=CAI_out_new(1:mitad);
    CAI_out_new_hc=CAI_out_new(mitad+1:mitad*2);
    
    %Valores nuevos
    CAI_est_nc    =CAI_est.X(1:mitad,1);
    CAI_est_hc    =CAI_est.X(mitad+1:mitad*2,1);
    dif_SVM = round(CAI_est_nc) - round(CAI_est_hc)
%     figure
%     plot(dif_SVM)
%     pause
%     dif_norm= CAI_out_new_nc - CAI_out_new_hc
%     figure
%     plot(dif_norm)
%     pause
    
%     for i=1:10
%          aux=length(find(CAI_out_new_nc==i));
%          if(aux>n_nc)
%              n_nc=aux;
%          end
%     end
%     for i=1:10
%          aux=length(find(CAI_out_new_hc==i));
%          if(aux>n_hc)
%              n_hc=aux;
%          end
%     end
%     
% 	ARI_nc=ones(n_nc,10);
%     ARI_hc=ones(n_hc,10);
% 
%     for i=0:9
%         I=find(CAI_out_new==i);
%         n=length(I);
%         if n~=0
%             ARI(1:n,i+1)=CAI_est.X(I,1)
%         end
%     end
%     figure
% 	boxplot(ARI)
% 	pause
%     for i=0:9
%         I=find(CAI_out_new_hc==i);
%         n=length(I);
%         if n~=0
%             ARI(1:n,i+1)=CAI_est.X(I,1)
%         end
%     end
%     figure
% 	boxplot(ARI)
% 	pause
%--------------------------------------------------------------------------
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
    
%     I=find(data_test.Y==1);clf;hold on;
%     plot(data_test.X(I,1),data_test.X(I,2),'ro');
%     
%     I=find(data_test.Y==-1);
%     plot(data_test.X(I,1),data_test.X(I,2),'bo');
%     
%     I=find(CAI_est.X==1);
%     plot(data_test.X(I,1),data_test.X(I,2),'r+');
%     I=find(CAI_est.X==-1);
%     plot(data_test.X(I,1),data_test.X(I,2),'b+');

%     plot([1:length(data_test.Y)],data_test.Y,'bo');
%     plot([1:length(data_test.Y)],CAI_est.X,'r+');
%--------------------------------------------------------------------------

%plot([1:length(data_test.Y)],data_test.Y,'bo');
%     figure
%     plot(CAI_out_new_nc,CAI_est_nc,'r+');hold on
%     plot(CAI_out_new_hc,CAI_est_hc,'bo');
    
    %Calculo de ROC
    [k11 k21 A1]=make_roc([CAI_est_nc,CAI_est_hc])
    [k12 k22 A2]=make_roc([CAI_out_new_nc,CAI_out_new_hc])

    hold on;
    plot(k21,k11,'b');
    plot(k22,k12,'r');

    pause
    figure
    plotroc(k21,k11);
    pause
    
    %Validacion
    %corr_train=corr(a.X==1,data_train.Y)
    corr_test=corr(CAI_est.X,data_test.Y)
    
    %error_train=ecm_norm(a.X==1,data_train.Y)
    error_test=ecm_norm(CAI_est.X,data_test.Y)
    pause
    
end
