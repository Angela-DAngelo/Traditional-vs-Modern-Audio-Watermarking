function[lvls,bits]=stepsize(gmask,mdct,fft_data)
%function returns the number of lvls and number of bits
%perform FFT based mask to MDCT based mask conversion
mask=(mdct.^2.*gmask)./(abs(fft_data(1:256))).^2;
%convert back to linear scale
convert=sqrt(10.^((mask-90.302)./10));
%Find step size
ti=sqrt(12.*convert); %q^2/12 = errore di quantizzazione?
Nr=abs(round(mdct./ti));
lvls=(2.*Nr+1);
bits=sum(ceil(log2(lvls)));

