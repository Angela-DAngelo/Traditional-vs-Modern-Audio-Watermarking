function y = fast_imdct2(X)

X=X(:); % force X to be a column vector

N = 2*length(X);

n0 = (N/2+1)/2;

Y = zeros(N,1);

Y(1:N/2) = X;

Y(N/2+1:N) = -1*flipud(X);

Y = Y .* exp(j*2*pi*[0:N-1]'*n0/N);

y = ifft(Y);

y =real(y .* exp(j*2*pi*([0:N-1]'+n0)/2/N));
