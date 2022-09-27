clear variables;
close all;

im = imread('./data/im1.gif');
im = double(im);

imdct = blockproc(im - 128, [8, 8], @(block)dct2(block.data));

figure(1);
subplot(1, 2, 1), imshow(im, []); title('Imagen');
subplot(1, 2, 2), imshow(abs(imdct), []); title('DCT por bloques de 8x8');