function [data_train data_test]=load_data_SVM_test(file)
    data_in=load(file);
    
    num_subj=27;
    num_coeff=7;
    num_ARI=10;
    
    num_samples=4;
    nc_range=[1:2];
    hc_range=[3:4];
    
    length_input=num_samples*num_subj;
    input =zeros(num_coeff,length_input);
    input_nc=zeros(num_coeff,length_input/2);
    input_hc=zeros(num_coeff,length_input/2);
    
    output=zeros(1,length_input);
    output_nc=zeros(1,length_input/2);
    output_hc=zeros(1,length_input/2);
    
    count=1;
    count_nc=1;
    count_hc=1;
    
    for j=1:num_samples         %number of samples
        for i=1:num_subj        %number of subjects

            input(:,count)...
                =cell2mat(data_in.hs(i,j));
            output(1,count)=cell2mat(data_in.ARI(i,j));
            count=count+1;
            
            if(j==1)||(j==2)
                input_nc(:,count_nc)...
                    =cell2mat(data_in.hs(i,j));
                output_nc(1,count_nc)=cell2mat(data_in.ARI(i,j));
                count_nc=count_nc+1;
            else
                input_hc(:,count_hc)...
                    =cell2mat(data_in.hs(i,j));
                output_hc(1,count_hc)=cell2mat(data_in.ARI(i,j));
                count_hc=count_hc+1;
            end
        end
    end
    
  X_train=input';
  %X_test =input';
  X_test = [input_nc';input_hc'];
  
  Y_train=output';
  %Y_test =output';
  Y_test = [output_nc';output_hc'];
  
      %test_SVM1(X_train,Y_train,X_test,Y_test,num_coeff)
      SVM_model_grade_CA_RBF_test...
    (X_train,Y_train,7,X_test,Y_test,'rbf',1,1,1)
    %roc_ari(X_test,Y_test)
    
end