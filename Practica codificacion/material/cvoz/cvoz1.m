clear variables
close all
clc

afile = './muestras_voz/sentence.wav';

ainfo = audioinfo(afile);

fs = ainfo.SampleRate;
bits = ainfo.BitsPerSample;

disp("Frecuencia de muestreo: " + fs);
disp("Bits por muestra: " + bits);

[x] = audioread(afile);
x = x / max(abs(x));

Tventana = 25e-3;               % tamaño de la ventana (en segundos)
Nventana = ceil(fs*Tventana);   % tamaño de la ventana (en muestras)

stft(x,fs,Nventana)
