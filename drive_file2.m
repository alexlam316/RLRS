function driver_file2()

% verify that the RWTH - Mindstorms NXT toolbox is installed.
if verLessThan('RWTHMindstormsNXT', '4.01');
    error(strcat('This program requires the RWTH - Mindstorms NXT Toolbox ' ...
    ,'version 4.01 or greater. Go to http://www.mindstorms.rwth-aachen.de ' ...
    ,'and follow the installation instructions!'));
end%if

COM_CloseNXT all
close all
clear all
clc

handle = COM_OpenNXT(); %open usb port
COM_SetDefaultNXT(handle); % set default handle

localize_ON = 0; %set value to 1 to enable particle filter, 0 to disable
path_mode = 3; % set value to 1 for choosing A-star algorithm, set value to 2 for choosing Dijkstra algorithm 

map=[0,0;66,0;66,44;44,44;44,66;110,66;110,110;0,110];  %default map

botSim = BotSim(map,[0,0,0]);  %sets up a botSim object a map, and debug mode on.
start_position = [44 22];
start_angle = -45; % in degree
target = [88 88];

botSim.setBotPos(start_position);
botSim.setBotAng(start_angle*pi/180);

% botSim.drawMap();
% drawnow;

tic %starts timer
%% Path Planning
modifiedMap = map;
scans = 30;
inner_boundary = map;
Connecting_Distance = 20;
botSim.setMap(modifiedMap);
botSim.setScanConfig(botSim.generateScanConfig(scans));

Estimated_Bot = BotSim(modifiedMap);
Estimated_Bot.setScanConfig(Estimated_Bot.generateScanConfig(scans));
Estimated_Bot.setBotPos(start_position);
Estimated_Bot.setBotAng(start_angle*pi/180);

% figure(1)
% hold off; %the drawMap() function will clear the drawing when hold is off
% botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
% botSim.drawBot(30,'g'); %draw robot with line length 30 and green
% Estimated_Bot.drawBot(50, 'r');
% drawnow;

if (localize_ON == 1)   
    [botSim, Estimated_Bot] = PFL1(botSim, map,2000,10, 20, handle);
    disp(Estimated_Bot.getBotPos());
    disp(Estimated_Bot.getBotAng()*180/pi);
    Estimated_Bot.setBotPos(Estimated_Bot.getBotPos());
    Estimated_Bot.setBotAng(Estimated_Bot.getBotAng()*180/pi);   
end

if(path_mode == 1)
    waypoints = pathPlanning(start_position, target, map, Connecting_Distance)
    optimisedPath = optimisePath(waypoints)
elseif(path_mode == 2)
    inflated_boundaries = boundary_inflation(map, 14);
    botSim.setMap(inflated_boundaries);
    botSim.drawMap();
    waypoint_coordinates = pathfinder(start_position, target, inflated_boundaries);
    waypoint_coordinates = flipud(waypoint_coordinates);
    optimisedPath = [waypoint_coordinates(:,2),waypoint_coordinates(:,1)]
elseif(path_mode == 3)
    path = pathPlanning2(botSim,map,target,start_position);
    optimisedPath = optimisePath(path)*10;
end

%% Path Move
if(path_mode == 1 || path_mode == 2)
    pathMoveError = pathMove(optimisedPath, Estimated_Bot, botSim);
elseif(path_mode == 3)
    debug = 0;
    angle = start_angle;
    path = optimisedPath;
    for i=1:length(optimisedPath)-1
        angle = pathMove2([path(i,1),path(i,2)], angle, [path(i+1,1),path(i+1,2)],botSim,debug);
    end
end
%% Done!
NXT_PlayTone(1200,100, handle); %plays a tone
NXT_PlayTone(800,800, handle); %plays a tone
toc

%% Clean before program exit
COM_CloseNXT(handle); 
end

