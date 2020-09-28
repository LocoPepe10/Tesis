function graficoARI(suj,FN,FH,EN,EH)
    %normocapnia
    plot(FN,'Color',[0.5,0.5,0.5]);
    hold on;
    plot(EN');
    hold off;
    title(['Muestras Sujeto' ' ' num2str(suj) ' Normocapnia']);
    xlabel('TIEMPO');
    ylabel('VFSC');
    legend('Real','ARI 0','ARI 1','ARI 2','ARI 3','ARI 4','ARI 5','ARI 6','ARI 7','ARI 8','ARI 9');
    %Almaceno la figura
    figure(gcf)
    NombreFigura = ['Sujeto',int2str(suj),' Normocapnia'];
    NombreFiguraFIG = ['Sujeto_',num2str(suj),'_normo.fig'];
    set (figure(1),'name',NombreFigura);        
    saveas (figure(1),NombreFiguraFIG);
    close all;
    
    % hipercapnia
    plot(FH,'Color',[0.5,0.5,0.5]);
    hold on;
    plot(EH');
    hold off;
    title(['Muestras Sujeto' ' ' num2str(suj) ' Hipercapnia']);
    xlabel('TIEMPO');
    ylabel('VFSC');
    legend('Real','ARI 0','ARI 1','ARI 2','ARI 3','ARI 4','ARI 5','ARI 6','ARI 7','ARI 8','ARI 9');
    %Almaceno la figura
    figure(gcf)
    NombreFigura = ['Sujeto',int2str(suj),' Hipercapnia'];
    NombreFiguraFIG = ['Sujeto_',num2str(suj),'_hyper.fig'];
    set (figure(1),'name',NombreFigura);        
    saveas (figure(1),NombreFiguraFIG);
    close all;
end