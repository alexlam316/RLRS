mBC = NXTMotor('BC', 'Power', 50, 'TachoLimit', 1000);
mBC.ActionAtTachoLimit = 'HOLDBRAKE';
mBC.SendToNXT();
mBC.WaitFor();
pause(3);
mBC.Stop('off');