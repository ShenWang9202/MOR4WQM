function plotOutputError_r_Net1(Method,OutputError_L1_inputPerspective,delta_t,r_vector,tInMin,Network)
[~,inputNumber] = size(OutputError_L1_inputPerspective);
fontsize = 35;
for i = 1:inputNumber
    figure1 = figure;
    data = OutputError_L1_inputPerspective{1, i};
    [row,~] = size(data);
    semilogy(data,'LineWidth',2);
%     xlim([0,row * delta_t])
    xticks(floor([1000 2000 3000 4000]./delta_t))
    xticklabels({'1000','2000','3000','4000'})
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
    lgnd.NumColumns = 3;
    set(lgnd,'box','off')
    set(lgnd,'Interpreter','Latex');
    
    xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
    %ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
    ylabel({'$L_1$ norm of ';' absolute error'},'FontSize',fontsize,'interpreter','latex')
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
    filename = ['L1norm_','Input_',int2str(i),'_',Method,'_tInMin_',int2str(tInMin),'_',Network]
    print(figure1,filename,'-depsc2','-r300');
    print(figure1,filename,'-dpng','-r300');
end

%ylim([200,900]);



%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
