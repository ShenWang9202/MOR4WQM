function plotAccuracy4paper_Net3(XData,YData,dimension)
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

plot(XData,Sensor1(:,1),'LineWidth',4);
hold on
plot(XData,Sensor1(:,2),'-.','LineWidth',3);
hold on
plot(XData,Sensor1(:,3),'--','LineWidth',2);
hold on
% plot(XData,Sensor1(:,4),'--','LineWidth',2);
% hold on

titlePos = title('J255','interpreter','latex');
titlePos.HorizontalAlignment = 'left';

xticks(floor([1500  3000]));
xticklabels({'1500','3000'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
ylabel('J237','FontSize',fontsize,'interpreter','latex')

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%%
h2 = subplot(2,3,2);
Sensor2 = YData{2};
plot(XData,Sensor2(:,1),'LineWidth',4);
hold on
plot(XData,Sensor2(:,2),'-.','LineWidth',3);
hold on
plot(XData,Sensor2(:,3),'--','LineWidth',2);
hold on
% plot(XData,Sensor2(:,4),'--','LineWidth',2);
% hold on

titlePos = title('J241','interpreter','latex');
titlePos.HorizontalAlignment = 'left';

% xlim([0 1500])
% xticks(floor([750  1500]));
% xticklabels({'750','1500'});

xlim([250 500])
xticks(floor([300  500]));
xticklabels({'300','500'});

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
%xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')


%%
h3 = subplot(2,3,3);
Sensor3 = YData{3};
plot(XData,Sensor3(:,1),'LineWidth',4);
hold on
plot(XData,Sensor3(:,2),'-.','LineWidth',3);
hold on
plot(XData,Sensor3(:,3),'--','LineWidth',2);
hold on
% plot(XData,Sensor3(:,4),'--','LineWidth',2);
% hold on
titlePos = title('J249','interpreter','latex');
titlePos.HorizontalAlignment = 'left';

% xlim([0 1500])
% xticks(floor([750  1500]));
% xticklabels({'750','1500'});

% xlim([0 1000])
% xticks(floor([500  1000]));
% xticklabels({'500','1000'});

xlim([250 500])
xticks(floor([300  500]));
xticklabels({'300','500'});

%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%% 
h4 = subplot(2,3,4);
Sensor1 = YData{4};
nx = dimension.full;
rBT = dimension.rBT;
rPOD = dimension.rPOD;
rBPOD = dimension.rBPOD;

plot(XData,Sensor1(:,1),'LineWidth',4);
hold on
plot(XData,Sensor1(:,2),'-.','LineWidth',3);
hold on
plot(XData,Sensor1(:,3),'--','LineWidth',2);
hold on
% plot(XData,Sensor1(:,4),'--','LineWidth',2);
% hold on

% xticks(floor([1500  3000]));
% xticklabels({'1500','3000'})

% xlim([0 1500])
% xticks(floor([750  1500]));
% xticklabels({'750','1500'});

xlim([400 800])
xticks(floor([400  800]));
xticklabels({'400','800'});


%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
ylabel('J247','FontSize',fontsize,'interpreter','latex')

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%%
h5 = subplot(2,3,5);
Sensor2 = YData{5};
plot(XData,Sensor2(:,1),'LineWidth',4);
hold on
plot(XData,Sensor2(:,2),'-.','LineWidth',3);
hold on
plot(XData,Sensor2(:,3),'--','LineWidth',2);
hold on
% plot(XData,Sensor2(:,4),'--','LineWidth',2);
% hold on

xticks(floor([1500  3000]));
xticklabels({'1500','3000'})

ylim([-1 2]*1e-4)

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
h6 = subplot(2,3,6);
Sensor3 = YData{6};
plot(XData,Sensor3(:,1),'LineWidth',4.5);
hold on
plot(XData,Sensor3(:,2),'-.','LineWidth',3);
hold on
plot(XData,Sensor3(:,3),'--','LineWidth',2);
hold on
% plot(XData,Sensor3(:,4),'--','LineWidth',2);
% hold on

xticks(floor([1500  3000]));
xticklabels({'1500','3000'});

ylim([-1 2]*1e-4)

%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

box(h6,'on')

%%
% common title;
sg = sgtitle('Sensors (outputs)','interpreter','latex');
sg.FontSize = fontsize;
% common ylabel
newAxes = axes(figure1,'visible','off');
newAxes.YLabel.Visible = 'on';
newYLabel = ylabel(newAxes,'Boosters (inputs)','fontsize',fontsize,'interpreter','latex');
% move ylabel to left a little bit
pos = newYLabel.Position;
pos(1) = pos(1) -0.05;
newYLabel.Position = pos;

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 10])
filename = 'Accuacy_Net3';
print(figure1,filename,'-depsc2','-r300');
print(figure1,filename,'-dpng','-r300');