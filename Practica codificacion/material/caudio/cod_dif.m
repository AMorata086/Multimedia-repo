clear variables;
close all;

nb = 10;

[x, fs] = audioread('./muestras_audio/bassoon.wav', 'native');
N = length(x);

xdif = diff(x);
xdif_min = min(xdif);
xdif_max = max(xdif);
xdif_amp = max(abs(xdif_min), xdif_max);
delta = 2 * xdif_amp / (2^nb);

xrec = zeros(N, 1, 'int16');
xpred(1) = x(1);
for i = 2:N
    res = x(i) - xpred;
    res_q = res / delta;
    xrec(i) = xpred + res_q * delta;
    xpred = xrec(i);
end

player = audioplayer(xrec, fs);
player.play();
