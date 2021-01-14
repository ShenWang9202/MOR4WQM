function r = ObtainModeR(fullModeNum,goal,HankelSigularValue)
n = fullModeNum;
a = 1;
b = n;
r = 0;
while(abs(a-b)>1)
    r = floor((a+b)/2);
    energy = sum(HankelSigularValue(1:r))/sum(HankelSigularValue);
    if(energy > goal)
        b = r;
    else
        a = r;
    end
end
%% plot
% fig1 = figure;
% subplot(1,2,1)
% semilogy(HankelSigularValue,'k','LineWidth',2)
% hold on, grid on
% semilogy(r,HankelSigularValue(r),'ro','LineWidth',2)
% ylim([10^(-15) 100])
% subplot(1,2,2)
% plot(0:length(HankelSigularValue),[0; cumsum(HankelSigularValue)/sum(HankelSigularValue)],'k','LineWidth',2)
% hold on, grid on
% plot(r,sum(HankelSigularValue(1:r))/sum(HankelSigularValue),'ro','LineWidth',2)
% set(gcf,'Position',[1 1 550 200])
% set(gcf,'PaperPositionMode','auto')
% print(fig1,'energy','-dpng','-r300');