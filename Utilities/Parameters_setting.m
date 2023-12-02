function par = Parameters_setting(sf,sz,kernel_type)
if nargin < 3
    kernel_type = 'Uniform_blur';       % Uniform_blur as default
end

if strcmp(kernel_type, 'Uniform_blur')
    psf        =    ones(sf)/(sf^2);
elseif strcmp(kernel_type, 'Gaussian_blur')
    psf        =    fspecial('gaussian',8,3);
end

par.fft_B      =    psf2otf(psf,sz);
par.fft_BT     =    conj(par.fft_B);
par.H          =    @(z)H_z(z, par.fft_B, sf, sz );
par.HT         =    @(y)HT_y(y, par.fft_BT, sf, sz);

%% Parameters of FBP and block matching
par.patsize = 4;   
par.Pstep = 2;
par.patnum  = 60;               
par.step=floor((par.patsize-1));   
par.nCluster = 100;

par.eta = 0.1;%%this can be tuned(in our real experiment,set as 40)
par.lambda = 100;%%this can be tuned(in our real experiment,set as 1, it depends on the noise level)
par.iter = 200;
par.mu = 0.0001;
par.rho = 1.03;
       