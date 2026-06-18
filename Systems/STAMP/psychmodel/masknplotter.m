function[figout]=masknplotter(thres,mask)
%plotting function for spreading functions
global F;
global tq;
bark=f2bark(F);
hold off;
for i=1:1:size(thres,2)
    low=find(thres(:,i), 1, 'first');
    high=find(thres(:,i), 1, 'last');
    figout=plot(bin2bark(low:high),thres(low:high,i));
    axis([0 25 -20 90]);
    hold on;
end
figout=plot(bark,tq,'--');
figout=plot(bin2bark(mask(:,1)),mask(:,2),'o');
