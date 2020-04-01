function s = ctf_lasso(x,rir,lambda,nfft,shift)
% CTF MINT
%
% x: time-domain microphone signal, size (No. of microphones x signal length )
% rir: room impulse response, size (No. of microphones x No. of sources x rir length)
% lambda: l1 regularization factor
% nfft: STFT window (frame) length
% shift: STFT frame shift
%
% y: estimated time-domain source signal, size (No. of sources x signal length)
%
% Author: Xiaofei Li, INRIA Grenoble Rhone-Alpes
% Copyright: Perception Team, INRIA Grenoble Rhone-Alpes
% The algorithm is described in the paper:
% Xiaofei Li, Laurent Girin and Radu Horaud. Audio Source Separation based on Convolutive 
% Transfer Function and Frequency-Domain Lasso Optimization. ICASSP, 2017.
%
%%

if nargin<4
    nfft = 512;
    shift = 256;
end
if nargin<3
    lambda = 1e-3;
end

[I,J,Lr] = size(rir);

% windows
osfac = round(nfft/shift);
win = hamming(nfft);
coe = zeros(shift,1);
for i = 1:osfac
    coe = coe + win((i-1)*shift+1:i*shift).^2;
end
coe = repmat(coe,[osfac,1]);
awin = win./sqrt(nfft*coe);                       % analysis window
swin = win./sqrt(coe/nfft);                       % synthesis window

% STFT of microphone signals
X = my_STFT(x(1,:),nfft,shift,win);
for i = 2:I
    X(:,:,i) = my_STFT(x(i,:),nfft,shift,win);
end
Lx = size(X,2);

%% CTF LASSO
La = length(shift:shift:Lr+2*nfft-2); % length of CTF

% Applying CTF LASSO for each frequency
K = nfft/2+1;
S = zeros(K,Lx,J);
for k =  1:K
    
    % CTF
    A = zeros(I,J,La);
    zeta = xcorr(awin,swin).*exp(1i*2*pi*(k-1)*(-nfft+1:nfft-1)'/nfft);
    for i = 1:I
        for j = 1:J
            aijk = conv(squeeze(rir(i,j,:)),zeta)/nfft;
            A(i,j,:) = aijk(shift:shift:end);
        end
    end      
    
    % microphone signal and source initialization
    Xk = squeeze(X(k,:,:)).';
    Sini = repmat(Xk(1,:),J,1);   
    
    % applying FISTA optimization
    Sk = FISTA_CTF(Xk,A,Sini,lambda);
    S(k,:,:) = Sk.';
end

s = my_ISTFT(S(:,:,1),shift,win);
for j = 2:J
    s(:,j) = my_ISTFT(S(:,:,j),shift,win);
end
s = s';