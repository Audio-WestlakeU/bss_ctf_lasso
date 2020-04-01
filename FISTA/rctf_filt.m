function X = rctf_filt(A,S)

%   S: IxP source_num x frame_num
%   A: MxIxQ microphone_num x source_num x filter_len
%   X: MxP microphone_num x frame_num 

[M,I,~] = size(A);
P = size(S,2);

X = zeros(M,P);

for m=1:M
    for i=1:I
        Xmi = conv(S(i,:),squeeze(A(m,i,:)));
        X(m,:) = X(m,:)+Xmi(1:P);
    end
end

