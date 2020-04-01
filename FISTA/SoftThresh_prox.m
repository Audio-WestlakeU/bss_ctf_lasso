function x = SoftThresh_prox(y,t)
% SoftThresh -- Apply Soft Threshold 
%  Usage 
%    x = SoftThresh(y,t)
%  Inputs 
%    y     Noisy Data 
%    t     Threshold
%  Outputs 
%    x     sign(y)(|y|-t)_+
%

    arg = zeros(size(y));
    arg(abs(y)~=0) = y(abs(y)~=0)./abs(y(abs(y)~=0));

	res = (abs(y) - t);
	res = (res + abs(res))/2;
	x   = arg.*res;

%
% Copyright (c) 1993-5.  Jonathan Buckheit, David Donoho and Iain Johnstone
%
    
    
%   
% Part of WaveLab Version 802
% Built Sunday, October 3, 1999 8:52:27 AM
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail wavelab@stat.stanford.edu
%   
    
