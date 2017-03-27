COM_CloseNXT all
close all
clear all
clc

handle = COM_OpenNXT(); %open usb port
COM_SetDefaultNXT(handle); % set default handle
% Initialize the sound sensor by setting the sound sensor mode and input port.
OpenUltrasonic(SENSOR_4);


nrScans = 100;
scanValues = zeros(nrScans,1);

for i=1:nrScans
    % Get the current sound sensor value in dB.
    scanValues(i) = GetUltrasonic(SENSOR_4)
end

a = mode(scanValues);
for i=1:nrScans
    % Get the current sound sensor value in dB.
    if(scanValues(i) ~= a)
        disp(i);
        disp(scanValues(i));
        
    end
end



% Close the sound sensor.
CloseSensor(SENSOR_4);
