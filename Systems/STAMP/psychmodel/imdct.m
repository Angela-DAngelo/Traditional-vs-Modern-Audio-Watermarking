function X = imdct(xn)
N=length(xn);
xsum=0;
no=(N/4)+0.5;
for i=1:2*N
    for k=1:N
    xsum=xsum + xn(k)*cos(2*pi/N*(i-1+no)*(k-1+0.5));
    end
    X(i)=(2/N)*xsum;
    xsum=0;
end
X=X';