function plotStablization(Ydata,delta_t)
Yfull = Ydata.Yfull;
YBPOD_unstable = Ydata.YBPOD_unstable;
YBPOD_postStabilized = Ydata.YBPOD_postStabilized;
YBPOD_prioriStabilized = Ydata.YBPOD_prioriStabilized;

unstableData = [];
unstableData = [unstableData Yfull(:,1)];
unstableData = [unstableData YBPOD_unstable(:,1)];

poststableData = [];
poststableData = [poststableData Yfull(:,1)];
poststableData = [poststableData YBPOD_postStabilized(:,1)];

prioristableData = [];
prioristableData = [prioristableData Yfull(:,1)];
prioristableData = [prioristableData YBPOD_prioriStabilized(:,1)];


[row,~] = size(Yfull);

Xdata = 1:row;
Xdata = floor(Xdata*delta_t);

fontsize = 35;

figure1 = figure;
%% 
h1 = subplot(2,3,1);
data = unstableData;

plot(Xdata,data(:,1),'LineWidth',3);
hold on
plot(Xdata,data(:,2),'-.','LineWidth',2);
hold on

titlePos = title('Unstable','interpreter','latex');
titlePos.HorizontalAlignment = 'left';
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
set(gca, 'XTickLabel',[]);
set(gca, 'YGrid', 'off','XGrid','on');
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
ylabel({'J22';'Amplitude'},'FontSize',fontsize,'interpreter','latex')

%%
h1 = subplot(2,3,2);

data = poststableData;

plot(Xdata,data(:,1),'LineWidth',3);
hold on
plot(Xdata,data(:,2),'-.','LineWidth',2);
hold on
titlePos = title('Posterior','interpreter','latex');
titlePos.HorizontalAlignment = 'left';

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

set(gca, 'XTickLabel',[]);

lgndString = {'Full','BPOD'};
lgnd = legend(lgndString,'Interpreter','Latex','Orientation','vertical');%'Location','NorthEast'
%lgd = legend({'Three-node','Net1','Net3'},'Location','best','Interpreter','Latex');
lgnd.FontSize = fontsize-1;
lgnd.NumColumns = 1;
set(lgnd,'box','off')
set(lgnd,'Interpreter','Latex');

%%
h1 = subplot(2,3,3);

data = prioristableData;
plot(Xdata,data(:,1),'LineWidth',3);
hold on
plot(Xdata,data(:,2),'-.','LineWidth',2);
hold on
titlePos = title('Priori','interpreter','latex');
titlePos.HorizontalAlignment = 'left';
set(gca, 'XTickLabel',[]);
set(gca, 'YGrid', 'off','XGrid','on');
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

%% Input 2
unstableData = [];
unstableData = [unstableData Yfull(:,2)];
unstableData = [unstableData YBPOD_unstable(:,2)];

poststableData = [];
poststableData = [poststableData Yfull(:,2)];
poststableData = [poststableData YBPOD_postStabilized(:,2)];

prioristableData = [];
prioristableData = [prioristableData Yfull(:,2)];
prioristableData = [prioristableData YBPOD_prioriStabilized(:,2)];

%%
h4 = subplot(2,3,4);
data = unstableData;
plot(Xdata,data(:,1),'LineWidth',3);
hold on
plot(Xdata,data(:,2),'-.','LineWidth',2);
hold on


xticks(floor([ 40000  79980]))
xticklabels({'40000','80000'})

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
set(gca, 'YGrid', 'off','XGrid','on');
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
ylabel({'J23';'Amplitude'},'FontSize',fontsize,'interpreter','latex')

% magnified area

ax = gca;
x1 = 60000;
x2 = 79980;
y1 = -0.004
y2 = 0.004
area = [x1 y1 x2 y2];
panpos = h4.Position;
panpos(1) = panpos(1) + 0.11;
panpos(2) = panpos(2) + 0.15;
panpos(3) = 0.1;
panpos(4) = 0.28;
% inlarge = zoomin(ax,area,panpos);


h5 = subplot(2,3,5);

data = poststableData;
 
plot(Xdata,data(:,1),'LineWidth',3);
hold on
plot(Xdata,data(:,2),'-.','LineWidth',2);
hold on

xticks(floor([ 40000  79980]))
xticklabels({'40000','80000'})

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
set(gca, 'YGrid', 'off','XGrid','on');
xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')

% magnified area

ax = gca;
area = [x1 y1 x2 y2];
panpos = h5.Position;
panpos(1) = panpos(1) + 0.11;
panpos(2) = panpos(2) + 0.15;
panpos(3) = 0.1;
panpos(4) = 0.28;

inlarge = zoomin(ax,area,panpos);


h6 = subplot(2,3,6);
data = prioristableData;
plot(Xdata,data(:,1),'LineWidth',3);
hold on
plot(Xdata,data(:,2),'-.','LineWidth',2);
hold on

xticks(floor([ 40000  79980]))
xticklabels({'40000','80000'})

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
set(gca, 'YGrid', 'off','XGrid','on');

% magnified area

ax = gca;
area = [x1 y1 x2 y2];
panpos = h6.Position;
panpos(1) = panpos(1) + 0.11;
panpos(2) = panpos(2) + 0.15;
panpos(3) = 0.1;
panpos(4) = 0.28;
inlarge = zoomin(ax,area,panpos);


set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 10])
filename = ['stablization_m2350'];

print(figure1,filename,'-depsc2','-r300');
print(figure1,filename,'-dpng','-r300');