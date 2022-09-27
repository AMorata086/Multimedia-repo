clear variables;
close all;

nb = 9;

[x, fs] = audioread('./muestras_audio/bassoon.wav', 'native');

xmin = min(x);
xmax = max(x);
xamp = max(abs(xmin), xmax);

delta = 2 * xamp / (2^nb);

xq = x / delta;

xrec = xq * delta;

player = audioplayer(xrec, fs);
player.play();