
load_data_SVM(file)
data_in = load(file)

num_subj = 27
num_subj_train = num_subj * 1 / 3
num_subj_test = num_subj - num_subj_train

num_coeff = 7
num_samples = 100
num_samples_train = 100
num_samples_test = 100
num_ARI = 10

#length_in_trainXsubj=round(num_samples*2/3);
#length_in_testXsubj =num_samples-length_in_trainXsubj;

length_in_train = num_samples_train
length_in_test = num_samples_test

length_input_train = length_in_train * num_subj_train * num_ARI
length_input_test = length_in_test * num_subj_test * num_ARI

input_train = zeros(num_coeff, length_input_train)
input_test = zeros(num_coeff, length_input_test)

count_train = 1
count_test = 1
for i in mslice[1:num_subj_train]:
    for j in mslice[1:num_ARI]:
        input_train(mslice[:], mslice[count_train:count_train + length_in_train - 1]).lvalue = data_in.Res(i, j).h1(mslice[:], mslice[1:length_in_train])
        output_train(mslice[count_train:count_train + length_in_train - 1]).lvalue = ones(1, length_in_train) * (j - 1)
        count_train = count_train + length_in_train
    end
end
display(mstring('conjunto de entrenamiento OK'))
pause()
for i in mslice[1 + num_subj_train:num_subj_test + num_subj_train]:
    for j in mslice[1:num_ARI]:
        input_test(mslice[:], mslice[count_test:count_test + length_in_test - 1]).lvalue = data_in.Res(i, j).h1(mslice[:], mslice[1:length_in_test])
        output_test(mslice[count_test:count_test + length_in_test - 1]).lvalue = ones(1, length_in_test) * (j - 1)
        count_test = count_test + length_in_test
        #pause
    end
end
display(mstring('conjunto de prueba OK'))
pause()

#length(input_train);
#length(output_train);

X_train = input_train.cT
Y_train = output_train.cT

X_test = input_test.cT
Y_test = output_test.cT

kernel_in = mstring('rbf')
var_NU = 0.1
var_C = 2. ** 1
n_folds = 3
display(mstring('comenzando entrenamiento SVM'))
#pause
SVM_model_grade_CA_RBF(X_train, Y_train, num_coeff, X_test, Y_test, kernel_in, var_NU, var_C, n_folds)
display(mstring('etapa de aprendizaje supervisado OK'))
pause()

#roc_ari(X_test,Y_test);
#test_SVM(X_train,Y_train,X_test,Y_test,num_coeff)
#test_LR(X_train,Y_train,X_test,Y_test,num_coeff)

end