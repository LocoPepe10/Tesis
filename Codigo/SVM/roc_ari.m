function roc_ari(input_coeff,output_ARI)
    disp('-----------------------')
    net_=load('svm_net.mat');
    r=net_.r;
    data_test=data(input_coeff,output_ARI);
    output_est=test(r,data_test);
    
%     [tpr,fpr,thresolds]=roc(output_ARI,output_est.X);
%     a=tpr(1,1);
%     %disp('-----------------------')
    mitad=length(output_ARI)/2;
    target=ones(mitad*2,1);
    target(1:mitad)=0;
%     figure
%     plot(target)
%     pause
    figure
    est=round(output_est.X/10);
    i=find(est>1)
    est(i)=1
    
%     plot(est)
%     pause
                    %plotroc(output_ARI,output_est.X);
%     plotroc(target',est');

%     n=0;
%     CAI_out_new_nc=CAI_out_new(1:mitad);
%     CAI_out_new_hc=CAI_out_new(mitad+1:mitad*2);
%     CAI_est_nc    =output_est.X(1:mitad,1);
%     CAI_est_hc    =output_est.X(mitad+1:mitad*2,1);
%     
    
    
%     dif_SVM = round(CAI_est_nc) - round(CAI_est_hc)
%     figure
%     plot(dif_SVM)
%     pause
%     dif_norm= CAI_out_new_nc - CAI_out_new_hc
%     figure
%     plot(dif_norm)
    pause
end