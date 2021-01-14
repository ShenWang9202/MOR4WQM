function plotAccuracy4paper_Net31(XData,YData,dimension)
fontsize = 35;
% Make sure nc = nu = 1;
figure1 = figure;

%%
h1 = subplot(2,3,1);
Sensor1 = YData{1};
nx = dimension.full;
rBT = dimension.rBT;
rPOD = dimension.rPOD;
rBPOD = dimension.rBPOD;

plot(XData,Sensor1(:,1),'LineWidth',3);
hold on
plot(XData,Sensor1(:,2),'--','LineWidth',2);
hold on
plot(XData,Sensor1(:,3),'--','LineWidth',2);
hold on
title('J255','interpreter','latex')

xticks(floor([ 400  780]));
xticklabels({'400','800'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
ylabel({'Amplititude'},'FontSize',fontsize,'interpreter','latex')

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%%
h1 = subplot(2,3,2);
Sensor2 = YData{2};
plot(XData,Sensor2(:,1),'LineWidth',3);
hold on
plot(XData,Sensor2(:,2),'--','LineWidth',2);
hold on
plot(XData,Sensor2(:,3),'--','LineWidth',2);
hold on
title('J241','interpreter','latex')

xticks(floor([ 400  780]))
xticklabels({'400','800'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
%xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')

lgndString = {['Full, $n_x=',int2str(nx),'$'],...
    ['POD, $n_r=',int2str(rPOD),'$'],...
    ['BPOD, $n_r=',int2str(rBPOD),'$']};
lgd = legend(lgndString,'Location','NorthEast');%
lgd.FontSize = fontsize-12;
lgd.NumColumns = 1;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
 
%%
h1 = subplot(2,3,3);
Sensor3 = YData{3};
plot(XData,Sensor3(:,1),'LineWidth',3);
hold on
plot(XData,Sensor3(:,2),'--','LineWidth',2);
hold on
plot(XData,Sensor3(:,3),'--','LineWidth',2);
hold on
title('J249','interpreter','latex')

xticks(floor([ 400  780]))
xticklabels({'400','800'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%% 
h1 = subplot(2,3,4);
Sensor1 = YData{4};
nx = dimension.full;
rBT = dimension.rBT;
rPOD = dimension.rPOD;
rBPOD = dimension.rBPOD;

plot(XData,Sensor1(:,1),'LineWidth',3);
hold on
plot(XData,Sensor1(:,2),'--','LineWidth',2);
hold on
plot(XData,Sensor1(:,3),'--','LineWidth',2);
hold on
title('J255','interpreter','latex')

xticks(floor([ 400  780]));
xticklabels({'400','800'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
ylabel({'Amplititude'},'FontSize',fontsize,'interpreter','latex')

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%%
h1 = subplot(2,3,5);
Sensor2 = YData{5};
plot(XData,Sensor2(:,1),'LineWidth',3);
hold on
plot(XData,Sensor2(:,2),'--','LineWidth',2);
hold on
plot(XData,Sensor2(:,3),'--','LineWidth',2);
hold on
title('J241','interpreter','latex')

xticks(floor([ 400  780]))
xticklabels({'400','800'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')

lgndString = {['Full, $n_x=',int2str(nx),'$'],...
    ['POD, $n_r=',int2str(rPOD),'$'],...
    ['BPOD, $n_r=',int2str(rBPOD),'$']};
lgd = legend(lgndString,'Location','NorthEast');%
lgd.FontSize = fontsize-12;
lgd.NumColumns = 1;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
 
%%
h1 = subplot(2,3,6);
Sensor3 = YData{6};
plot(XData,Sensor3(:,1),'LineWidth',3);
hold on
plot(XData,Sensor3(:,2),'--','LineWidth',2);
hold on
plot(XData,Sensor3(:,3),'--','LineWidth',2);
hold on
title('J249','interpreter','latex')

xticks(floor([ 400  780]))
xticklabels({'400','800'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%%

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 10])
filename = 'Accuacy_Net3';
print(figure1,filename,'-depsc2','-r300');
print(figure1,filename,'-dpng','-r300');