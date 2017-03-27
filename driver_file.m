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

% Ports           = [MOTOR_B; MOTOR_C];  % motorports for left and right wheel

%map=[0,0;60,0;60,45;45,45;45,59;106,59;106,105;0,105];  %the default map
map=[0,0;66,0;66,44;44,44;44,66;110,66;110,110;0,110];
motionNoise = 0.1;
turningNoise = 0.01;
sensorNoise = 1.5;

botSim = BotSim(map,[sensorNoise, motionNoise, turningNoise],0);  %sets up a botSim object a map, and debug mode on.
%start_position = [44 22];
%start_angle = 0;
%botSim.setBotPos(start_position);
%botSim.setBotAng(start_angle);
% target = botSim.getRndPtInMap(10);  %gets random target.
target = [22 22];

botSim.drawMap();
drawnow;
tic %starts timer


%% Particle Filter
% @input: map
% @output: estimatedLocation, estimatedAngle

% [botSim, Estimated_Bot] = PFL1(botSim, map,2000,10, 20, handle); 
% disp(Estimated_Bot.getBotPos())
% disp(Estimated_Bot.getBotAng()*180/pi)

%% Path Planning
% @input: position, angle, target, map
% @output: pathArray, lost

% Testing Johans version
% inflated_boundaries = boundary_inflation(map, 14); % alternative inflation function
% botSim2 = BotSim(inflated_boundaries,[0,0,0]);  %sets up a botSim object a map, and debug mode on.
% path0 = pathPlanning2(botSim,map,target,start_position)*10

% Parameters for path planning only
modifiedMap = map;
scans = 30;
Connecting_Distance = 30;


figure(1)
hold off; %the drawMap() function will clear the drawing when hold is off
botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
%botSim.drawBot(30,'g'); %draw robot with line length 30 and green
Estimated_Bot.drawBot(50, 'r');
drawnow;


start_position = Estimated_Bot.getBotPos();

waypoints = pathPlanning(start_position, target, map, Connecting_Distance);
optimisedPath = optimisePath(waypoints)
% for i=1:length(optimisedPath)
%     plot(optimisedPath(i,2),optimisedPath(i,1),'x')
% end
    
%% Path Move
% @input: currentPosition, nextPosition, currentAngle
 pathMoveError = pathMove(optimisedPath, Estimated_Bot, botSim);

% aries path plan with johans path move
% hold on
% mtx=zeros(size(waypoints));
% mtx(:,1)=waypoints(:,2)
% mtx(:,2)=waypoints(:,1)
% waypoints=mtx;
% plot(waypoints(1,1),waypoints(1,2),'bo')
% for i=1:length(waypoints)
%     plot(waypoints(i,1),waypoints(i,2),'x')
% end
% path=flipud(waypoints(:,1:2))*10;


%testing johans path move
% for i=1:length(path0)
%     plot(path0(i,1)/10,path0(i,2)/10,'x')
% end
% 
% figure
% path=optimisePath(path0);
% botSim.drawMap();
% drawnow;
% hold on
% for i=1:length(path)
%     plot(path(i,1)/10,path(i,2)/10,'x')
% end
% angle = 0;
% debug=1;      
% botSim.setBotPos([path(1,1)/10,path(1,2)/10])
% botSim.drawBot(10);
% for i=1:length(path)-1
%     angle = pathMove2([path(i,1),path(i,2)], angle, [path(i+1,1),path(i+1,2)],botSim,debug);
% end
%% Done!
NXT_PlayTone(1200,100, handle); %plays a tone
NXT_PlayTone(800,800, handle); %plays a tone
toc

%% Clean before program exit
COM_CloseNXT(handle); 
end
