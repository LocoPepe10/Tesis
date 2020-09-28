function [data_train data_test]=load_data2(file)
    data_in=load(file);
    
    num_subj=27;
    num_subj_train=num_subj*2/3
    num_subj_test =num_subj-num_subj_train
    
    num_coeff=7;
    num_samples=100;
    num_ARI=10;
    
    length_in_trainXsubj=round(num_samples*2/3);
    length_in_testXsubj =num_samples-length_in_trainXsubj;
    
    length_in_train=num_samples
    length_in_test =num_samples
    length_input_train=length_in_trainXsubj*num_subj*num_ARI;
    length_input_test =length_in_testXsubj *num_subj*num_ARI;

    input_train =zeros(num_coeff,length_input_train);
    input_test  =zeros(num_coeff,length_input_test);
    
    output_train=zeros(1,length_input_train);
    output_test =zeros(1,length_input_test);
    
    count_train=1;
    count_test =1;
    for i=1:num_subj_train
        for j=1:num_ARI
            input_train(:,count_train:count_train+length_in_train-1)...
                =data_in.Res(i,j).h1(:,1:length_in_train);
            output_train(count_train:count_train+length_in_train-1)...
                = ones(1,length_in_train)*(j-1);
            count_train=count_train+length_in_train;
        end
    end
    
    for i=1+num_subj_train:num_subj_test+num_subj_train
        for j=1:num_ARI
            input_test(: ,count_test :count_test +length_in_test -1)...
                =data_in.Res(i,j).h1(:,1:length_in_test);
            output_test(count_test :count_test +length_in_test -1)...
                =ones(1,length_in_test)*(j-1);
            count_test =count_test +length_in_test;
            %pause
        end
    end
    
    length(input_train);
    length(output_train);
    
    X_train=input_train';
    Y_train=output_train';

    X_test=input_test';
    Y_test=output_test';

    test_SVM(X_train,Y_train,X_test,Y_test,num_coeff)
    %test_LR(X_train,Y_train,X_test,Y_test,num_coeff)
    
end