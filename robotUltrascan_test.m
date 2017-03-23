function [scanValues] = robotUltrascan_test()
    % Initialize the sound sensor by setting the sound sensor mode and input port. 
    OpenUltrasonic(SENSOR_4);


    nrScans = 100;
    scanValues = zeros(nrScans,1);

    for i=1:nrScans
        % Get the current sound sensor value in dB.
        scanValues(i) = GetUltrasonic(SENSOR_4);
    end
    
    
    % Close the sound sensor.
    CloseSensor(SENSOR_4);
end