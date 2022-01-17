
% run startup_rvc   Correr 1 vez para cargar la librería

clc;        % Limpiar Command Window
clear all   % Limpiar Workspace
close all   % Cerrar todas las ventanas de simulación
disp('*** SIMULACIÓN DE BRAZO DERECHO  ***');

%% ---------------------- Información del Script --------------------------

% PROGRAMA: Que efectúa la simulación de un brazo (derecho) robótico 
%           antropomórfico de 6DOF 
% OBJETIVO: Simular la posición del brazo, con la opción de manipularlo
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

% theta = [0 115 90 0 -90 0];
theta = []
count = 0;
while 1
    fprintf('Ingresa theta %d: ', count+1);
    theta(count+1) = input('');
    count = count+1;
    if count == 6; break; end
end
theta = theta*pi/180;

%% -------- Implementación de los parámetros DH en el Serial-Link ---------

L(1) = Link('d', 0,  'a', 0,  'alpha', alpha,  'offset', 0);
L(2) = Link('d', 0,  'a', 0,  'alpha', 0,      'offset', offset);
L(3) = Link('d', d1, 'a', 0,  'alpha', pi/2,   'offset', theta(1));
L(4) = Link('d', 0,  'a', a2, 'alpha', -pi/2,  'offset', theta(2));
L(5) = Link('d', d3, 'a', a3, 'alpha', pi/2,   'offset', theta(3));
L(6) = Link('d', 0,  'a', a4, 'alpha', -pi/2,  'offset', theta(4));
L(7) = Link('d', d5, 'a', 0,  'alpha', pi/2,   'offset', theta(5));
L(8) = Link('d', 0,  'a', 0,  'alpha', -pi/2,  'offset', theta(6));
L(9) = Link('d', d7, 'a', 0,  'alpha', 0,      'offset', 0);

RightArm = SerialLink(L);

%% --------------------- Simulación de Brazo Derecho ----------------------

RightArm.name = 'Prometheus Right Arm';
RightArm.plot([ 0 0 0 0 0 0 0 0 0 ]);
RightArm.teach();
