function S = rctf_invfilt(Atrans,X)

%   X: MxP microphone_num x frame_num
%   Atrans: IxMxQ microphone_num x source_num x filter_len
%   S: IxP source_num x frame_num


[I,M,Q] = size(Atrans);
P = size(X,2);

S = zeros(I,P);

for i=1:I
    for m=1:M
        Sim = conv(X(m,:),squeeze(Atrans(i,m,:)));
        S(i,:) = S(i,:)+Sim(Q:end);
    end
end
