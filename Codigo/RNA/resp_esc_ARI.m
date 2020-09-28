%Este programa genera 37 respuestas al escalon 1-0, utilizando los valores
%de la Tabla Tiecks-Nuñez, que tiene 37 curvas.

%clear;
%close all;warning off;


    %Se inicializan las variables:
    %Ctes=load('D:\Universidad\Memoria\Matlab\Escalon\TablaTiecks37.txt'); % se carga la tabla de Tiecks de 37 filas (Tiecks-Nuñez)
    Ctes=load('D:\Universidad\Memoria\Matlab\Escalon\TablaComb.txt');
    n_datos = size(Ctes, 1);
    CCP=0; %presion de cierre critica, en manguitos de supone cero, de acuerdo a lo indicado por don Ronney
    PresAlta=1; %valor de la presion antes de la caida a cero.
    PresBaja=-1; %valor de la presion despues de la caida.
    LargoEsc=150; %largo del escalon
    N=LargoEsc; %largo del escalon, en la ecuacion se usa como N
    LargoPrec=50; %largo del pedazo de escalon que precede a la caida
    PM=PresAlta; %presion de control, o de linea base del escalon                                                         
    f=5; %frecuencia de muestreo del escalon
    FM=1; %Flujo medio, estimacion del flujo de linea base

    %Se crea el escalon de largo 150, que desciende de 1 a 0
    EscPres_(1:LargoPrec) = PresAlta;
    EscPres_(LargoPrec+1:LargoEsc)=PresBaja;

    %Se filtra el escalon con el mismo filtro utilizado por Cristopher
    [b,a] = butter(2,0.1); 
    EscPres_ = filter(b,a,EscPres_); 

%---------------------------------------------------

v_min = min(EscPres_);
v_max = max(EscPres_);

ndata_i = size(EscPres_,2);

for i=1:1:ndata_i; 
    EscPres(1,i)  = (EscPres_(i) - v_min) /(v_max - v_min );
end;

%---------------------------------------------------
    
    %Se calcula dP, de acuerdo a la ecuacion de Tiecks:                                                                                                      
    dP=(EscPres-PM)./(PM-CCP); %Ecuacion dada por Tiecks.

    %Se generan las 37 respuestas:
    for i=1:n_datos
        T=Ctes(i,1);
        D=Ctes(i,2);
        K=Ctes(i,3);
        X1(1)=0;                                                                
        X2(1)=0;                                                                
        V(1)=FM*(1+dP(1)-K*X2(1));        
        %Se genera la curva numero i, de acuerdo a las ecuaciones de Tiecks:
        for t=2:N                                                               
            X1(t)=X1(t-1)+(dP(t-1)-X2(t-1))/(f*T);                                  
            X2(t)=X2(t-1)+((X1(t-1)-2*D*X2(t-1))/(f*T));  
            V(t)=FM*(1+dP(t)-K*X2(t));       
        end    
        cc=1;
        for c=1:50
            VModif(c)=V(cc);    
            cc=cc+3;
        end
        %se grafica la señal numero i
        plot(0:0.6:20,VModif(12:45),'b');hold on;
        %Se agrega la respuesta numero i a la matriz resumen, que tendra 37 columnas y 150 filas
        MatrizResultante(:,i)=VModif';
    end
    cc=1;
    for c=1:50
        EscPresModif(c)=EscPres(cc);    
        cc=cc+3;
    end
    Escalon = zeros(1,500);
    Escalon(1:200) = ones(1,200);
    [b,a] = butter(2,0.3);
    Escalon = filter(b,a,Escalon);
    %Finalmente se grafica el escalon aplicado:
    plot(0:0.6:19.8,EscPresModif(12:45),'r-');hold on;
    plot(0:0.6:19.8,Escalon(195:228),'g-');hold on;
    
    %Se da formato al grafico:
    xlabel('Tiempo (seg)');
    ylabel('PAM/VFSC');

    %Se graba el grafico de las 37 curvas:
    %saveas(figure(1),'D:\Universidad\Memoria\Matlab\Escalon\37RespuestasEscalonModif.jpg');
    saveas(figure(1),'D:\Universidad\Memoria\Matlab\Escalon\RespuestasEscalonComb.jpg');
    %close all;
    %Se graba el archivo con las 37 señales:
    %save 'D:\Universidad\Memoria\Matlab\Escalon\37RespuestasEscalonModif.txt' MatrizResultante -ascii;
    save 'D:\Universidad\Memoria\Matlab\Escalon\RespuestasEscalonComb.txt' MatrizResultante -ascii;



%......................................................................
%MatrizRespEscalonTiecks=load('C:\DDH\MagTesis\04_DesaMatlab\37RespuestasEscalonModif.txt');
%......................................................................
