function [Xm,f] = magspectrum(x,fs,nfft)

% Usage: [Xm,f] = magspectrum(x,fs,nfft)

if(~exist('fs'))
 fs = 2; % So that 'f' ranges from 0 to 1 (0 to fs/2)
end

if(~exist('nfft'))
 nfft = 2^(nextpow2(length(x))+1);
end

X = fft(x,nfft);

Xm = abs(X);

Xm = Xm(1:nfft/2+1);

f = [0:nfft/2]*fs/nfft;

return;
