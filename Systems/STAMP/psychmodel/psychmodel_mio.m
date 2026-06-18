function[gmask]=psychmodel_mio(fft_data)
%Accepts fft_data & performs steps 1-5 in the Painter &
%Spanias paper
%----STEP 1 Spectral Analysis and Normalization---
%----SPL Normalization----
spl=powspecd(fft_data);
%----STEP 2 Indetification of Tonal and Noise Maskers----
%----Find Local Maxima---
[peaks,flags]=localmax(spl);%returns the indices and marks tonal contributors
%----Calculate Tonal Maskers----
tonalmasks=tonalmsk(peaks,spl);
%----Calculate Noise Maskers----
noisemasks=noisemsk(flags);
%----STEP 3 Decimation and Reorganization of Maskers
%----Hearing Threshold Decimation
[dectonal,decnoise]=tqdec(tonalmasks,noisemasks);
%----Sliding 0.5 Bark Scale Window
[wintonal,winnoise]=barkslide(dectonal,decnoise);
%----Subsampling Decimation Scheme
[subtonal,subnoise]=subsample(wintonal,winnoise);
%----STEP 4 Calculation of Individual Masking Thresholds
%----Calculate Individual Tonal Masking Threshold
tmaskthres=tmaskspread(subtonal);
%----Calculate Individual Noise Masking Threshold
nmaskthres=nmaskspread(subnoise);
%----STEP 5 Calculation of Global Masking Thresholds
gmask=globalmsk(tmaskthres,nmaskthres);
gmask = gmask-90.302;
%plotter(spl,tonalmasks,noisemasks);
% pause;
%plotter(spl,dectonal,decnoise);
% pause;
%plotter(spl,wintonal,winnoise);
% pause;
%masktplotter(tmaskthres,subtonal);
% pause;
%masknplotter(nmaskthres,subnoise);
% pause;  
%maskgplotter(gmask,subtonal,subnoise);
% pause;  