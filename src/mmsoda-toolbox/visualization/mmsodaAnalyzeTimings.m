function mmsodaAnalyzeTimings(varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaAnalyzeTimings.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

disp('Started reading the timings files...')

showLegend = true;
bottomLayerHeight = 0.6;
topLayerHeight = 0.2;
bgColor = [0.12,0.18,0.24];
showHost = true;
showPID = true;
showRank = true;

startFrom = false;
endAt = false;

leftMargin = 0.17;

authorizedOptions = {'bgColor',...
    'bottomLayerHeight',...
    'endAt',...
    'leftMargin',...
    'showHost',...
    'showLegend',...
    'showPID',...
    'showRank',...
    'startFrom',...
    'topLayerHeight'};


mmsodaParsePairs()

olive = [0.00, 0.50, 0.00];
lime = [0.67, 1.00, 0.00];
magenta = [0.75, 0.04, 0.38];
blue = [0.12, 0.15, 0.79];
lightgray = [0.71,0.71,0.71];
cyan = [ 0.27, 0.80, 0.84];


events = { 1, 2,'receivevar\n(receivevar.c)',    bottomLayerHeight/2,{'FaceColor',olive,'EdgeColor',olive};... 
           3, 4,'sendvar\n(sendvar.c)',          bottomLayerHeight/2,{'FaceColor',magenta,'EdgeColor',magenta};...
          31,32,'SerializeVar\n(sendvar.c)',     topLayerHeight/2,{'FaceColor',blue,'EdgeColor',blue};...
          33,34,'MPI_Send\n(sendvar.c)',         topLayerHeight/2,{'FaceColor',lightgray,'EdgeColor',lightgray};...
          35,36,'MPI_Recv\n(receivevar.c)',      topLayerHeight/2,{'FaceColor',lime,'EdgeColor',lime};...
          37,38,'DeserializeVar\n(receivevar.c)',topLayerHeight/2,{'FaceColor',cyan,'EdgeColor',cyan}};  


timingsDirectory = 'results';

if showLegend
    
    h2 = axes('Position',[leftMargin,0.81,0.96-leftMargin,0.17],'Color','none');
    axis off
    
    h1 = axes('Position',[leftMargin,0.05,0.96-leftMargin,0.75],'Color',bgColor);
    
else
    
    h1 = axes('Position',[leftMargin,0.05,0.96-leftMargin,0.93],'Color',bgColor);
    
end


d = dir(timingsDirectory);
nItems = numel(d);
nEvents = size(events,1);

eventOccurred = repmat(false,[nEvents,1]);

mpiRankMax = -Inf;
mpiRankMin = +Inf;

IdontSeeTheTimingFiles = true;

yTickLabels = {};

for iItem = 1:nItems
    
    fname = d(iItem).name;
    if isTimingFile(fname)

        IdontSeeTheTimingFiles = false;
        
        load(fullfile(timingsDirectory,fname),'timing');
        
        mpiRankMin = min([mpiRankMin,timing.mpirank]);
        mpiRankMax = max([mpiRankMax,timing.mpirank]);
        
        nCodes = numel(timing.code);
        for iEvent = 1:nEvents
            codeInit = events{iEvent,1};
            codeTerm = events{iEvent,2};
            
            for indexFrom = find(timing.code==codeInit)
                
                    for indexTo = indexFrom+1:nCodes
                        if timing.code(indexTo) == codeTerm
                            eventOccurred(iEvent) = true;
                            break
                        end
                    end
                    
                    xStart = timing.timer(indexFrom);
                    xEnd = timing.timer(indexTo);
                    
                    halfBandHeight = events{iEvent,4};
                    eventStyle = events(iEvent,5);
                    drawRectangle(xStart,...
                                  xEnd,...
                                  timing.mpirank-halfBandHeight,...
                                  timing.mpirank+halfBandHeight,...
                                  eventStyle)
            end
        end
        
        str = '';        
        if showRank
            str = [str,'RANK=',num2str(timing.mpirank)];
        end
        if showHost
            str = [str,' HOST=',timing.host];
        end
        if showPID
            str = [str,' PID=',timing.pid];
        end
        if ~any(eventOccurred)
            str = [str,' no events']
        end
        yTickLabels{end+1} = str;

    end
    
end

if IdontSeeTheTimingFiles
    error('I don''t see any timing files.')
end


xlims = get(gca,'xlim');
if startFrom
    xlims(1) = startFrom;
end
if endAt
    xlims(2) = endAt;
end
set(gca,'xlim',xlims,...
        'ylim',[mpiRankMin-0.5,mpiRankMax+0.5],...
        'ytick',[mpiRankMin:1:mpiRankMax],...
        'yticklabel',yTickLabels)

for iEvent=1:nEvents
    if ~eventOccurred(iEvent)
        disp(['I did not see any events of type ''',events{iEvent,3},'''.'])
    end
    
end
xlabel('time since reference [s]')

if showLegend
    drawLegend(h2,events,eventOccurred)
end




function IO = isTimingFile(fname)

IO = numel(fname)==14 && strcmp(fname([1:7,11:14]),'timing_.mat');




function drawRectangle(xStart,xEnd,yStart,yEnd,patchProps)



xp = [xStart,xEnd,xEnd,xStart,xStart];
yp = [yEnd,yEnd,yStart,yStart,yEnd];

h=patch(xp,yp,'k');
set(h,patchProps{1}{:});



function drawLegend(h,events,eventOccurred)

axes(h)
hold on
nEvents = size(events,1);
nCols = 3;

set(gca,'xlim',[0,nCols+1],'ydir','reverse')

M = [1,2,1;...
     2,1,1;...
     3,1,2;...
     4,1,3,;...
     5,2,2,;...
     6,2,3];

for iEvent = 1:nEvents

    iRow = M(iEvent,2);
    iCol = M(iEvent,3);

    if eventOccurred(iEvent)
        drawRectangle(iCol-0.45,iCol+0.45,iRow-0.45,iRow+0.45,events(iEvent,5))
        text(iCol,iRow,sprintf(events{iEvent,3}),'Interpreter','none',...
                                         'horizontalalignment','center',...
                                         'verticalalignment','middle')
    end
    
end

hold off



disp('Started reading the timings files...Done')


