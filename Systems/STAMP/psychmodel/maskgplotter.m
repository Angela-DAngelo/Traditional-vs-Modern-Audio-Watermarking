function[figout]=maskgplotter(gmask,tmask,nmask)
%plotting function for spreading functions
global F;
global tq;
bark=f2bark(F);
hold off;
figout=plot(bark,gmask);
axis([0 25 -20 90]);
xlabel('Barks (z)');
ylabel('SPL (dB)');
hold on;
figout=plot(bark,tq,'--');
figout=plot(bin2bark(tmask(:,1)),tmask(:,2),'x');
figout=plot(bin2bark(nmask(:,1)),nmask(:,2),'o');