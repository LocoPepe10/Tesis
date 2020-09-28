% --------------------------------------
% UNIVERSIDAD DE SANTIAGO DE CHILE
% MAGISTER EN INGENIERIA INFORMATICA
% CLAUDIO ARAYA C.
% OCTUBRE DE 2005
% --------------------------------------
%
% Función que Calcula el error cuadrático medio NORMALIZADO (Mitsis)
% entre los valores de Vel. de Flujo estimados y los reales
%
%
% ENTRADAS:
% datos_est      -- Datos Estimados
% datos_reales   -- Datos Reales
% 
%
% SALIDAS:
% error_cuad_n   -- Error Cuadrático Medio NORMALIZADO
% 
% =========================================================================

function error_cuad_n = ecm_norm(datos_est, datos_reales)

%Se saca la componente continua de las señales
reales_scc     = datos_reales-mean(datos_reales);
obtenidos_scc  = datos_est-mean(datos_est);

% Calculo utilizando las señales SIN componente continua    
dif_scc = obtenidos_scc - reales_scc;
cuad_scc = dif_scc.*dif_scc;
suma_scc = sum(cuad_scc);


cuad = datos_reales.*datos_reales; % A lo mitsis
%cuad = reales_scc.*reales_scc;
sum_cuad = sum(cuad);

error_cuad_n = suma_scc/sum_cuad;
