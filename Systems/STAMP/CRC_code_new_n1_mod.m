function C = CRC_code_new_n1_mod(M,n,G)
%CRC code (n,k) function
%Input:
%   M:(1,x*k) input data
%   n:
%   G:generating polynomial.(1,n-k+1)
%Output:
%   C:(1,n) coded data;
len1=length(G);%len1=n-k+1 已经比n-k大1了。
k=n-len1+1;
len2=length(M);
M1=reshape(M,k,len2/k);
C1=zeros(n,len2/k);
C1(1:k,:)=M1;
%t=zeros(n-k+1,1);
%CRC 部分
t=C1(1:n-k+1,:);%8=n-k;eg.n-k+1=9; t为矩阵
GG=[];
for ii=1:len2/k
    GG=[GG,t(1,ii).*G];
end
t=mod((t+GG),2);
for jj=n-k+2:n
    GG=[];
    t=[t(2:n-k+1,:);C1(jj,:)];
    for ii=1:len2/k
        GG=[GG,t(1,ii).*G];
    end
    t=mod((t+GG),2);
end
C1(k+1:n,:)=t(2:n-k+1,:);%2-9,共8位
C=reshape(C1,1,n*len2/k);