function[codeword] = crea_mlc(N,stages)
taps = zeros(1,N);
for i=1:size(stages,2)
   taps(stages(i)) = 1;
end;
M = 2^N-1;
m = ones(1,N);

regout = zeros(1,M);

for ind = 1:M    
    buf = mod(sum(taps.*m),2);    
    m(2:N) = m(1:N-1);
    m(1)=buf;
    regout(ind) = m(N);
end

comp = ~ regout; codeword = regout - comp;

