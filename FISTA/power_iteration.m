function lambda = power_iteration(A,T,options)

if ~isfield(options, 'Forward_Transform')
    options.Forward_Transform = @stft2;
end
Ftrans = options.Forward_Transform;

if ~isfield(options, 'Forward_arg')
    options.Forward_arg(1) = 1024;
    options.Forward_arg(2) = 512;
end
argFT = options.Forward_arg;


if ~isfield(options, 'Inverse_Transform')
    options.Inverse_Transform = @istft2;
end
Itrans = options.Inverse_Transform;

if ~isfield(options, 'Inverse_arg')
    options.Inverse_arg(1) = options.Forward_arg(2);
    options.Inverse_arg(2) = T;
end
argIT = options.Inverse_arg;

if ~isfield(options, 'maxitl')
    options.maxitl = 1000; 
end

[M,N,K] = size(A);
 At = retourne_mat(A);
  
tr = Ftrans(ones(1,T),argFT);
[Mtr,Ntr] = size(tr);
dcc = ones(Mtr,Ntr,N);
Sg = ones(N,T);
AtAdcc = zeros(Mtr,Ntr,N);

for it=1:options.maxitl

    for n=1:N
        Sg(n,:) = Itrans(dcc(:,:,n),argIT);
    end
    AS =  creation_mel_conv(A,Sg);
    AtAS = creation_mel_conv(At,AS);
    AtAS = AtAS(:,K:T+K-1);
    for n=1:N
        AtAdcc(:,:,n) = Ftrans(AtAS(n,:),argFT);
    end

    lambda = max(max(max(abs(AtAdcc))));
    dcc = AtAdcc/lambda;
    %disp(lambda);
end
  
