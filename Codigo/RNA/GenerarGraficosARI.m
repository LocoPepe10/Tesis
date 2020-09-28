%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Grafica las curvas de Flujo Real, Flujo E-ARI y Flujo ARI    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Autor: Claudio Henríquez                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GenerarGraficosARI;

%Inicializa el arreglo de iniciales de los sujetos
Sujetos(1,:)=['An'];
Sujetos(2,:)=['Dy'];
Sujetos(3,:)=['Ec'];
Sujetos(4,:)=['Gb'];
Sujetos(5,:)=['H2'];
Sujetos(6,:)=['Am'];
Sujetos(7,:)=['Jg'];
Sujetos(8,:)=['Jn'];
Sujetos(9,:)=['Ms'];
Sujetos(10,:)=['Pb'];
Sujetos(11,:)=['Ph'];
Sujetos(12,:)=['Rp'];
Sujetos(13,:)=['Sb'];
Sujetos(14,:)=['Sh'];
Sujetos(15,:)=['Tj'];
Sujetos(16,:)=['Vh'];

%por cada sujeto
for i=1:16
    %%% busca la carpeta de las señales del sujeto en estudio %%%
    FraseCarpeta=['cd ../Datos/Nayibe/',Sujetos(i,:)];
    FraseCarpeta2=['cd Nayibe/',Sujetos(i,:)];
    eval(FraseCarpeta);
    CantMans=load('CantMans.txt');
    for j=1:CantMans
        MatArchivo=[int2str(j),Sujetos(i,:),'E-ARI por Error.mat'];
        EARI = load(MatArchivo);
        MatArchivo=[int2str(j),Sujetos(i,:),'ARI por Error.mat'];
        ARI = load(MatArchivo);
        
        plot (EARI.FlujoReal, 'DisplayName', 'Flujo Real', 'YDataSource', 'Flujo Real');
        hold all;
        plot (ARI.V_Escogido, 'DisplayName', 'ARI', 'YDataSource', 'V_Escogido');
        plot (EARI.V_Escogido, 'DisplayName', 'E-ARI', 'YDataSource', 'V_EscogidoE');
        legend ('Flujo Real','ARI','E-ARI');

        hold off;
        figure(gcf)        
        
        NombreFigura = [Sujetos(i,:),int2str(j)];
        NombreFiguraJPG = [Sujetos(i,:),int2str(j),'.jpg'];
        NombreFiguraFIG = [Sujetos(i,:),int2str(j),'.fig'];
        cd ../../;
        set (figure(1),'name',NombreFigura);        
        saveas (figure(1),NombreFiguraJPG);
        eval(FraseCarpeta2);        
%         saveas (figure(1),NombreFiguraFIG);
        close all;
    end    
    cd ../../../Programas;
end
