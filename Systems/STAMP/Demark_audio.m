function[input_bits_est] = Demark_audio(output_sound,Offset_M_eff_samp,prof,MSSDH,DATI_GEN,Dati_code,interl,interl2,Nv)

Nslots = MSSDH.Ns(prof);
Fmin = MSSDH.fmin(prof);
Fmax = MSSDH.fmax(prof);
Ns_freq = MSSDH.Nf(prof);
PREC = DATI_GEN.delta/DATI_GEN.N; 
PREC_f = DATI_GEN.lambda/DATI_GEN.N; 
IS = round(DATI_GEN.N*PREC);
IS = 2^(round(log2(IS)));
IS_f = round(DATI_GEN.N*PREC_f);
IS_f = 2^(round(log2(IS_f)));
Lspread = Ns_freq*Nslots; 
MAT_BASE = ones(2,Lspread);
MAT_BASE(1,1:2:Lspread) = -1;
MAT_BASE(2,2:2:Lspread) = -1;

ind_freqs_all = find(DATI_GEN.freqs_all >= Fmin & DATI_GEN.freqs_all <= Fmax);
if Ns_freq >= length(ind_freqs_all)
    Ns_freq = length(ind_freqs_all);
end;
ind_freqs_all = ind_freqs_all(1:floor(length(ind_freqs_all)/Ns_freq)*Ns_freq);

Dati_code.L = MSSDH.K(prof);
Dati_code.m = MSSDH.H(prof);
Dati_code.K = MSSDH.Pi(prof);

Dati_code.Keff = Dati_code.K; 
% Synchronization and extraction of hard and soft coded symbols
[dec_output_bits,dec_bit_soft_tab] = dec_marking_orthogonal_ABS_MCT_overlap(DATI_GEN.N,Offset_M_eff_samp,output_sound,IS,IS_f,Ns_freq,MAT_BASE,Fmin,Fmax,DATI_GEN.Fs,interl,ind_freqs_all);
dec_output_soft_bits = reshape(dec_bit_soft_tab.',1,length(dec_output_bits));
dec_output_soft_bits = dec_output_soft_bits .* (2*dec_output_bits-1);

input_bits_est = [];

Nvt = Dati_code.n/Dati_code.k * (Dati_code.Keff+Dati_code.constlen_p-1);
max_indx = Nv;
cont = 1;
%Decoding
fprintf('Decoding ......... \n');
cont_eff = 0;
while max_indx < length(dec_output_bits)
    Y = dec_output_soft_bits(cont:cont+Nv-1);
    %Depuncturing
    Yeff = zeros(1,Nvt);
    Yeff = reshape(Yeff,Dati_code.n,length(Yeff)/Dati_code.n);
    punct_mat = repmat(Dati_code.punct_mat,1,ceil(size(Yeff,2)/size(Dati_code.punct_mat,2)));
    punct_mat = punct_mat(:,1:size(Yeff,2));
    indx = find(punct_mat == 1);
    Yeff(indx) = Y;
    Yeff = reshape(Yeff,1,Nvt);
    [B] = viterbi_dec_soft_new(Yeff, Dati_code.trellis, Dati_code.Keff, 0);
    msg_dec = (sign(B)+1)/2;
    msg_info = msg_dec(1:Dati_code.K);
    msg_info = msg_info(interl2);
    msg_decm = msg_dec(1:length(msg_dec)-Dati_code.constlen_p+1);
    msg_decm(1:Dati_code.K) = msg_info;
            
    % The CRC is not used in this implementation
    %[outdata,error]= CRC_decode_new_n1_mod(msg_decm,length(msg_decm),Dati_code.Pol_CRC.');   
    outdata=msg_decm;
    error=0;
    if error == 0 % Parity check
        fprintf('#Packet OK\n')
        msg_dec = msg_dec(1:Dati_code.K);
        cont_eff = cont_eff + length(msg_dec);
        input_bits_est(1,size(input_bits_est,2)+1:size(input_bits_est,2)+length(msg_dec)) = msg_dec;
        break; 
   else
        fprintf('#Pacchetto NO\n')
        msg_dec = msg_dec(1:Dati_code.K);
        cont_eff = cont_eff + length(msg_dec);
        input_bits_est(1,size(input_bits_est,2)+1:size(input_bits_est,2)+length(msg_dec)) = msg_dec;
        break; 
    end
    cont = cont + Nv/Dati_code.m;
    max_indx = max_indx + Nv/Dati_code.m;    
end
%fprintf('Number of decoded bits: %d\n',cont_eff);
