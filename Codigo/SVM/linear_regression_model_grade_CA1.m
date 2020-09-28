function [error_test]=linear_regression_model_grade_CA1...
    (coeff_in,CAI_out,number_coeff,coeff_new,CAI_out_new)

    xb0=ones(length(coeff_in),1);
	xb1=ones(length(coeff_new),1);
    %length(CAI_out)
    
    x=[xb0,coeff_in];

    y=CAI_out;
    x_test=[xb1,coeff_new];
    y_test=CAI_out_new

    [b bint e eint stats]=regress(y,x);
	b
    yp_LR=x*b;
    yp_test=x_test*b;
	display('Correlacion-----------------')
    corr(yp_test,y_test)
    pause
    display('Error-----------------')
    ecm_norm(yp_test,y_test)
    pause


	n=length(find(y_test==0))
	ARI=ones(n,10)

    for i=0:9
    		I=find(y_test==i);
		ARI(:,i+1)=yp_test(I)
	end
	boxplot(ARI)
	pause
%    plot(data_train.X(I,1),data_train.X(I,2),'ro');
%     
%     I=find(data_train.Y==-1);
%     plot(data_train.X(I,1),data_train.X(I,2),'bo');


	y_test;

	boxplot([yp_test,y_test])
	pause

    plot(y_test,yp_test,'r+');
	pause
	xlswrite('LR_test.xls',[x_test, y_test])
	xlswrite('LR_train.xls',[x, y])
	xlswrite('LR.xls',[[x;x_test],[y;y_test]])
%     
%     corr_train=corr(a.X==1,data_train.Y)
%     
%     error_train=ecm_norm(a.X==1,data_train.Y)

    
end
