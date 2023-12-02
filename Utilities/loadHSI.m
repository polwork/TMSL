function [Z]    =  loadHSI( image )
sz = size(image);
bands = sz(3);
s_Z = zeros(bands,sz(1)*sz(2));
for band = 1:bands
    Z              =   image(1:sz(1), 1:sz(2),band);
    s_Z(band, :)   =   Z(:);
end
Z      = s_Z;
end