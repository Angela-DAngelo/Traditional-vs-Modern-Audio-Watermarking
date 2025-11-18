function[out]=testMDCT(in)
M=length(in);
reorder=zeros([1,M]);
rotate1=zeros([1,M]);
for n=1:M/2
    reorder(n)=in(2*n-1);
    reorder(n+M/2)=in((M-2*n)+2);
end
for i=1:M/2
rotate1(i)=real((reorder(i)+j*reorder(i+M/2))*exp(-j*(n-1*1/4)*pi/M));
rotate1(n+M/2)=imag((reorder(i)+j*reorder(i+M/2))*exp(-j*(n-1*1/4)*pi/M));
end
out=fft(rotate1);