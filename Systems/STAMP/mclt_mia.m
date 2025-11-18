%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           MCLT            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y wa] = mclt_mia(x)

Nseq = size(x,1);
N = size(x,2)/2;
%wa = repmat(sqrt(window(@triang,2*N)),1,Nseq); 
wa = repmat(sin(([0:2*N-1]'+0.5)/(2*N)*pi),1,Nseq);
x = x.*(wa.');
xtil = x.*repmat(exp(-i*2*pi*[0:2*N-1]/(4*N)),Nseq,1);
y = (fft(xtil.')).';
y = y(:,1:N);
y = y.*repmat(exp(-i*2*pi*(N+1)*([0:N-1])/(4*N)),Nseq,1);
y = y*exp(-i*pi*(N+1)/(4*N));

