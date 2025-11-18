function[out]=nmaskspread(noise,L,F)
%this function calculates the spreading function for the tonal maskers
clear k;
out=[];
allz=[];
spreadf=[];
vector=[];
dflag=0;
if isempty(noise)==1
    out=noise;
else
    for k=1:1:size(noise,1)%for every tmask
        binj=noise(k,1);
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
        if allz(r,c)~=0||r==noise(c,1)
        dflag=1;
        else
        dflag=0;
        end
        if dflag==1&&allz(r,c)>=-3&&allz(r,c)<-1
           
            sfnc=(17.*allz(r,c))-(0.4.*noise(c,2))+(11);
            tnm=(noise(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);
            
        elseif dflag==1&&allz(r,c)>=-1&&allz(r,c)<0
            
            sfnc=((0.4.*noise(c,2))+6).*allz(r,c);
            tnm=(noise(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);            
            
        elseif dflag==1&&allz(r,c)>=0&&allz(r,c)<1
            
            sfnc=-17.*allz(r,c);
            tnm=(noise(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);    
            
        elseif dflag==1&&allz(r,c)>=1&&allz(r,c)<8
            
            sfnc=(((0.15.*noise(c,2))-17).*allz(r,c))-0.15.*noise(c,2);
            tnm=(noise(c,2))-(0.275.*allz(r,c))+(sfnc)-(6.025);
            
        else
            tnm=-Inf;
        end
        vector=[vector;tnm];
        
     end
        out=cat(2,out,vector);
        vector=[];
end
end