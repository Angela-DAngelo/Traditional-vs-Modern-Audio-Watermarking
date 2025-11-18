function y = fast_imdct(X)
format long;
N=2*length(X);
Y(1:N/2) = X;
Y(N/2+1:N) = -1*flipud(X);
Y=Y';
k=0:N-1;
no=(N/4)+0.5;
n=0:N-1;
pretwiddle=exp(j.*2.*pi.*k'.*no./N);
Z=Y.*pretwiddle;
z=ifft(Z);
posttwiddle=exp(j.*pi.*(n'+no)./N);
y=real(2*z.*posttwiddle);
