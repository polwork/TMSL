function [X] = Tensor_LRR_closed(Y,rho)

[n1,n2,n3] = size(Y);
Y = fft(Y,[],3);
X = zeros(n2,n2,n3);

for i = 1 : n3
%     X(:,:,i) = lrsc_noiseless(Y(:,:,i));
     X(:,:,i) = lrsc_noiseless(Y(:,:,i),1/rho);
end
X = ifft(X,[],3);
X = real(X);


