function turn(angle)
    if(angle > 360)
           angle        = mod(abs(angle),360) % dont turn more than 360dgs
    elseif(angle < -360)
           angle        = -mod(abs(angle),360) % dont turn more than 360dgs
    end
    angle_polarity = 1;
    
    TurningSpeed        = 90;
    if(angle<0)
        TurningSpeed    = -TurningSpeed; % go in opposite direction if negative angle
        angle           = -angle;
        angle_polarity = -angle_polarity;
    end

    if((angle/180)>1) %for positive angle
        angle = 360-angle; % turn in most efficient direction
        TurningSpeed    = -TurningSpeed; % go in opposite direction if negative angle
        angle_polarity = -angle_polarity;
    end
    battery_level = NXT_GetBatteryLevel;
    if(battery_level > 8000)
        if(angle>0)
            f = 298;%postive
        elseif(angle<0)
            f = 304;%negative
        else
            f = 0; %zero
        end
    else
        if(angle>0)
            f = 299;%postive
        elseif(angle<0)
            f = 303;%negative
        else
            f = 0; %zero
        end
    end    

    
    turnTicks           = abs(int16((f/45)*(angle/2)));      % assuming 45dgs turn is 290 ticks
    if(turnTicks == 0) % do nothing
    else
        Ports               = [MOTOR_B; MOTOR_C];  % motorports for left and right wheel

        mTurn1                      = NXTMotor(Ports(2)); % right motor
        mTurn1.SpeedRegulation      = false;  % we could use it if we wanted
        mTurn1.Power                = TurningSpeed;
        mTurn1.ActionAtTachoLimit   = 'Brake';

        % where are we?
%         mTurn1.ResetPosition();
%         data                        = mTurn1.ReadFromNXT();
%         pos                         = data.Position;
        mTurn1.TachoLimit           = int16(turnTicks);


        mTurn2          = mTurn1; % copy data
        mTurn2.Port     = Ports(1);   % left motor
        mTurn2.Power    = - mTurn1.Power; % reverse power
        
        mTurn1.ResetPosition();
        mTurn2.ResetPosition();
        
        mTurn1.SendToNXT(); % send both commands before wait
        mTurn2.SendToNXT();
        mTurn1.WaitFor();
        mTurn2.WaitFor();
        
        data1                        = mTurn1.ReadFromNXT();
        pos1                         = data1.Position;
        
        data2                        = mTurn2.ReadFromNXT();
        pos2                         = data2.Position;
        

        
%         if(angle_polarity==1)
%             % check position after movement!
%             mTurn1.TachoLimit              = abs(round(pos1-turnTicks))
%             if mTurn1.TachoLimit ~= 0
%                 if pos1-turnTicks > 0
%                     mTurn1.Power = -TurningSpeed;
%                 else
%                     mTurn1.Power = TurningSpeed;
%                 end
%                 mTurn1.SendToNXT();
%                 mTurn1.WaitFor();
%             end
%             mTurn2.TachoLimit              = abs(round(pos2+turnTicks))
%             if mTurn2.TachoLimit ~= 0
%                 if pos2+turnTicks > 0
%                     mTurn2.Power = TurningSpeed;
%                 else
%                     mTurn2.Power = -TurningSpeed;
%                 end
%                 mTurn2.SendToNXT();
%                 mTurn2.WaitFor();
%             end
%             
%         elseif(angle_polarity==-1)
%             % check position after movement!
%             mTurn1.TachoLimit              = abs(round(pos1+turnTicks))
%             if mTurn1.TachoLimit ~= 0
%                 if pos1+turnTicks > 0
%                     mTurn1.Power = TurningSpeed;
%                 else
%                     mTurn1.Power = -TurningSpeed;
%                 end
%                 mTurn1.SendToNXT();
%                 mTurn1.WaitFor();
%             end
%             mTurn2.TachoLimit              = abs(round(pos2-turnTicks))
%             if mTurn2.TachoLimit ~= 0
%                 if pos2-turnTicks > 0
%                     mTurn2.Power = -TurningSpeed;
%                 else
%                     mTurn2.Power = TurningSpeed;
%                 end
%                 mTurn2.SendToNXT();
%                 mTurn2.WaitFor();
%             end
%             
%             
%             
%             
%         else
%         end
        
        
    end
end

