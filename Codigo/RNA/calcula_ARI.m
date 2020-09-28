% --------------------------------------
% UNIVERSIDAD DE SANTIAGO DE CHILE
% MAGISTER EN INGENIERIA INFORMATICA
% CLAUDIO ARAYA C.
% MARZO 2006
% --------------------------------------
%
% Función que calcula el ARI de un sujeto (funcion de Darwin)
%
% ENTRADAS:
% sujeto         -- Numero de sujeto
% datos_esc      -- Matriz con el escalon de entrada
% datos_resp     -- Matriz con la respuesta al escalon de entrada
% corte          -- utlizado para alinear la respuesta del escalon (es el mayor valor de retardo)
% 
%
% SALIDAS:
% ARI            -- ARI del sujeto
% min_ECM        -- ECM medio mínimo encontrado
%
% >> [ARI_AN, ECM_AN] = calcula_ARI(1,temp,Res_pos_AN, 1)
% 
% =========================================================================

function [ARISujeto,MinMse] = calcula_ARI(sujeto, datos_esc, datos_resp, corte)

% Se definen los Sujetos
if (sujeto == 1) 
    Suj = 'AN';
end
if (sujeto == 2) 
    Suj = 'DY';
end
if (sujeto == 3)
    Suj = 'EC';
end
if (sujeto == 4)
    Suj = 'GB';
end
if (sujeto == 5) 
    Suj = 'H2';
end
if (sujeto == 6) 
    Suj = 'AM';
end
if (sujeto == 7) 
    Suj = 'JG';
end
if (sujeto == 8) 
    Suj = 'JN';
end
if (sujeto == 9) 
    Suj = 'MS';
end
if (sujeto == 10) 
    Suj = 'PB';
end
if (sujeto == 11) 
    Suj = 'PH';
end
if (sujeto == 12) 
    Suj = 'RP';
end
if (sujeto == 13) 
    Suj = 'SB';
end
if (sujeto == 14) 
    Suj = 'SH';
end
if (sujeto == 15) 
    Suj = 'TJ';
end
if (sujeto == 16) 
    Suj = 'VH';
end

MTiecks = load('D:\Universidad\Memoria\Matlab\Escalon\37RespuestasEscalonModif.txt');
Escalon = datos_esc;
InicSuj = Suj;
Valor_ajust = 1;
grafica = 1;
RespEscalonObt = datos_resp(195-corte:228-corte);




MinMse=-1;
NCurva=0;
PAMBajo=1;
PAMAlto=-1;
NMuestras=34;

%Se graficaran solo 34 muestras
%Se mueve la repuesta obtenida al escalon para q coincida con las 37 curvas Tiecks
ValorAntesBajar=RespEscalonObt(4);
if ValorAntesBajar~=Valor_ajust
    Delta=Valor_ajust-ValorAntesBajar;
end
%Se traslada toda la señal al valor uno
for i=1:NMuestras
    RespEscalonObt(i)=RespEscalonObt(i)+Delta;
end

%Se comparan las 37 curvas con el Escalon Obtenido
for i=1:37
    RespEscalon=MTiecks(12:45,i); 
    %Solo quedaran 34 muestras a comparar
    
    v_mse=error_cuad_medio(RespEscalon,RespEscalonObt);
    
    if i == 1
        MinMse=v_mse;
        NCurva=i;
        RespEscalonMax=RespEscalon;
    else
        if v_mse<MinMse
            MinMse=v_mse;
            NCurva=i;
            RespEscalonMax=RespEscalon;
        end
    end
    
    clear RespEscalon;
end
ARI(1)=0;
for i=2:37
    ARI(i)=0.25+ARI(i-1);
end
ARISujeto=ARI(NCurva);

%---------------------------------------------------------------------------------------
if grafica ~= 0
    figure;
    Ts=0.6;
    LimiteSup=NMuestras*Ts;
    LimiteSup=20;%en segundos
    n=[0:0.6:LimiteSup];
    
    plot(n,RespEscalonMax,'-m.',n,RespEscalonObt,'-r*',n,Escalon(195:228),'b');
    grid;
    xlabel('Tiempo(seg)');
    ylabel('VFSC Estimado(cm/seg)');
    Titulo=['Respuesta Escalon PAM - Sujeto ',num2str(sujeto) ,' (',InicSuj,') - ARI = ', num2str(ARISujeto)];
    title(Titulo);
    legend('Escalon Tiecks','Respuesta','Escalon');
    
end


