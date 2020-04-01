fs = 16000;

load 'brir.mat'
load 'source.mat'

[I,J,Lr] = size(brir);
[~,Ls] = size(source);

Lx = Ls+Lr-1;
x = zeros(I,Lx);
for i = 1:I
    for j = 1:J
        x(i,:) = x(i,:)+conv(source(j,:),squeeze(brir(i,j,:)));
    end
end

y = ctf_lasso(x,brir);

figure;plot(y')
figure;plot(source')


