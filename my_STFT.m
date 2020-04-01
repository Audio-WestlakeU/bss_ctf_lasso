function X = my_STFT(x,nfft,shift,win)
% STFT
% author: Xiaofei Li

% analysis window
osFac = nfft/shift;
coe = zeros(shift,1);
for i = 1:osFac
    coe = coe + win((i-1)*shift+1:i*shift).^2;
end
coe = repmat(coe,[osFac,1]);
awin = win./sqrt(nfft*coe);             % analysis window

x = x(:);
xLen = length(x);
fraNum = ceil((xLen-nfft+1)/shift);

X = zeros(nfft,fraNum);

for o = 0:osFac-1
    ofraNum = fix((xLen-shift*o)/nfft);
    X(:,o+1:osFac:end) = reshape(x(shift*o+1:shift*o+ofraNum*nfft),[nfft,ofraNum]);
end
X = fft(bsxfun(@times,X,awin));

X = X(1:nfft/2+1,:);

