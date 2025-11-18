function[codegen,constlen] = converti_codegen(codegen_p,constlen_p,k)
n = length(codegen_p);
codegen = zeros(k,n);
for hh = 1:n
    d = dec2bin(oct2dec(codegen_p(hh)),constlen_p*k);
    for ht = 1:k
        dd = d((ht-1)*constlen_p+1:ht*constlen_p);
        codegen(ht,hh) = str2num(dec2base(bin2dec(dd),8));
    end;
end;
constlen = constlen_p * ones(1,k);