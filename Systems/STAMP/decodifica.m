addpath(genpath('D:\Mercatorum\Ricerca\AudioWatermarking\BarniAbrardo\'));
clear all;

tic;


SET_PARAM;
Fs = DATI_GEN.Fs;

dataset_name='FMA';
dataset_path = fullfile('../00_dataset/',dataset_name);

DELT = 1; %Shift in secondi per marchiare (evitando il primo periodo di silenzio)
Tmarchio = 4; %Durata in secondi del marchio
Ns1 = DELT*DATI_GEN.Fs+1;
Ns2 = (Tmarchio+DELT)*DATI_GEN.Fs;

MARCHIO = randi([0 1], 1, 4296); % o la sequenza desiderata ?? a che serve?

%Marchiatura
prof = 4; 


% % ciclo per processare tutti i file della dir
file_list = dir(fullfile(dataset_path, '*.wav')); 

% Inizializza nome del file Excel
outputExcel = ['results_aba_' dataset_name '.xlsx'];
% Inizializza cella per intestazioni
header = {'file name', 'correct bits','decoded message'};
% Scrivi l'intestazione al file Excel
writecell(header, outputExcel, 'Sheet', 1, 'Range', 'A1');

% leggi marchio
excelFile = ['watermark_aba_' dataset_name '.xlsx'];  % Sostituisci con il tuo file
data = readcell(excelFile, 'Sheet', 1);


file_names = {};
decoded_strings = {};
correct_bits = {};

for k = 1:length(file_list)
    file_name = file_list(k).name;
    [ ~, name, ext] = fileparts(file_name);
   
fprintf('Processando: %s\n', file_name);

[output_sound,interl,interl2,Nv] = Mark_audio(MARCHIO,dataset_name,file_name,Tmarchio,DELT,prof,MSSDH,DATI_GEN,Dati_code);


% % per cercare il marchio nel file audio non marchiato 
% [sound_stereo,Fs] = audioread(fullfile('audio_orig_wav', file_name));
% output_sound_all_n =sound_stereo;

%% per cercare il marchio nei file audio marchiati e attaccati
%audioFiles = dir(fullfile('attacked/',[dataset_name '_attacked'], '*.wav'));

%% per cercare il marchio nei file audio NON marchiati e attaccati
audioFiles = dir(fullfile('attacked/',[dataset_name '_nowm_attacked'], '*.wav'));

% Cicla su tutti i file
for k = 1:length(audioFiles)
    
    % Nome del file
    audioName = audioFiles(k).name;

    % Controlla se contiene la stringa del nome del file (es. 0005)
    if contains(audioName, name)  
        %% marchiati e attaccati
        %[sound_stereo,Fs] = audioread(fullfile('attacked/',[dataset_name '_attacked'], audioName));
        %% NON  marchiati e attaccati
        [sound_stereo,Fs] = audioread(fullfile('attacked/',[dataset_name '_nowm_attacked'], audioName));


output_sound_all_n =sound_stereo;

% Demarchiatura
[input_bits_est] = Demark_audio_ideale(output_sound_all_n,1000,prof,MSSDH,DATI_GEN,Dati_code,interl,interl2,Nv);

% Larghezza sequenza
len = length(input_bits_est);

bitArray = [];
% cerco il marchio per fare il confronto con la sequenza estratta: cerco la
% riga con prefisso corrispondente (dal file excel)
for i = 1:size(data, 1)
    cellValue = data{i, 1};
    if ischar(cellValue) || isstring(cellValue)
        if startsWith(cellValue, name)
            % celle da colonna 2 a 16
            rawBits = data(i, 2:17);
            
            % Converte ogni elemento in double
            bitArray = zeros(1, 16);  % inizializza
            for j = 1:16
                bitArray(1,j) = rawBits{j};
            end

            break;  % trovato, esci
        end
    end
end

% Output finale
if isempty(bitArray)
    warning('Nessuna riga trovata con prefisso "%s".', name);
end

% Confronto bit a bit (elementi uguali restituiscono true)
uguali = bitArray == input_bits_est;

% ContO quante volte i bit sono uguali
conteggio_uguali = sum(uguali);

% Stampa il risultato
fprintf('Numero di bit uguali nei primi %d elementi: %d\n', length(input_bits_est), conteggio_uguali);

% Salva i risultati
file_names{end+1} = audioFiles(k).name;
decoded_strings{end+1} = input_bits_est;
correct_bits{end+1} = conteggio_uguali;

% Salva nel file Excel
newRow = {audioFiles(k).name, conteggio_uguali, input_bits_est};
writecell(newRow, outputExcel, 'Sheet', 1, 'Range', sprintf('A%d', k+1));

    end
end

end

elapsed = toc;          % tempo trascorso in secondi
fprintf('Tempo: %.4f secondi\n', elapsed);