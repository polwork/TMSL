clear,clc,close all;
addpath(genpath('./Utilities/'));
addpath(genpath('./functions/'));
pathstr = fileparts('.\data');
dirname = fullfile(pathstr, 'data','*.mat');
imglist = dir(dirname);
sf = 16;     % scaling factor
kernel_type = 'Uniform_blur';       % Uniform_blur or Gaussian_blur
par = Parameters_setting(sf,[512,512],kernel_type);

index=zeros(length(imglist),5);
for yy=1:length(imglist)
img =load(fullfile(pathstr, 'data', imglist(yy).name));
RZ = img.X1; 
RZ = RZ/max(RZ(:));
RZ2d = loadHSI(RZ);
rzSize = size(RZ);
sz = [rzSize(1),rzSize(2)]  ;
X = par.H(RZ2d);         % X: low resolution HSI
P = create_P();          % P: Y = PZ
Y = P*RZ2d;              % Y: high spatial resolution RGB image
% super-resolution

out_iter=2;%larger out_iter may boost the performance, but cost more time
X_h={};Y_h={};                                                   
for i=1:out_iter 
     Y_h{i}=Y;  
     X_h{i}=X;
     [~,Z3d{i}] = TMSL(RZ2d,rzSize,sf,par,X,Y,P); 
     S_bar=hyperConvert2D(Z3d{i});
     X= par.H(S_bar);
     Y = P*S_bar; 
     X=X_h{i}-X;
     Y=Y_h{i}-Y;
 end
    ZZ=0;
 for ii=1:out_iter
      ZZ=ZZ+Z3d{ii};% ZZ: the super-resolution result
 end 
[psnr,rmse, ergas, sam, uiqi,ssim,DD]  = quality_assessment(double(im2uint8(RZ)), double(im2uint8(ZZ)), 0, 1.0/sf);
index(yy,:)=[psnr, sam,uiqi,ssim,DD];
% aa=erase(imglist(yy).name,'.mat');
% save(strcat('E:\Relevant Research\my paper\GRSL fusion\code\',aa,'.mat'), 'Z3d','index');
end