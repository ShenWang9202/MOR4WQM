function plotNoezero4paper_Net1(XData,YData,dimension)
fontsize = 35;
% Make sure nc = nu = 1;
figure1 = figure;
h1 = subplot(2,1,1);
Sensor1 = YData{3};
nx = dimension.full;
rBPOD = dimension.rBPOD;

plot(XData,Sensor1(:,1),'LineWidth',3.5);
hold on
plot(XData,Sensor1(:,2),'--','LineWidth',2.5);
hold on
% title('J22','interpreter','latex')
xticks(floor([ 40000  79980]));
xticklabels({'40000','80000'})
% xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
set(gca, 'XTick', []);
%set(gca, 'YTick', []);
ylabel({'J22';'Amplitude'},'FontSize',fontsize,'interpreter','latex');
lgndString = {['Full, $n_x=',int2str(nx),'$'],...
    ['BPOD, $n_r=',int2str(rBPOD),'$']};
lgd = legend(lgndString,'Location','SouthEast');%
lgd.FontSize = fontsize;
lgd.NumColumns = 1;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);


% add rectangle


h2 = subplot(2,1,2);
Sensor2 = YData{4};
plot(XData,Sensor2(:,1),'LineWidth',3.5);
hold on
plot(XData,Sensor2(:,2),'--','LineWidth',2.5);
hold on
% title('J23','interpreter','latex')
xticks(floor([ 40000  79980]))
xticklabels({'40000','80000'})
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
ylabel({'J23';'Amplitude'},'FontSize',fontsize,'interpreter','latex');

% Ylabel = ylabel({'Amplititude'},'FontSize',fontsize,'interpreter','latex');
% Ylabel.Position(2) = 0.06;
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);


% Create textarrow
annotation(figure1,'textarrow',[0.276 0.290583333333333],...
    [0.849428868120457 0.896157840083074],'String',{'$t_2=16550$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.627604166666666 0.586979166666667] + 0.01,...
    [0.386332294911733 0.438213914849429],'String',{'$t_3 = 45360$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.390104166666666 0.420833333333333]+ 0.01,...
    [0.321682242990654 0.321682242990654],'String',{'$t_1 = 29600$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.389583333333333 0.4390625]+ 0.01,...
    [0.421679127725856 0.421599169262721]+0.02,'String',{'$t_2 = 31970$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

% Create textarrow
annotation(figure1,'textarrow',[0.322916666666667 0.275520833333333]+ 0.01,...
    [0.764818276220145 0.764818276220145],'String',{'$t_1=14000$'},...
    'Interpreter','latex',...
    'FontSize',fontsize-2);

h1Pos = get(h1,'Position');
h2Pos = get(h2,'Position');
h1Pos(1) = h1Pos(1) + 0.01;
h2Pos(1) = h2Pos(1) + 0.01;

h1Pos(2) = h1Pos(2) - 0.005;
h2Pos(2) = h2Pos(2) + 0.046;
h1Pos(4) = h1Pos(4) + 0.005;
h2Pos(4) = h2Pos(4) + 0.005;
set(h1,'Position',h1Pos)
set(h2,'Position',h2Pos)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
filename = 'Accuacy_Nonzeros_Net1';
print(figure1,filename,'-depsc2','-r300');
print(figure1,filename,'-dpng','-r300');