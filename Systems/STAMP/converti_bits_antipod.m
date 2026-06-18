function[bits_anitpod] = converti_bits_antipod(dec,n)
strb = dec2bin(dec,n);
for k = 1:n
    bits_anitpod(k) = 2*str2num(strb(k))-1;
end;