
% reads the earthquake data and stores the information in a MATLAB table data structure
opts = detectImportOptions('database.csv');
% makes the headers of the csv table the variable names
varNames = opts.VariableNames;

% assigns the type of variables to the things in the table so it can be easily used later
varTypes = {'datetime','datetime','double','double','categorical',...
    'double','double','double','double','categorical','double','double',...
    'double','double','double','double','categorical','categorical',...
    'categorical','categorical','categorical'};
opts = setvartype(opts,varNames,varTypes);

% creates a table using the import options opts
R = readtable('database.csv',opts);

% replaces the NaN, or empty values w/ 0, using the isnumeric function
T = fillmissing(R,'constant',0,'DataVariables',@isnumeric);

% begin creation of yearly earthquake plot
% computes the # of times a year is mentioned and makes a table w/ that data
groupsofyears = groupcounts(T.Date.Year);
listofyears = 1965:1:2016;
% turns the 1 x 52 array into a one column 52 x 1 array
newlistofyears = reshape(listofyears,[],1);
% combines the now equally sized arrays into a table
% created table to allow for key indexing in the GUI
yearvalpairs = table(newlistofyears,groupsofyears);

% assigns locations- latitude and longitudes- w/ table indexing
Lat = T.Latitude(1:23412);
Lon = T.Longitude(1:23412);
Mag = T.Magnitude(1:23412);

% creates GUI figure
figure1 = figure('WindowState','maximized');
% creates geobubble plot w/ standardized units that will accomodate to screen size
geobubble(figure1,[],[],'Units','normalized'...
    ,'InnerPosition',[0.0430208333333332 0.136752136752137 0.621041666666667 0.813888888888888],...
    'Title',"One Punch Man's Global Destruction",...
    'Basemap','grayterrain','SizeLegendTitle',{'Magnitude'});
% defines the geobubble plot axis limits to look the same as the given example
geolimits([-80 80],[-170 170]);

% defines axes for the line plot
axes1 = axes('Parent',figure1);

% creates line plot
plot(listofyears,groupsofyears,'LineWidth',2,'Color','bl');
% turns the background of line plot a black color
set(gca,'color','k');
ylabel('Number of Earthquakes');
xlabel('Years');
title('Historical Earthquake Trends');

% puts a box around the plot
box(axes1,'on');
% puts a grid on the plot
grid (axes1, 'on');
% changes the limits and tick marks to match the given example
axes1.XLim = [1965 2016];
axes1.XTick = 1965:5:2016;
% sets the position of the axes1
set(axes1,'Units','normalized','OuterPosition',[0.66 0.25 0.361290322580645 0.36041755861027]);

% creates a textbox for the user to input their chosen year
yearinput = uicontrol(figure1,'Style','edit','Units','normalized','position',[0.82 0.866 0.075 0.035]);
yearinputlabel = uicontrol(figure1,'Style','text','String','Enter Year','Units','normalized','position',[0.82 0.90 0.075 0.035]);
% button to push to plot, calls function below whenever pushed
mybutton = uicontrol(figure1,'Style','pushbutton','String','Plot','Units','normalized','position',[0.9 0.866 0.045 0.035],'callback',{@plotfigure,yearinput,groupsofyears,figure1,axes1,T,Lat,Lon,Mag,listofyears});

% function allows for the plot of earthquake occurrences over time to updated
function plotfigure(~,~,yearinput,groupsofyears,figure1,axes1,T,Lat,Lon,Mag,listofyears)
% return an array with the handles of geobubble in the current figure
myhandle = findobj(gcf,'Type','geobubble');
% deletes the geobubble
delete(myhandle);

% gets and reformats the button input
YearIsHere = str2double(get(yearinput,'string'));

% indexes with the input value
rowindex = listofyears == YearIsHere;
% replots and labels the line graph
plot(listofyears,groupsofyears,'LineWidth',2,'Color','bl');
ylabel('Number of Earthquakes');
xlabel('Years');
title('Historical Earthquake Trends');
box(axes1,'on');
grid (axes1, 'on');
axes1.XLim = [1965 2016];
axes1.XTick = 1965:5:2016;

% sets the axes properties again
set(axes1,'OuterPosition',[0.66 0.25 0.361290322580645 0.36041755861027]);

% hold allows for marker to be plot over the line without it being erased
hold(axes1,'on');
plot(YearIsHere,groupsofyears(rowindex),'Marker','o','MarkerFaceColor','y','LineWidth',2);
set(gca,'color','k');
hold(axes1,'off');

% empty array for the values that match with the given year
yes = [];
for j = 1:length(T.Date)
     if (year(T.Date(j)) == YearIsHere)
         yes = [yes; j];
     end
end
% plots all earthquake occurrences in the given year including their location and magnitude
geobubble(figure1,Lat(yes),Lon(yes),Mag(yes),...
    'InnerPosition',[0.0430208333333332 0.136752136752137 0.621041666666667 0.813888888888888],'Title',...
    "One Punch Man's Global Destruction",'Basemap','grayterrain','SizeLegendTitle',...
    {'Magnitude'},'MapCenter',[0 0],'SizeLimits',[5.5,9.1],'BubbleColorList','r');
geolimits([-80 80],[-170 170]);
end



