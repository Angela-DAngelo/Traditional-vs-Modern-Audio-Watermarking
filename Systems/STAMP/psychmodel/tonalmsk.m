function[tonal]=tonalmsk(lmax,spl)
%this function calculates the tonal masks
tonal=[];
adj=0;
for k=1:length(lmax)
    for j=-1:1
        adj=adj+10.^(0.1.*spl(j+lmax(k)));
    end
    tmask=10.*log10(adj);
    adj=0;
    tonal=cat(1,tonal,tmask);
end
tonal=cat(2,lmax,tonal);

    
