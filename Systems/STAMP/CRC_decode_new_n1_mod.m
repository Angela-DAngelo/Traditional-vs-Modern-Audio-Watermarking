function [DC,indicate]= CRC_decode_new_n1_mod(C,n,G)
%CRC code (n,k) function
%Input:
%   C(1,x*n) input data
%   n:
%   G:generating polynomial.(1,n-k+1)
%Output:
%   DC:(1,x*k) decoded data;
%   indicate: CRC indicator,0-correct,>=1-err;
len1=length(G);%len1=n-k+1 **已经比n-k大1了。
k=n-len1+1;
len2=length(C);
M=reshape(C,n,len2/n);
DC=reshape(M(1:k,:),1,k*len2/n);
indicate=zeros(1,len2/n);

%CRC_deco 部分
t=M(1:n-k+1,:);%8=n-k;eg.n-k+1=9; t为矩阵
GG=[];
for ii=1:len2/n
    GG=[GG,t(1,ii).*G];
end
t=mod((t+GG),2);
for jj=n-k+2:n
    GG=[];
    t=[t(2:n-k+1,:);M(jj,:)];
    for ii=1:len2/n
        GG=[GG,t(1,ii).*G];
    end
    t=mod((t+GG),2);
end
indicate=sum(t);