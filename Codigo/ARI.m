clear;
clc;
load('RNA/gris2.mat'); % cargo entrenamiento de rna

%----------------------------- genero matriz de datos
num_subj = 16; % 16 sujetos en total
num_samples =  700; % 750 mmuestras por sujeto (datos por archivo)
[PSA VFSC] = matrizFinal(num_subj,num_samples);
display('Matriz generada.');

%simulacion red neurona artificial2
% V_ESTIMADA = sim(net,PSA);
% display('Simulación lista.');

% correlacion = corr(V_ESTIMADA',VFSC')
% a = VFSC - V_ESTIMADA;
% a = a.*a;
% error = sqrt(mean(a))
%----------------------------- cálculo de ari
% V_REAL = VFSC;
% clear VFSC;
% VFSC = V_ESTIMADA;

cont = 1;
for i=1:num_subj
    % normocapnia
%     display(strcat(strcat('Sujeto ',num2str(i)),' Normocapnia'));
    FN = VFSC(1,cont:cont+(num_samples-1));
    PN = PSA(7,cont:cont+(num_samples-1));
    cont = cont + num_samples;
    [tamN errN corrN ARI_EN ARI_CN EN] = BuscarCurvasVFSC(FN,PN);
    % hipercapnia
%     display(strcat(strcat('Sujeto ',num2str(i)),' Hipercapnia'));
    FH = VFSC(1,cont:cont+(num_samples-1));
    PH = PSA(7,cont:cont+(num_samples-1));
    cont = cont + num_samples;
    [tamH errH corrH ARI_EH ARI_CH EH] = BuscarCurvasVFSC(FH,PH);
    
    ARI_ERROR(i,1) = ARI_EN(2);
    ARI_ERROR(i,2) = ARI_EH(2);
    
    ARI_CORR(i,1) = ARI_CN(2);
    ARI_CORR(i,2) = ARI_CH(2);
    
     % ---------------------------- gráfico
    subplot(2,1,1);
    plot(1:tamN,FN,'k');
    hold on;
    plot(1:tamN,errN,'r--');    
    plot(1:tamN,corrN,'b-.');
    hold off;
    title(['Sujeto' ' ' num2str(i) ' Normocapnia']);
    xlabel('TIEMPO');
    ylabel('VFSC');
    legend('Real','ARI Error','ARI Correlación');
    
    subplot(2,1,2);
    plot(1:tamH,FH,'k');
    hold on;
    plot(1:tamH,errH,'r--');    
    plot(1:tamH,corrH,'b-.');
    hold off;
    title(['Sujeto' ' ' num2str(i) ' Hipercapnia']);
    xlabel('TIEMPO');
    ylabel('VFSC');
    legend('Real','ARI Error','ARI Correlación');
  
    %Almaceno la figura
    figure(gcf)
    NombreFigura = ['Sujeto','',int2str(j)];
    NombreFiguraFIG = ['Sujeto_',num2str(i),'.fig'];
    set (figure(1),'name',NombreFigura);        
    saveas (figure(1),NombreFiguraFIG);
    close all;
    
    graficoARI(i,FN,FH,EN,EH);
    
    clear FN;
    clear PN;
    clear FH;
    clear PH;
end
display('Cálculo de ARI listo.');

%gràfico real vs estimada

% plot(V_REAL,'b');
% hold on;
% plot(V_ESTIMADA,'g');
% hold off;
% title(['VFSC REAL VS VFSC ESTIMADA']);
% xlabel('TIEMPO');
% ylabel('VFSC');
% legend('Real','Estimada');
% %Almaceno la figura
% figure(gcf)
% NombreFigura = ['VFSC REAL VS VFSC ESTIMADA'];
% NombreFiguraFIG = ['real_estimada_750.fig'];
% set (figure(1),'name',NombreFigura);        
% saveas (figure(1),NombreFiguraFIG);
% close all;
%----------------- curva roc ctm!
make_roc(ARI_CORR);
%Almaceno la figura
figure(gcf)
NombreFigura = ['CURVA ROC'];
NombreFiguraFIG = ['bestroc_.fig'];
set (figure(1),'name',NombreFigura);        
saveas (figure(1),NombreFiguraFIG);
display('Curva roc generada');

%----------------- almaceno informaciòn
% save('valores','PSA','V_REAL','V_ESTIMADA');
% save('operatoria');
% net.LW