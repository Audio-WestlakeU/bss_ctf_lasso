function x = my_ISTFT(X,shift,win)
% Inverse STFT
% author: Xiaofei Li

nfft = (size(X,1)-1)*2;

% synthesis window
osFac = nfft/shift;
coe = zeros(shift,1);
for i = 1:osFac
    coe = coe + win((i-1)*shift+1:i*shift).^2;
end
coe = repmat(coe,[osFac,1]);
swin = win./sqrt(coe/nfft);             % synthesis window

% istft
X = [X;conj(X(end-1:-1:2,:))];
X = real(ifft(X));

freNum = size(X,2);
xLen = (freNum-1)*shift+nfft;

x = zeros(xLen,1);
for o = 0:osFac-1
   xo = bsxfun(@times,X(:,o+1:osFac:end),swin);   
   xo = xo(:);
   x(o*shift+1:o*shift+length(xo)) = x(o*shift+1:o*shift+length(xo))+xo;
end
