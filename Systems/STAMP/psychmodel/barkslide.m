function[wintones,winnoise]=barkslide(tones,noise,F)
%this function combines maskers falling within a 1/2 bark window using the
%stronger of the two
wintones=tones;
winnoise=noise;
i=1;
if size(tones,1)<2%there is not two tones,return tmasks
    wintones=tones;
else%go through and check to see if within 0.5 bark
    while(i<size(wintones,1))
        if bin2bark(tones(i+1,1),F)-bin2bark(tones(i,1),F)<=0.5
            
            if wintones(i,2)>wintones(i+1,2)
                wintones(i+1,:)=[];
            else
                wintones(i,:)=[];
            end
        end
        i=i+1;
        
    end
end

i=1;
while(i<size(winnoise,1))
    if bin2bark(noise(i+1,1),F)-bin2bark(noise(i,1),F)<=0.5
        
        if winnoise(i,2)>winnoise(i+1,2)
            winnoise(i+1,:)=[];
        else
            winnoise(i,:)=[];
        end
    end
    i=i+1;
    
end