function[new_tmask,new_nmask]=tqdec(tmasks,nmasks,tq)
%this function performs the decimation of maskers that fall below the
%threshold of hearing
clear index;clear i;clear j;
new_tmask=tmasks;
new_nmask=nmasks;
k=0;
for i=1:1:size(tmasks,1)
    index = tmasks(i,1);
    if tmasks(i,2)<tq(index)
        new_tmask(i-k,:)=[];
        k=k+1;
    end
end
k=0;
for j=1:1:length(nmasks)
    index = nmasks(j,1);
    if nmasks(j,2)<tq(index)
        new_nmask(j-k,:)=[];
        k=k+1;
    end
end
