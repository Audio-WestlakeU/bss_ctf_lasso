function S = FISTA_CTF(X,A,Sini,lambda)

%   X: MxP microphone_num x frame_num
%   A: MxIxQ microphone_num x source_num x filter_len
%   Sini: IxP source_num x frame_num

maxit = 1000;

Atrans = filt_trans(A);
L = power_ite(A,Atrans,Sini);

Xpow = sum(sum(abs(X).^2));
objval = zeros(maxit,1);

Sold = Sini;
Z = Sold;
t = 1;
for it = 1:maxit
       
    objval(it) = (sum(sum(abs(rctf_filt(A,Sold)-X).^2)))+lambda*sum(sum(abs(Sold)));
    if it>1 && objval(it-1)-objval(it)<Xpow*1e-5
        break
    end
    
    D = Z-(quad_derivative(X,Z,A,Atrans))/L;    
    S = SoftThresh_prox(D,lambda/L);
    
    oldt = t;
    t = (1+sqrt(1+4*t^2))/2;
    
    Z = S + (oldt-1)/t * (S-Sold);
    Sold = S;   
end

objval = objval(1:it);