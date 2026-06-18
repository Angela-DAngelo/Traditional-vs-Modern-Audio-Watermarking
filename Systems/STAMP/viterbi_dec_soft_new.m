function [B max_Vit] = viterbi_dec_soft_new(rec_s, trellis, L_total, final_state)
%rec_s = coded signal to be decoded
%trellis = trellis structure (use convert_trellis_new to convert matlab
%trellis 
%L_total = number of samples
%final_state = termination state of the trellis
%B = decoded bits in antipodal form

next_out = trellis.next_out;
next_state = trellis.next_state;
next_bit = trellis.next_bit;
last_out = trellis.last_out;
last_state = trellis.last_state;
last_bit = trellis.last_bit;
nstates = trellis.nstates;
k = trellis.k;
n = trellis.n;
m = log2(nstates);

L_total = L_total + m;
Infty = 1e10;

% Initialize path metrics to -Infty
for t=1:L_total+1
   for state=1:nstates
      path_metric(state,t) = -Infty;
   end
end

% Trace forward to compute all the path metrics
path_metric(1,1) = 0;
state_true_prec = 0;
for t=1:L_total/k
   y = rec_s((t-1)*n+1:n*t);
   for state=1:nstates
       for p = 0:2^k-1
           sym = last_out(state,p*n+1:(p+1)*n);
           staten(p+1) = last_state(state,p+1);
           Mk(p+1) = y*sym' + path_metric(staten(p+1),t);
       end;
       [mass indm] = max(Mk);
       path_metric(state,t+1)=Mk(indm);
       prev_bit(state, t*k+1:(t+1)*k) = last_bit(state,(indm-1)*k+1:indm*k);
       prev_state(state, t+1) = staten(indm);
   end
end
      
% Trace back from the final state
mlstate(L_total/k+1) = final_state + 1;
max_Vit = path_metric(1,t+1);
% Trace back to get the estimated bits, and the most likely path
for t=L_total/k:-1:1
   est((t-1)*k+1:t*k) = prev_bit(mlstate(t+1),t*k+1:(t+1)*k);
   mlstate(t) = prev_state(mlstate(t+1), t+1);
end
B = est;
                  
               
      
        
   
