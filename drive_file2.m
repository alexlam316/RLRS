function driver_file()

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

map=[0,0;66,0;66,44;44,44;44,66;110,66;110,110;0,110];  %default map
botSim = BotSim(map,[0,0,0]);  %sets up a botSim object a map, and debug mode on.
start_position = [88 88];
start_angle = 180; % in degree
botSim.setBotPos(start_position);
botSim.setBotAng(start_angle*pi/180);
target = [44 22];

botSim.drawMap();
drawnow;

%% Particle Filter

%% Path Planning

% Parameters for path planning only
modifiedMap = map;
scans = 30;
Connecting_Distance = 30;

botSim.setMap(modifiedMap);
botSim.setScanConfig(botSim.generateScanConfig(scans));
Estimated_Bot = BotSim(modifiedMap);
Estimated_Bot.setScanConfig(Estimated_Bot.generateScanConfig(scans));
Estimated_Bot.setBotPos(start_position);
Estimated_Bot.setBotAng(start_angle*pi/180);

figure(1)
hold off; %the drawMap() function will clear the drawing when hold is off
botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
botSim.drawBot(30,'g'); %draw robot with line length 30 and green
Estimated_Bot.drawBot(50, 'r');
drawnow;

waypoints = pathPlanning(start_position, target, map, Connecting_Distance);
optimisedPath = optimisePath(waypoints)

%% Path Move

tic %starts timer
 pathMoveError = pathMove(optimisedPath, Estimated_Bot); %, botSim

%% Last Move to Target - Correct Accumulated Error

% if pathMoveError == 0
%     targetSim = BotSim(modifiedMap);
%     targetSim.setScanConfig(targetSim.generateScanConfig(scans));
%     targetSim.setBotPos(target);
%     targetAngle = pi/180*atan2d(waypoints(1,1)-waypoints(2,1),waypoints(1,2)-waypoints(2,2));
%     targetSim.setBotAng(targetAngle);
% end

%% Done!
NXT_PlayTone(1200,100, handle); %plays a tone
NXT_PlayTone(800,800, handle); %plays a tone
toc

%% Clean before program exit
COM_CloseNXT(handle); 
end
