%Calcula y visualiza los vectores de movimiento de una secuencia
% Sintaxis: me_block_based(video_name,finit,fend,algorithm)
%   Con entradas:
%     video_name : nombre del v�deo
%     finit: número del frame de inicio
%     fend: número del frame final
%     step: paso temporal entre planos para la estimaci�n  
%     save_output: a 1 almacena las salidas en ficheros en el dir outputs
%   Ejemplo:
%       me_block_based('coastguard',1,300,1,0)

function me_block_based(video_pattern,finit,fend,step,save_output)

%Parámetros

%%%%%%%%%%%%%%Block-based%%%%%%%%%%%%%%
%  patchCC    - Bloque alrededor de cada p�xel para calcular la
%                la distancia o similitud entre bloques
%  searchCC   - Rango de b�squeda
%  sigmaCC    - Desviaci�n t�pica de un prefiltrado Gaussiano de las
%                im�genes
%  lambda      - Regularizaci�n de la funci�n de Coste para forzar vectores peque�os: 
%                C = medida + lambda * ||u||, donde medida es SSD, SAD o
%                1-NCC.
%  medida      - Medida: Media de error utilizada => 1: SSD, 2: SAD, 3: NCC
%                (1-NCC para que sea una distancia)
patchCC=15;
searchCC=3;
sigmaCC=1.0;
lambda=1;
medida=1;

%%%%%%%%%%%%%% CÓDIGO DEL PROGRAMA %%%%%%%%%%%%%%%%%%%%
close all;
scale=1; 
addpath('./toolbox/images');
addpath('./toolbox/matlab');
addpath('./toolbox/filters');
addpath('./toolbox/external');
addpath('./toolbox/ransac');
addpath('./toolbox/evaluation');

videoDir=sprintf('./outputs/%s/',video_pattern);
mkdir(videoDir);
cont=0;

for i=finit:step:fend-1
    cont=cont+1;
    fprintf('.');
    if(rem(i,25)==0)
        fprintf('\n');
    end
    path1=sprintf('./videos/%s/%s%03d.jpg',video_pattern,video_pattern,i);
    path2=sprintf('./videos/%s/%s%03d.jpg',video_pattern,video_pattern,i+step);
    im1=imread(path1);
    [H W c]=size(im1);
    im2=imread(path2);
    im1=imresize(im1,scale);
    im2=imresize(im2,scale);
    gim1=double(rgb2gray(im1));
    gim2=double(rgb2gray(im2));
    
    [Vx,Vy] = optFlowBB( gim1, gim2, patchCC, searchCC, sigmaCC, lambda, 0, medida );
    Vx=sign(Vx).*min(abs(Vx),5);
    Vy=sign(Vy).*min(abs(Vy),5);
    Vx(abs(Vx)<0.1)=0;
    Vy(abs(Vy)<0.1)=0;

    %%%%%%%%%%%%%%%%%%%%% VISUALIZACIÓN %%%%%%%%%%%%%%%%%%%%%
    bs=16;
    bx=W/bs;
    by=H/bs;
    sVx=imresize(Vx,[by bx]);
    sVy=imresize(Vy,[by bx]);
    
    f = figure(1);
    imshow(im2,'Border', 'tight');
    hold('on');
    quiver(bs/2:bs:W,bs/2:bs:H,sVx, sVy,1,'b-');
    hold off;
    if(save_output)
        output=sprintf('outputs/%s/%s%03d.jpg',video_pattern,video_pattern,cont);
        [H,W,D] = size(im2);
        im=zbuffer_cdata(f);
        imwrite(im,output);
    end
end

function cdata = zbuffer_cdata(hfig)
% Get CDATA from hardcopy using zbuffer

% Need to have PaperPositionMode be auto
orig_mode = get(hfig, 'PaperPositionMode');
set(hfig, 'PaperPositionMode', 'auto');

cdata = print(hfig, '-RGBImage');

% Restore figure to original state
set(hfig, 'PaperPositionMode', orig_mode); % end