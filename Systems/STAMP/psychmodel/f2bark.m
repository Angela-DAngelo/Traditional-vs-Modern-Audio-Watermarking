function[barks] = f2bark(fdata)
%converts freqeuncy to bark scale
barks = 13*atan(0.00076*fdata)+3.5*atan((fdata/7500).^2); 