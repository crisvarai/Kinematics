
% run startup_rvc   Correr 1 vez para cargar la librería

clc;        % Limpiar Command Window
clear all   % Limpiar Workspace
close all   % Cerrar todas las ventanas de simulación
disp('*** BRAZO DERECHO - SIMULACIÓN DE TRAYECTORIA  ***');

%% ---------------------- Información del Script --------------------------

% PROGRAMA: Que efectúa la simulación de trayectorias de un brazo (derecho) 
%           robótico antropomórfico de 6DOF por cinemática directa
% OBJETIVO: Simular las trayectorias definidas en el brazo virtual       
% FECHA:    24 de Junio 2021
% DISEÑO:   Ing. Cristian Vallejo

%% -------------- Parámetros DH del Brazo Derecho del Robot ---------------

d1 = 183.73;
a2 = 58.28;
d3 = 244.4;
a3 = 18.76;
a4 = 18.53;
d5 = 123.03;
d7 = 150;

alpha = 65;
alpha = alpha*pi/180;

offset = 90;
offset = offset*pi/180;

%% --------------------- Definición de Trayectoria ------------------------

% pos_ini = [0 0 0 0 0 0];
pos_ini = [];
count = 0;
while 1
    fprintf('Ingresa theta inicial %d: ', count+1);
    pos_ini(count+1) = input('');
    count = count+1;
    if count == 6; break; end
end
pos_ini = pos_ini*pi/180;

% pos_fin = [0 115 90 0 -90 0];
pos_fin = [];
count = 0;
while 1
    fprintf('Ingresa theta final %d: ', count+1);
    pos_fin(count+1) = input('');
    count = count+1;
    if count == 6; break; end
end
pos_fin = pos_fin*pi/180;

q0 = [0 0 pos_ini 0];
qf = [0 0 pos_fin 0];

%% -------- Implementación de los parámetros DH en el Serial-Link ---------

L(1) = Link('d', 0,  'a', 0,  'alpha', alpha,  'offset', 0);
L(2) = Link('d', 0,  'a', 0,  'alpha', 0,      'offset', offset);
L(3) = Link('d', d1, 'a', 0,  'alpha', pi/2,   'offset', 0);
L(4) = Link('d', 0,  'a', a2, 'alpha', -pi/2,  'offset', 0);
L(5) = Link('d', d3, 'a', a3, 'alpha', pi/2,   'offset', 0);
L(6) = Link('d', 0,  'a', a4, 'alpha', -pi/2,  'offset', 0);
L(7) = Link('d', d5, 'a', 0,  'alpha', pi/2,   'offset', 0);
L(8) = Link('d', 0,  'a', 0,  'alpha', -pi/2,  'offset', 0);
L(9) = Link('d', d7, 'a', 0,  'alpha', 0,      'offset', 0);

RightArm = SerialLink(L);

%% --------------------- Preparación de Trayectoria -----------------------

t = 0:0.15:3;
Q = jtraj(q0,qf,t);
Tr = fkine(RightArm,Q);

for i = 1:1:length(t)
    T = Tr(i);
    trs = transl(T);
    xx(i) = trs(1);
    yy(i) = trs(2);
    zz(i) = trs(3);
end 

%% ---------------------- Simulación de Trayectoria -----------------------

RightArm.name = 'Prometheus Right Arm';
plot(RightArm,Q);
hold on
plot3(xx,yy,zz,'Color',[1 0 0],'LineWidth',2)
