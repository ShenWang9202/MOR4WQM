figure
x = -5:0.1:5;
h1 = plot(x,cos(x-2),x,sin(x),x,-x-0.5,x,0.1.*x+0.1);
ax = gca;
area = [-2 -1 1 1];
panpos = ax.Position;
panpos(1) = panpos(1) + 0.39;
panpos(2) = panpos(2) + 0.39;
panpos(3) = panpos(3) - 0.39;
panpos(4) = panpos(4) - 0.39;
inlarge = zoomin(ax,area,panpos);

title(inlarge,'Zoom in')