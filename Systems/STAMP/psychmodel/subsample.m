function[subtones,subnoise]=subsample(tones,noise,SCALA)
%this function decimates the masker bins according to the scheme in step 3
%down to 106 bins
subtones=[];
subnoise=[];
counter=1;
if isempty(tones)==1
    subtones=tones;
else
    for k=1:1:size(tones,1)
        if tones(k,1)>=1 && tones(k,1) <= 48*SCALA
            subtones(k,:)=tones(k,:);
        elseif tones(k,1)>=48*SCALA+1 && tones(k,1) <= 96*SCALA
            subtones(k,:)=[tones(k,1)+mod(tones(k,1),2) tones(k,2)];
        elseif tones(k,1)>=96*SCALA+1 && tones(k,1) <= 232*SCALA
            subtones(k,:)=[(tones(k,1)+3)-mod(tones(k,1)-1,2) tones(k,2)];
        end
    end
end
if isempty(noise)==1
    subnoise=noise;
else
    for k=1:1:size(noise,1)
        if noise(k,1)>= 1 && noise(k,1) <= 48*SCALA
            subnoise(k,:) = noise(k,:);
        elseif noise(k,1)>= 48*SCALA+1 && noise(k,1)<=96*SCALA
            subnoise(k,:)= [noise(k,1)+mod(noise(k,1),2) noise(k,2)];
        elseif noise(k,1)>= 96*SCALA+1 && noise(k,1) <= 232*SCALA
            subnoise(k,:)=[(noise(k,1)+3)-mod(noise(k,1)-1,2) noise(k,2)];
        end
    end
end