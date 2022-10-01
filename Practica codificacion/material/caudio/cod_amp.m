clear variables;
close all;
afile = './muestras_audio/bassoon.wav';
ainfo = audioinfo(afile);
bs = ainfo.BitsPerSample;
disp(bs);
nb = 7;

[x, fs] = audioread('./muestras_audio/bassoon.wav', 'native');

xmin = min(x);
xmax = max(x);
xamp = max(abs(xmin), xmax);

delta = 2 * xamp / (2^nb);

xq = x / delta;

xrec = xq * delta;

player = audioplayer(xrec, fs);
msevar = mse(xrec, x);
disp(msevar);
player.play();