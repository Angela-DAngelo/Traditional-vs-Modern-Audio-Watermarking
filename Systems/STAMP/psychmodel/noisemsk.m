function[noisemasks]=noisemsk(flags)
%this function calculates the noise maskers
clear band;
clear bin;
clear compute;
clear g_mean;
clear i; clear j;
clear means; clear nm; clear product;
CB=floor([1,2,3,5,6,8,10,12,14,16,18,21,24,28,32,38,44,52,63,76,91,112,141,182,256]'*(size(flags,1)/512));
means=floor([1,2,4,5,7,9,11,13,15,17,19,22,16,30,35,41,48,57,69,83,101,126,161,218]*(size(flags,1)/512));

product=1;
%means=[];
compute = 0;
nm=[];
% for i = 2:length(CB)
%     for j=CB(i-1):CB(i)
%     product=product.*j;
%     end
%     g_mean=round(product.^(1./((CB(i)+1)-(CB(i-1)))));
%     means=cat(1,means,g_mean);
%     product=1;
% end
for band=1:1:24
    for bin=CB(band):CB(band+1)
        if flags(bin,2)==0
            compute = compute + 10.^(0.1.*flags(bin,1));
        end
    end
    if compute~=0
        nm = cat(1,nm,[means(band) 10.*log10(compute)]);
    end
    compute=0;
end
noisemasks=nm;