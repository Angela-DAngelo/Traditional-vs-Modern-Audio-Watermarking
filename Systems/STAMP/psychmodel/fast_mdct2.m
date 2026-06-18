function y = fast_mdct2(x)

x=x(:);

N=length(x);

n0 = (N/2+1)/2;

y = zeros(N/2,1);

x = x .* exp(-j*2*pi*[0:N-1]'/2/N);

X = fft(x);

y = real(X(1:N/2) .* exp(-j*2*pi*n0*([0:N/2-1]'+0.5)/N));

y=y(:);
