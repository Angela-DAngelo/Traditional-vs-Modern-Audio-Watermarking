function [bit_aggiunti, rate_effettivo, Zv] = bit_aggiunti_codifica(Dati_code)
    % Lunghezza dei dati originali per blocco
    K = Dati_code.K;

    % Lunghezza CRC
    L_crc = length(Dati_code.Pol_CRC) - 1;
    
    % Lunghezza dei bit di coda
    Tail = Dati_code.constlen_p - 1;

    % Totale bit in input al codificatore convoluzionale
    total_input = K + L_crc + Tail;

    % Numero di uscite del codificatore (es. 2 per codificatore rate 1/2)
    n = Dati_code.n;

    % Numero di bit in uscita grezza (senza punteggiatura)
    coded_raw = total_input * n;

    % Applichiamo la maschera di punteggiatura
    punct_mat = Dati_code.punct_mat;
    pattern_length = numel(punct_mat);

    % Calcoliamo quanti bit restano dopo punteggiatura su un pattern
    bits_kept_per_pattern = sum(punct_mat(:));

    % Frazione di bit trasmessi
    fraction_kept = bits_kept_per_pattern / pattern_length;

    % Numero effettivo di bit trasmessi dopo punteggiatura
    Zv = round(coded_raw * fraction_kept);

    % Rate effettivo
    rate_effettivo = K / Zv;

    % Bit aggiunti rispetto all'input originale
    bit_aggiunti = Zv - K;

    
end
