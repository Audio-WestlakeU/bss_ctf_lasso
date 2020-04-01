function [L,Sunit] = power_ite(A,Atrans,Sini)

maxitl = 1000;

Snorm = sqrt(sum(sum(abs(Sini).^2)));
Sunit = Sini/Snorm;

for it=1:maxitl
    Sit = rctf_invfilt(Atrans,rctf_filt(A,Sunit));
    Snorm = sqrt(sum(sum(abs(Sit).^2)));
    
    if abs(sum(sum(Sunit.*conj(Sit/Snorm))))>0.999
        break;
    else
        Sunit = Sit/Snorm;
    end
end
  
L = 1.01*Snorm;
