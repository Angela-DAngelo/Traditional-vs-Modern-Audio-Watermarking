function X = mdct(xn)
N=length(xn);
xsum=0;
no=(N/4)+0.5;
for k=1:N/2
    for i=1:N
    xsum=xsum + xn(i)*cos(2*pi/N*(i-1+no)*(k-1+0.5));
    end
    X(k)=xsum;
    xsum=0;
end
X=X';