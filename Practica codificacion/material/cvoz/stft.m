
function stft(s,fs,M,NFFT,O)

% Calcula la transformadad localizada de Fourier de la se�al s(n) en donde 
% NFFT es el numero de puntos de la transformada rapida de Fourier en 
% ventanas sucesivas w.
% NFFT es, por defecto, la longitud de la ventana w.
% Opcionalmente se puede incluir O muestras de solapamiento de estas 
% ventanas. El solapamiento por defecto es 0.5 (longitud de la ventana).

figure
L = length(s);
Lt = L-M;
disp('Pulse una tecla para ver la siguiente trama.');

if nargin == 3
    NFFT = 2*M;
end

if nargin > 4
    O = round(M*O);
else
    O = round(M/2); 
end

% Ventana
w = hamming(M);

for n = 1:(M-O):Lt
 
    subplot(3,1,1)
    hold off
    plot([1:L] / fs, s)
    title('Se�al de voz');
    hold on
    aux = zeros(size(s));
    aux(n:M+n-1) = w;
    plot([1:L] / fs, aux*max(s),'g')
    xlabel('Tiempo (s)');
    
    cur_w = s(n:n+M-1) .* w;
    
    subplot(3,1,2)
    hold off
    plot([1:M] / fs, cur_w)
    title('Se�al enventanada en el dominio temporal');
    xlabel('Tiempo (s)');

    subplot(3,1,3)
    
    % Visualiza la transformada de la ventana
    spec_w = fft(cur_w, NFFT);
    frecuencias = linspace(0, fs/2, NFFT/2+1);
    plot(frecuencias, 20*log10(abs(spec_w(1:NFFT/2+1))));
    title('M�dulo de la TF de la se�al enventanada');
    xlabel('Frecuencia (Hz)');
    
    pause
end
