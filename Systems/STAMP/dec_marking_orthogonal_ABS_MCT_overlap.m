function [dec_output_bits,dec_bit_soft_tab] = dec_marking_orthogonal_ABS_MCT_overlap(N,Offset,input_data,IS,IS_f,Ns_freq,MAT_BASE,Fmin,Fmax,Fs,interl,ind_freqs_all)

%-------------------------------------------------------------------------
% Input data:
% N = window length
% Offset = offset in number of samples to start the procedure
% input_data = vector containing the watermarked audio
% coarse and fine search
% fine search
% IS = step (in samples) used to compute the offset for coarse synchronization
% IS_f = step (in samples) used to compute the offset for fine synchronization
% Ns_freq = number of frequencies in each segment of the same watermarked word
% MAT_BASE = matrix containing the base sequences of the watermark 
% (must have dimensions L , Ns_freq * Ns_slots;
% if size(MAT_BASE,1) is not satisfied, the last configuration is disfavored)
% Fmin, Fmax = minimum and maximum frequencies (Hz) used for watermark insertion
% Fs = audio sampling frequency
% interl = interleaving vector of length Lspread
%
%--------------------------------------------------------------------------
% Output data:
% dec_output_bits
% Num_bit_blocco = number of bits embedded in each block
%--------------------------------------------------------------------------

dec_bit_soft_tab = [];

%ind_freqs_all = find(freqs_all >= Fmin & freqs_all <= Fmax);
indxF = ind_freqs_all;%ind_freqs_all(1:floor(length(ind_freqs_all)/Ns_freq)*Ns_freq);
Nslots = size(MAT_BASE,2)/Ns_freq; %Numero di blocchi di N campioni su cui si inserisce il marchio

%Sistemazione di input data per tenere conto dell'overlapping
input_data_pre = input_data;
input_data = zeros(1,2*length(input_data_pre));
frame_count = 1;
while (frame_count+1)*N/2 <= length(input_data_pre)
    input_data((frame_count-1)*N+1:frame_count*N) = input_data_pre((frame_count-1)*N/2+1:(frame_count+1)*N/2);
    frame_count = frame_count + 1;
end;

input_data = input_data(1:(frame_count-1)*N);

cont_blocco = 1;
input_blocco = zeros(1,N*Nslots);
dec_output_bits = [];
for frame_count=1:floor(length(input_data)/N)
    input_blocco((cont_blocco-1)*N+1:cont_blocco*N) = input_data((frame_count-1)*N+1:frame_count*N);
    cont_blocco = cont_blocco + 1;
    if cont_blocco > Nslots
        [dec_bits_hard dec_bit_soft] = dec_marking_orthogonal_ABS_MCT_Block(N,input_blocco,Ns_freq,indxF,MAT_BASE,interl);
        dec_output_bits = [dec_output_bits dec_bits_hard];
        dec_bit_soft_tab = [dec_bit_soft_tab;dec_bit_soft];
        cont_blocco = 1;
    end;
end;
Num_bit_blocco = length(indxF)/Ns_freq*Nslots;
