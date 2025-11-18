function [First_Frame original_sound output_sound Fs Ns_freq PSICO_ACOUSTIC] = marking_orthogonal_ABS_MCT_overlap(input_sound,Offset_M,Fs,Ns_freq,Lspread,Fmin,Fmax,N,input_bits,MAT_BASE,PSICO_ACOUSTIC,interl,ind_freqs_all,SOGLIA_PM)

%--------------------------------------------------------------------------
% Input data:
% input_sound = audio data to be watermarked
% Offset_M = offset for watermark insertion (to avoid the initial silent period);
%             represents the number of N-sample blocks skipped at the beginning
% Fs = sampling frequency
% Ns_freq = number of frequencies per bit
% Lspread = total length of the spreading sequence
% Fmin, Fmax = minimum and maximum frequencies for watermark embedding
% N = window length
% input_bits = transmitted bits (can be empty; if so, bits are generated internally)
% MAT_BASE = matrix containing the spreading sequences
% PSICO_ACOUSTIC = stored psychoacoustic model (see DESCRIPTION.txt
%                   in the 'modelli_PAFM' directory). If empty, it will be created.
% interl = interleaving vector of length Lspread
% ind_freqs_all = numeric indices of the frequencies where the watermark is inserted
% SOGLIA_PM = vector of size N/2 defining additional protection on the
%              psychoacoustic model across different frequencies
%--------------------------------------------------------------------------
% Output data:
% First_Frame = first watermarked frame
% original_sound = samples of the original audio file
% output_sound = samples of the watermarked audio file
%--------------------------------------------------------------------------

MEMORIZZA = 1; %se 1 si memorizzano i VARS durante la marchiatura per fare prove offline con dati reali
if MEMORIZZA == 1
    Num_dati_mem_max = 1e4;
    VARS_ALL = zeros(Num_dati_mem_max,Lspread);
    C_ALL = zeros(Num_dati_mem_max,Lspread);
    Cw_ALL = zeros(Num_dati_mem_max,Lspread);
    cont_mem = 1;
end;

k = 1;
windw = window(@triang,N); %Finestra per il calcolo del modello psicoacustico
MAX_IN = max(abs(input_sound)); %Per la normalizzazione nel calcolo della maschera PAFM, non si usa 2^(b-1) come nel paper ma il massimo vero e proprio
First_Frame = [];
original_sound = input_sound;
output_sound_pre = zeros(1,2*length(input_sound));
output_sound = 0*input_sound.';

Nslots = Lspread/Ns_freq;

%Valutazione delle Delta_f di ampiezza Ns_freq
for bb = 0:floor(length(ind_freqs_all)/Ns_freq)-1
    Indici_freq(bb+1).vals = ind_freqs_all(bb*Ns_freq+1:(bb+1)*Ns_freq);
end;

%Soglia psicoacustica assoluta
F=linspace(0,Fs/2,N/2);
tq=(3.64.*((F./1000).^-0.8))-(6.5.*exp(-0.6.*(F./(1000-3.3)).^2))+(10e-3.*((F./1000).^4));

cont_bits = k;
flag_first = 0;
frame_count = 1;
Num_blocchi = 1;
psico = 0;
if length(PSICO_ACOUSTIC) == 0
    psico = 1;
end;
cont_psico_blocks = 1;
while (frame_count+Nslots)*N/2 <= length(original_sound)
    sig_t = original_sound((frame_count-1)*N/2+1:(frame_count+1)*N/2);
    if frame_count-1 < Offset_M | sum(sig_t.^2) < 1e-10
        output_sound_pre((frame_count-1)*N+1:frame_count*N) =  imclt_mia(mclt_mia(sig_t.'));
        frame_count = frame_count + 1;
    else
        if flag_first == 0
            flag_first = 1;
            First_Frame = frame_count;
        end;
        if rem(Num_blocchi,10) == 0
            fprintf('Watermarking block %d of %d\n',Num_blocchi,floor(length(original_sound)/(N/2)/Nslots));
        end;
        Num_blocchi = Num_blocchi + 1;
        %Valutazione degli errori su tutti gli intervalli di frequenza secondo il modello piscoacustico
        VARS = zeros(1,length(ind_freqs_all)/Ns_freq);
        sig_f_blocco_w = zeros(N/2,Nslots);
        sig_f_blocco_w_all = zeros(N/2,Nslots);
        sig_f_blocco = [];
        SNR_ALL_blocco = zeros(N/2,Nslots);
        VAR_ALL_blocco = zeros(N/2,Nslots);
        %La maschera del modello PAFM rappresenta il livello di un segnale
        %che posso aggiungere senza sentirlo
        for t = 1:Nslots
            sig_t = original_sound((frame_count-1)*N/2+1:(frame_count+1)*N/2);
            fft_frame = mclt_mia(sig_t.');
            sig_f_blocco = [sig_f_blocco fft_frame.'];
                                                
            %Evaluate Masking threshold
            absfft = abs(fft_frame(1:N/2));
            % per ricreare la maschera
            %psico=0;
            if psico == 1             
                gmask = psychmodel(abs(fft(sig_t.'.*windw.')).'/(N*MAX_IN),tq,F).'-90.302+20*log10(N*MAX_IN);                                
                if length(gmask) == 0
                    gmask = 20*log10(abs(fft_frame(1:N/2))/10);
                end;  
%                 absfft_dB = 20*log10(absfft);
%                 indx_min = find(absfft_dB < gmask+SOGLIA_PM-6);
%                 indx_min = indx_min(indx_min > 1);
%                 absfft_dB(indx_min) = gmask(indx_min)+SOGLIA_PM(indx_min)-6;
%                 absfft = 10.^(absfft_dB/20);
                New_FFT = 20*log10(absfft)-gmask-SOGLIA_PM;
                New_FFT_indices = find(New_FFT > 0);
                New_FFT2 = zeros(1,N/2);
                New_FFT2(New_FFT_indices) = New_FFT(New_FFT_indices);
                gmask_l = 10.^(-New_FFT2/20).*(absfft);
                PSICO_ACOUSTIC(cont_psico_blocks).gmask_l = gmask_l;
                PSICO_ACOUSTIC(cont_psico_blocks).gmask = gmask;
            else
                if cont_psico_blocks <= length(PSICO_ACOUSTIC)
                    gmask = PSICO_ACOUSTIC(cont_psico_blocks).gmask+SOGLIA_PM;
                else
                    gmask = PSICO_ACOUSTIC(length(PSICO_ACOUSTIC)).gmask+SOGLIA_PM;
                end;
%                 absfft_dB = 20*log10(absfft);
%                 indx_min = find(absfft_dB < gmask+SOGLIA_PM-6);
%                 indx_min = indx_min(indx_min > 1);
%                 absfft_dB(indx_min) = gmask(indx_min)+SOGLIA_PM(indx_min)-6;
%                 absfft = 10.^(absfft_dB/20);                
                New_FFT = 20*log10(absfft)-gmask-SOGLIA_PM;
                New_FFT_indices = find(New_FFT > 0);
                New_FFT2 = zeros(1,N/2);
                New_FFT2(New_FFT_indices) = New_FFT(New_FFT_indices);
                gmask_l = 10.^(-New_FFT2/20).*(absfft);
            end;
            cont_psico_blocks = cont_psico_blocks + 1;            
            %Creazione della varianza rumore su ogni riga
            VAR_ALL_blocco(:,t) = (gmask_l.^2)./(absfft.^2);
            sig_f_blocco_w_all(:,t) = fft_frame.';
            sig_f_blocco_w(:,t) = absfft.';
            frame_count = frame_count+1;
        end;
        %Marchiatura segmento per segmento
        sig_f_blocco_m = sig_f_blocco_w_all;
        for vv = 1:length(ind_freqs_all)/Ns_freq           
            Cpre = sig_f_blocco_w(Indici_freq(vv).vals,:);  

            C = reshape(Cpre,1,Lspread);
            VARs = reshape(VAR_ALL_blocco(Indici_freq(vv).vals,:),1,Lspread);
            VARs = VARs(interl);
            
            if MEMORIZZA == 1
                VARS_ALL(cont_mem,:) = VARs;
                C_ALL(cont_mem,:) = C;
                
            end;
            C = C(interl);
            if length(input_bits) == 0
                Y = 2*(randi(2,1,k)-1)-1;
            else
             %%%%   Y = 2*input_bits(cont_bits-k+1:cont_bits)-1;

if cont_bits - k + 1 <= 0 || cont_bits > length(input_bits)
    break;  % esce se abbiamo finito i bit da marchiare
end
Y = 2*input_bits(cont_bits-k+1:cont_bits)-1;



            end;
            cont_bits = cont_bits + k;
            
            if Y == -1
                Cwpre = (sqrt(VARs).*MAT_BASE(1,:)+1).*C;
            else
                Cwpre = (sqrt(VARs).*MAT_BASE(2,:)+1).*C;
            end;
            Cwpre(interl) = Cwpre;
            Cwpre(Cwpre < 0) = 0;
            if MEMORIZZA == 1
                Cw_ALL(cont_mem,:) = Cwpre;
                cont_mem = cont_mem + 1;
            end;

            Cwpre = reshape(Cwpre,Ns_freq,Nslots);
        
            sig_f_blocco_m(Indici_freq(vv).vals,:) = Cwpre.*exp(sqrt(-1)*angle(sig_f_blocco_w_all(Indici_freq(vv).vals,:)));
        end
        for ns = 1:Nslots
            sig_t_blocco_m(:,ns) = imclt_mia(sig_f_blocco_m(:,ns).').';
        end;
        sig_t_blocco_m_eff = reshape(sig_t_blocco_m,1,N*Nslots);
        output_sound_pre((frame_count-Nslots-1)*N+1:(frame_count-1)*N) = sig_t_blocco_m_eff.';
    end % end of If-Else Statement
end % end of frame loop
%Overlapping per creare il segnale in uscita
frame_count = 1;
while (frame_count+1)*N/2 <= length(output_sound) & frame_count*N <= length(output_sound_pre)
    output_sound((frame_count-1)*N/2+1:(frame_count+1)*N/2) = output_sound((frame_count-1)*N/2+1:(frame_count+1)*N/2) + output_sound_pre((frame_count-1)*N+1:frame_count*N);
    frame_count = frame_count + 1;
end;
output_sound = output_sound.';
VARS_ALL = VARS_ALL(1:cont_mem-1,:);
C_ALL = C_ALL(1:cont_mem-1,:);
Cw_ALL = Cw_ALL(1:cont_mem-1,:);

save DATI_MEM VARS_ALL C_ALL Cw_ALL;
disp('Okay, all done!');
