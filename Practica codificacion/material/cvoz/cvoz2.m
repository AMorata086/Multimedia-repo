clear variables
close all
clc

afile = './muestras_voz/m_oo.wav';

ainfo = audioinfo(afile);

fs = ainfo.SampleRate;

[x] = audioread(afile);
x = x / max(abs(x));

Tventana = 50e-3;               % tamaño de la ventana (en segundos)
Nventana = ceil(fs*Tventana);   % tamaño de la ventana (en muestras)

stft_env(x,fs,Nventana)
