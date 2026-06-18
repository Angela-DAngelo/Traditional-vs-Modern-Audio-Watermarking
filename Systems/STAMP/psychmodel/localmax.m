function[lmax,tonal_flag]=localmax(spl)
%this function finds the local maxima used to calculate tonal maskers
lmax=[];
tonal_flag = spl;
tonal_flag = cat(2,tonal_flag,zeros([length(tonal_flag),1]));
N = length(spl);
Freq_soglie = floor([63 127 256]*((N/2)/256));
for k = 2:1:N/2
    if k==2 && spl(k) > spl(k-1) && spl(k) > spl(k+1) && spl(k) > spl(k+2)+7
        lmax = cat(1,lmax,k);
        tonal_flag(k-1:k+2,2) = 1;
    elseif k > 2 && k < Freq_soglie(1) && spl(k) > spl(k+1) && spl(k) > spl(k-1) && spl(k) > max([spl(k+2)+7 spl(k-2)+7]);
        lmax = cat(1,lmax,k);
        tonal_flag(k-2:k+2,2) = 1;
    elseif k >= Freq_soglie(1) && k < Freq_soglie(2) && spl(k) > max([spl(k+1) spl(k-1) spl(k+[2 3]).'+7 spl(k-[2 3]).'+7]);
        lmax = cat(1,lmax,k);
        tonal_flag(k-3:k+3,2) = 1;
    elseif k > Freq_soglie(2) && k <= Freq_soglie(3) && spl(k) > max([spl(k+1) spl(k-1) spl(k+[2:6]).'+7 spl(k-[2:6]).'+7]);
        lmax = cat(1,lmax,k);
        tonal_flag(k-6:k+6,2) = 1;
    end
end