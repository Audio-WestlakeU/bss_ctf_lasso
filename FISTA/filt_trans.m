function Atrans = filt_trans(A)

%   A: MxIxQ microphone_num x source_num x filter_len
%   Atrans: IxMxQ microphone_num x source_num x filter_len. Hermitian transposition of source and channel index and time reversal of the filter

Atrans = conj(permute(A,[2,1,3]));
Atrans = Atrans(:,:,end:-1:1);