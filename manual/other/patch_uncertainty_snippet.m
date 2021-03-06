% load variables 'conf','evalResults', 'sequences', and 'metropolisRejects'
% from the reset-mode optimization results:
load('./results/reset-so-results.mat','conf','evalResults',...
    'sequences','metropolisRejects')

% load the observations from file:
constants = load('./data/constants');

% define the percentiles:
prc = [2.5,50,97.5];

% define the number of model outputs to include in the construction of the 
% parameter uncertainty intervals:
nIntervals = 250;

% count the number of rows in 'evalResults':
nRows = size(evalResults,1);

% calculate the evaluation numbers of the parameter combinations whose 
% associated output are used in constructing the uncertainty intervals:
evalNumbers = nRows + (-nIntervals+1:1:0);

% use the 'mmsodaCalcUncertInts' function to retrieve the correct
% data and to calculate precentiles:
[x,y] = mmsodaCalcUncertInts(conf,evalResults,metropolisRejects,prc,evalNumbers);

% compose the x and y data for the patch object:
xp = [x(1,2:2*conf.nPrior),fliplr(x(1,2:2*conf.nPrior)),x(1,2)];
yp = [y(1,2:2*conf.nPrior),fliplr(y(3,2:2*conf.nPrior)),y(1,2)];

% make the figure:
mmsodaSubplotScreen(2,2,2)
clf
h1 = patch(xp,yp,'k');
hold on
h2 = plot(x,y(2,:),'-k');
h3 = plot(constants.obsTimes,constants.obs,'sm');
set(h1,'facecolor',0.5*[1,1,1],'edgecolor',0.5*[1,1,1])
set(h3,'markerfacecolor','none','markersize',8)
xlabel('Time')
ylabel('State')
box on
legend([h1,h2,h3],'95% parameter uncertainty interval','median','obs')
