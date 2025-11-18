function [next_out, next_state, next_bit, last_out, last_state, last_bit, n, k, numStates] = convert_trellis_new(trellis)
% next_out(i,p*n+1:(p+1)*n): trellis next_out (systematic bit; parity bit) when input = p, state = i; next_out(i,j) = -1 or 1
% next_state(i,p+1): next state when input = p, state = i; 
% last_out(i,p*n+1:(p+1)*n): trellis last_out (systematic bit; parity bit) with p-th info. bit, state = i; last_out(i,j) = -1 or 1
% last_state(i,m): previous state that comes to state i whith m-th info. bit;
% last_bit(i,(m-1)*k+1:m:k): previous bits that comes to state i;

k = log2(trellis.numInputSymbols);
n = log2(trellis.numOutputSymbols);
numStates = trellis.numStates;
nextStates = trellis.nextStates;
outputs = oct2dec(trellis.outputs);

for kt = 1:numStates
    next_state(kt,:) = nextStates(kt,:)+1;
    for p = 0:2^k-1
        next_out(kt,p*n+1:(p+1)*n) = converti_bits_antipod(outputs(kt,p+1),n);
        next_bit(kt,p*k+1:(p+1)*k) = converti_bits_antipod(p,k);
    end;
    cont = 1;
    for p = 0:2^k-1
        indx0 = find(nextStates(:,p+1) == kt-1);
         for h = 1:length(indx0) 
            last_state(kt,cont) = indx0(h);
            last_bit(kt,(cont-1)*k+1:cont*k) = converti_bits_antipod(p,k);
            last_out(kt,(cont-1)*n+1:cont*n) = converti_bits_antipod(outputs(indx0(h),p+1),n);
            cont = cont + 1;
        end;
    end;
end;
