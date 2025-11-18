function [dec_bits_hard dec_bits_soft] = dec_marking_orthogonal_ABS_MCT_Block(N,input_data,Ns_freq,indxF,MAT_BASE,interl)

%--------------------------------------------------------------------------
% Input data:
% N = window length
% input_data = data block containing the watermarked audio
% Ns_freq = number of frequencies in each segment of the same watermarked word
%
% indxF = contains the indices of the frequencies
% (from 0 to N/2-1) used for watermarking; the number of values must be
% a multiple of Ns_freq
% MAT_BASE = matrix containing the base sequences of the watermark 
% (must have dimensions L , Ns_freq * Ns_slots;
% if size(MAT_BASE,1) is not satisfied, the last configuration is disfavored)
% interl = interleaving vector of length Lspread
%--------------------------------------------------------------------------
% Output data:
% dec_bits_hard
% dec_bit_soft
%--------------------------------------------------------------------------

dec_bits_hard = [];
dec_bits_soft = [];

%Nslots = numero slot temporali di lunghezza N che contengono la parola
%marchiata: in sostanza un bit e' embedded in Ns_freq * Nslots campioni
Nslots = length(input_data) / N;
Lspread = Nslots*Ns_freq;
if floor(Nslots) ~= Nslots
    fprintf('Errore: input_data deve avere lunghezza multipla di N \n');
    return;
end;
if Lspread ~= Ns_freq * Nslots
    fprintf('Errore in Lspread \n');
    return;
end;
if floor(length(indxF)/Ns_freq) ~= length(indxF)/Ns_freq
    fprintf('Errore: indxF deve avere lunghezza multipla di Ns_freq \n');
    return;
end;
DATA_MARKED = zeros(length(indxF)/Ns_freq,Ns_freq*Nslots);
input_data_M = reshape(input_data,N,length(input_data)/N);
input_data_MWF = abs((mclt_mia(input_data_M.')).');
input_data_MWF = input_data_MWF(indxF,:);
for p = 1:length(indxF)/Ns_freq
    DATA_MARKED(p,:) = reshape(input_data_MWF((p-1)*Ns_freq+1:p*Ns_freq,:),1,Ns_freq*Nslots);
    DATA_MARKED(p,:) = DATA_MARKED(p,interl); 
end;


%Decodifica
dec_bits_hard = zeros(1,length(indxF)/Ns_freq);
dec_bits_soft = zeros(1,length(indxF)/Ns_freq);
if size(MAT_BASE,2) < Lspread
    Lspread_pre = Lspread/size(MAT_BASE,2);
    A = zeros(size(MAT_BASE,2),Lspread);
    for g = 1:size(MAT_BASE,2)
        A(g,g:2*size(MAT_BASE,2):Lspread) = 1;
        A(g,g+size(MAT_BASE,2):2*size(MAT_BASE,2):Lspread) = -1;
    end;
    DATA_MARKED = (A*DATA_MARKED.').';
end

CORRS_ALL = MAT_BASE * DATA_MARKED.';

[maxv indxm] = max(CORRS_ALL);
symbs_decimale = floor((indxm(1,:)-1)/(size(MAT_BASE,1)/2));
dec_bits_hard = symbs_decimale;
dec_bits_soft = abs(maxv)./(sqrt((Lspread*var((DATA_MARKED.')))));%abs(maxv)./(sqrt((Lspread*var((DATA_MARKED.')))));
    
