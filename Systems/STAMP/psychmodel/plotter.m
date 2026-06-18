function[figout]=plotter(spl,tmasks,nmasks)
global F;
global tq;

bark=f2bark(F);
hold off;
figout=plot(bin2bark(1:256),spl(1:256));
axis([0 25 -20 90]);
hold on;
figout=plot(bin2bark(tmasks(:,1)),tmasks(:,2),'x');
figout=plot(bin2bark(nmasks(:,1)),nmasks(:,2),'o');
figout=plot(bark,tq,'--');