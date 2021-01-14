function plotAccuracy4paper_Net1(XData,YData,dimension)
fontsize = 35;
% Make sure nc = nu = 1;
figure1 = figure;
h1 = subplot(2,1,1);
Sensor1 = YData{1};
nx = dimension.full;
rBT = dimension.rBT;
rPOD = dimension.rPOD;
rBPOD = dimension.rBPOD;

plot(XData,Sensor1(:,1),'LineWidth',3.5);
hold on
plot(XData,Sensor1(:,2),'--','LineWidth',2.5);
hold on
plot(XData,Sensor1(:,3),'--','LineWidth',2.5);
hold on
plot(XData,Sensor1(:,4),'--','LineWidth',2.5);
hold on
%title('J22','interpreter','latex')
xticks(floor([ 40000  79980]));
xticklabels({'40000','80000'})
% xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
set(gca, 'XTick', []);
%set(gca, 'YTick', []);
% ylabel({'Amplitude'},'FontSize',fontsize,'interpreter','latex')
ylabel({'J22';'Amplitude'},'FontSize',fontsize,'interpreter','latex');

lgndString = {['Full, $n_x=',int2str(nx),'$'],...
    ['BT, $n_r=',int2str(rBT),'$'],...
    ['POD, $n_r=',int2str(rPOD),'$'],...
    ['BPOD, $n_r=',int2str(rBPOD),'$']};
lgd = legend(lgndString,'Location','NorthEast');%
lgd.FontSize = fontsize-2;
lgd.NumColumns = 2;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

pos = lgd.Position
pos(1) = pos(1) + 0.39;
pos(2) = pos(2) - 0.09;

lgd.Position= pos;

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);


% add rectangle


h2 = subplot(2,1,2);
Sensor2 = YData{2};
plot(XData,Sensor2(:,1),'LineWidth',3.5);
hold on
plot(XData,Sensor2(:,2),'--','LineWidth',2.5);
hold on
plot(XData,Sensor2(:,3),'--','LineWidth',2.5);
hold on
plot(XData,Sensor2(:,4),'--','LineWidth',2.5);
hold on
%title('J23','interpreter','latex')
xticks(floor([40000  79980]))
xticklabels({'40000','80000'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
ylabel({'J23';'Amplitude'},'FontSize',fontsize,'interpreter','latex');

% Ylabel = ylabel({'Amplitude'},'FontSize',fontsize,'interpreter','latex');
% Ylabel.Position(2) = 15e-8;
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);


% Create textarrow
annotation(figure1,'textarrow',[0.321604166666666 0.278645833333333],...
    [0.850700934579439 0.874350986500519]+0.04,'String',{'$t_1=14000$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.322083333333332 0.303645833333333],...
    [0.793278296988576 0.793278296988576]+0.03,'String',{'$t_2=16550$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.381770833333333 0.4125],...
    [0.370716510903427 0.370716510903427]+0.05,'String',{'$t_1 = 29600$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.478125 0.444270833333333],...
    [0.361409138110072 0.394330218068536]+0.08,'String',{'$t_2 = 31970$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.621875 0.570833333333333],...
    [0.255067497403946 0.255067497403946]+0.035,'String',{'$t_3 = 45360$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

h1Pos = get(h1,'Position');
h2Pos = get(h2,'Position');
h1Pos(2) = h1Pos(2) - 0.005;
h2Pos(2) = h2Pos(2) + 0.046;
h1Pos(4)
h1Pos(4) = h1Pos(4) + 0.005;
h2Pos(4) = h2Pos(4) + 0.005;
set(h1,'Position',h1Pos)
set(h2,'Position',h2Pos)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
filename = 'Accuacy_Net1';
print(figure1,filename,'-depsc2','-r300');
print(figure1,filename,'-dpng','-r300');