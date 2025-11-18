%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           IMCLT            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x wa] = imclt_mia(y)

%Costruzione della sequenza aliased
N = length(y);
ks = [0:N-1];
ytil = y.*exp(i*(N+1)*pi*ks/(2*N));
xtil = ifft(ytil,2*N)*exp(i*pi*(N+1)/(4*N));
ns = [0:2*N-1];
xtil = xtil .* exp(i*pi*ns/(2*N)); 
xtil = real(xtil);
%wa = sqrt(window(@triang,2*N)); 
wa = sin(([0:2*N-1]'+0.5)/(2*N)*pi);
x = 2*xtil.*wa.';

