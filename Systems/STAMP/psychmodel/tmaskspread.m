function[out]=tmaskspread(tones,L,F)
%this function calculates the spreading function for the tonal maskers
clear k;
out=[];
allz=[];
spreadf=[];
vector=[];
dflag=0;
if isempty(tones)==1
    out=tones;
else
    for k=1:1:size(tones,1)%for every tmask
        binj=tones(k,1);
        zj=bin2bark(binj,F);
        start=binj-(binj-1);
        bini=start;
        zi=bin2bark(bini,F);
        deltaz=zi-zj;
        while bini<=106*floor(L/256)
            zi=bin2bark(bini,F);
            deltaz=zi-zj;
            bini=bini+1;
            if abs(deltaz)<=5
                spreadf=[spreadf;deltaz];
            else
                spreadf=[spreadf;0];                
            end
        end
        siz=length(spreadf);
        blank=[spreadf;zeros([L-siz,1])];
        allz=cat(2,allz,blank);
        spreadf=[];
    end
    
    for c=1:1:size(allz,2)%for every col
        
        for r=1:1:size(allz,1)%for every row
            if allz(r,c)~=0||r==tones(c,1)
                dflag=1;
            else
                dflag=0;
            end
            if dflag==1&&allz(r,c)>=-3&&allz(r,c)<-1
                
                sfnc=(17.*allz(r,c))-(0.4.*tones(c,2))+(11);
                ttm=(tones(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);
                
            elseif dflag==1&&allz(r,c)>=-1&&allz(r,c)<0
                
                sfnc=((0.4.*tones(c,2))+6).*allz(r,c);
                ttm=(tones(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);
                
            elseif dflag==1&&allz(r,c)>=0&&allz(r,c)<1
                
                sfnc=-17.*allz(r,c);
                ttm=(tones(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);
                
            elseif dflag==1&&allz(r,c)>=1&&allz(r,c)<8
                
                sfnc=(((0.15.*tones(c,2))-17).*allz(r,c))-0.15.*tones(c,2);
                ttm=(tones(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);
                
            else
                ttm=-Inf;
            end
            vector=[vector;ttm];
            
        end
        out=cat(2,out,vector);
        vector=[];
    end
end