function X_mdct = fast_mdct(xn)
format long;
N=length(xn);
no=(N/4)+0.5;
n=0:N-1;
k=0:N/2-1;
pretwiddle=exp((-j*pi*n')/N);
posttwiddle=exp(-j*2*pi*no*(k'+0.5)/N);
xprime=xn.*pretwiddle;
Y=fft(xprime);
X_mdct=real(Y(1:N/2).*posttwiddle);
