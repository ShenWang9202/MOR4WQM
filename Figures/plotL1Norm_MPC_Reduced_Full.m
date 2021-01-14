function plotL1Norm_MPC_Reduced_Full(ControlAction,YY_reduced,Location_S,Location_B,Error)
    Error = abs(Error);
    L1norm = sum(Error,2);
    fontsize = 40;
    
    ControlAction = ControlAction(1:1440,:);
    YY_reduced = YY_reduced(1:1440,:);
    L1norm = L1norm(1:1440,:);

    figure1 = figure;
    subplot(1,3,1)
    plot(ControlAction,'LineWidth',3)
    %title('Control Action','interpreter','latex')
    xticks(floor([12 24].*60))
    xticklabels({'12','24'})
    
    %xlabel('Time (hour)','FontSize',fontsize,'interpreter','latex');
    ylabel({'Injected mass'; 'rate (mg/min)'},'FontSize',fontsize,'interpreter','latex');
    lgnd = legend(Location_B,'Interpreter','Latex','Orientation','vertical','Location','SouthEast');
    lgnd.FontSize = fontsize;
    lgnd.NumColumns = 1;
    set(lgnd,'box','off');
    set(lgnd,'Interpreter','Latex');
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
    
    subplot(1,3,2)
    plot(YY_reduced,'LineWidth',3)
    %title('Control Action','interpreter','latex')
    xticks(floor([12 24].*60))
    xticklabels({'12','24'})
    
    ylim([0 1.5])
    yticks([0 0.5 1.5])
    yticklabels({'0','0.5','1.5'})
    
    xlabel('Time (hour)','FontSize',fontsize,'interpreter','latex');
    ylabel({'Concentration';'(mg/L)'},'FontSize',fontsize,'interpreter','latex');
    lgnd = legend(Location_S,'Interpreter','Latex','Orientation','vertical','Location','SouthEast');
    lgnd.FontSize = fontsize;
    lgnd.NumColumns = 1;
    set(lgnd,'box','off');
    set(lgnd,'Interpreter','Latex');
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
    
    subplot(1,3,3)
    plot(L1norm,'LineWidth',3)
    %title('Control Action','interpreter','latex')
    xticks(floor([12 24].*60))
    xticklabels({'12','24'})
    
    %xlabel('Time (hour)','FontSize',fontsize,'interpreter','latex');
    ylabel({'$L_1$ norm of ';' absolute error'},'FontSize',fontsize,'interpreter','latex')
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);

    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 6])
    filename =  'MPC_BPOD';
    print(figure1,filename,'-depsc2','-r300');
    print(figure1,filename,'-dpng','-r300');
end