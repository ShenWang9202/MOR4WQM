function plotOutputError_r_all_StepResponse(OutputError_L1_inputPerspective_BT,OutputError_L1_inputPerspective_POD,OutputError_L1_inputPerspective_BPOD,delta_t,r_vector,tInMin)

fontsize = 35;

% Make sure nc = nu = 1;
figure1 = figure;
h1 = subplot(1,3,1);
[~,inputNumber] = size(OutputError_L1_inputPerspective_BT);
for i = 1:inputNumber
    data = OutputError_L1_inputPerspective_BT{1, i};
    [row,~] = size(data);
    steps = 1:row;
    time = steps* delta_t;
    semilogy(time,data,'LineWidth',2.5);
    title('BT','interpreter','latex','fontsize',fontsize-6);
    

    ylim([1.0e-20 1.0e0])
    yticks([1.0e-20 1.0e-10 1.0e0])
    yticklabels({'$10^{-20}$','$10^{-10}$','$10^{0}$'})
    
    set(gca,'TickLabelInterpreter', 'latex','fontsize',fontsize);
    %ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
%     ylabel({'$L_1$ norm of ';' absolute error'},'FontSize',fontsize,'interpreter','latex')
    %ylabel({'$|\!\ AE |\!\$'},'FontSize',fontsize,'interpreter','latex')
    ylabel('$|\!|\mathrm{AE}|\!|_{L_1}$','FontSize',fontsize, 'interpreter', 'latex');
    %ylabel('$|\!|\textbf{\emph{y}}(\mathrm{t})|\!|_2$', 'interpreter', 'latex');
    
end

box(h1,'on');
% Set the remaining axes properties
set(h1,'LineWidth',1.5);

h2 = subplot(1,3,2);
[~,inputNumber] = size(OutputError_L1_inputPerspective_POD);
for i = 1:inputNumber
    data = OutputError_L1_inputPerspective_POD{1, i};
    [row,~] = size(data);
    steps = 1:row;
    time = steps* delta_t;
    semilogy(time,data,'LineWidth',2.5);
    title('POD','interpreter','latex','fontsize',fontsize-6);
%     ylim([1.0e-20 1.0e0])
% %     yticks([1.0e-20 1.0e-10 1.0e0])
%     yticklabels({})
    ylim([1.0e-20 1.0e0])
    yticks([1.0e-20 1.0e-10 1.0e0])
    yticklabels({'$10^{-20}$','$10^{-10}$','$10^{0}$'})
    
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
    
    xlh = xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex');
    xlh.HorizontalAlignment = 'right';
%    xlh.Position(2) = xlh.Position(2) + abs(xlh.Position(2) * 0.2)
%     xlabelPosition = get(get(gca,'XLabel'),'Position')
%     set(get(gca,'XLabel'),'Position',xlabelPosition + [0 -0.1 0])
    
    %ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
end
box(h2,'on');
% Set the remaining axes properties
set(h2,'LineWidth',1.5);

h3 = subplot(1,3,3);
[~,inputNumber] = size(OutputError_L1_inputPerspective_BPOD);
for i = 1:inputNumber
    data = OutputError_L1_inputPerspective_BPOD{1, i};
    [row,~] = size(data);
    steps = 1:row;
    time = steps* delta_t;
    semilogy(time,data,'LineWidth',2.5);
    title('BPOD','interpreter','latex','fontsize',fontsize-6);

%     ylim([1.0e-20 1.0e0])
%     %yticks([1.0e-20 1.0e-10 1.0e0])
%     yticklabels({})
    ylim([1.0e-20 1.0e0])
    yticks([1.0e-20 1.0e-10 1.0e0])
    yticklabels({'$10^{-20}$','$10^{-10}$','$10^{0}$'})
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
end
box(h3,'on');
% Set the remaining axes properties
set(h3,'LineWidth',1.5);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14.5 4])
filename = ['L1norm_','Input_',int2str(i),'_tInMin_',int2str(tInMin),'_StepResponse']
print(figure1,filename,'-depsc2','-r300');
print(figure1,filename,'-dpng','-r300');