function [powerspec] = powspecd(data)
%this function calculates the PSD of a frame of data w/ power normalization
%term of 90.302
pn = 90.302;
powerspec = pn + 10.*log10(abs(data).^2);  

