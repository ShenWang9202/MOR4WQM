function plotOutputError_r_all(OutputError_L1_inputPerspective_BT,OutputError_L1_inputPerspective_POD,OutputError_L1_inputPerspective_BPOD,delta_t,r_vector,tInMin)

fontsize = 35;

% Make sure nc = nu = 1;
figure1 = figure;
h1 = subplot(1,3,1);
[~,inputNumber] = size(OutputError_L1_inputPerspective_BT);
for i = 1:inputNumber
    data = OutputError_L1_inputPerspective_BT{1, i};
    [row,~] = size(data);
    semilogy(data,'LineWidth',2);
    title('BT','interpreter','latex');
%     xlim([0,row * delta_t])
    xticks(floor([ 2000  4000]./delta_t))
    xticklabels({'2000','4000'})
    yticks([1.0e-15 1.0e-10 1.0e-5])
    yticklabels({'$10^{-15}$','$10^{-10}$','$10^{-5}$'})
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
    %ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
    ylabel({'$L_1$ norm of ';' absolute error'},'FontSize',fontsize,'interpreter','latex')
end

h1 = subplot(1,3,2);
[~,inputNumber] = size(OutputError_L1_inputPerspective_POD);
for i = 1:inputNumber
    data = OutputError_L1_inputPerspective_POD{1, i};
    [row,~] = size(data);
    semilogy(data,'LineWidth',2);
    title('POD','interpreter','latex');
%     xlim([0,row * delta_t])
    xticks(floor([ 2000  4000]./delta_t))
    xticklabels({'2000','4000'})
%     xticks(floor([1000 2000 3000 4000]./delta_t))
%     xticklabels({'1000','2000','3000','4000'})
    yticks([1.0e-15 1.0e-10 1.0e-5])
    yticklabels({'$10^{-15}$','$10^{-10}$','$10^{-5}$'})
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
    [~,column] = size(r_vector);
    for j = 1:column
        lgndString{j} = ['$n_r=',int2str(r_vector(j)),'$'];
        %lgndString{j} = ['$',int2str(r_vector(j)),'$'];
    end
    lgnd = legend(lgndString,'Interpreter','Latex','Orientation','vertical');%'Location','NorthEast'
    %lgd = legend({'Three-node','Net1','Net3'},'Location','best','Interpreter','Latex');
    lgnd.FontSize = fontsize-1;
    lgnd.NumColumns = 1;
    set(lgnd,'box','off')
    set(lgnd,'Interpreter','Latex');
    xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
    %ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
end

h1 = subplot(1,3,3);
[~,inputNumber] = size(OutputError_L1_inputPerspective_BPOD);
for i = 1:inputNumber
    data = OutputError_L1_inputPerspective_BPOD{1, i};
    [row,~] = size(data);
    semilogy(data,'LineWidth',2);
    title('BPOD','interpreter','latex');
%     xlim([0,row * delta_t])
    xticks(floor([ 2000  4000]./delta_t))
    xticklabels({'2000','4000'})
    yticks([1.0e-15 1.0e-10 1.0e-5])
    yticklabels({'$10^{-15}$','$10^{-10}$','$10^{-5}$'})
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
end

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 4])
filename = ['L1norm_','Input_',int2str(i),'_tInMin_',int2str(tInMin)]
print(figure1,filename,'-depsc2','-r300');
print(figure1,filename,'-dpng','-r300');