function D = quad_derivative(X,S,A,Atrans)

%   S: IxP source_num x frame_num   
%   X: MxP microphone_num x frame_num 
%   A: MxIxQ microphone_num x source_num x filter_len
%   Atrans: IxMxQ microphone_num x source_num x filter_len

D1 = rctf_filt(A,S)-X;
D = rctf_invfilt(Atrans,D1);
