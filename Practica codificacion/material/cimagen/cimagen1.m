clear variables;
close all;

I = imread('./data/im1.gif');
I = im2double(I);
load('./data/filters.mat');

Idct = dct2(I);
figure(1);
subplot(1, 2, 1), imshow(I); title('Imagen original');
subplot(1, 2, 2), imshow(20*log10(abs(Idct)), []); title('DCT');

Idct_f1 = Idct .* filter1;
I_f1 = idct2(Idct_f1);
figure(2);
subplot(1, 2, 1), imshow(I_f1); title('Imagen filtrada 1');
subplot(1, 2, 2), imshow(20*log10(abs(Idct_f1)), []); title('DCT');

Idct_f2 = Idct .* filter2;
I_f2 = idct2(Idct_f2);
figure(3);
subplot(1, 2, 1), imshow(I_f2); title('Imagen filtrada 2');
subplot(1, 2, 2), imshow(20*log10(abs(Idct_f2)), []); title('DCT');

Idct_f3 = Idct .* filter3;
I_f3 = idct2(Idct_f3);
figure(4);
subplot(1, 2, 1), imshow(I_f3); title('Imagen filtrada 3');
subplot(1, 2, 2), imshow(20*log10(abs(Idct_f3)), []); title('DCT');

Idct_f4 = Idct .* filter4;
I_f4 = idct2(Idct_f4);
figure(5);
subplot(1, 2, 1), imshow(I_f4); title('Imagen filtrada 4');
subplot(1, 2, 2), imshow(20*log10(abs(Idct_f4)), []); title('DCT');