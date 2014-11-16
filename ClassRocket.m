classdef ClassRocket
    
    properties
        % ----- ambient air -----
        AmbientTemp;
        AmbientPressure;
        AirDensity;
        AirViscosity;
        
        OuterDiam;
        
        InitMass;
        Mass
        TotalImpulse;
        
        Altitude;
        
        Velocity;
        Mach;
        Drag;
        DragCoef;
        Reynolds;
    end
    
    methods
        
        function object = ClassRocket(AmbientTemp, OutsideDiam, InitMass)
            
            if (nargin >= 1)
                disp('Created rocket from hard-coded numbers');
                object.AmbientTemp= AmbientTemp;
                object.OuterDiam = OutsideDiam;
                object.InitMass = InitMass;
            else
                data = xlsread('ObjectProperties.xlsx', 'Rocket');
                object.AmbientTemp = data(1);
                object.OuterDiam = data(2);
                object.InitMass = data(3);
            end
        end
        
        function obj = Initialize(obj)
            
            global LaunchAltitude
            
            obj.Altitude = LaunchAltitude;
            obj.Velocity = 0;
            obj.TotalImpulse = 0;
            
        end
        
        function obj = UpdatePhysicalConditions(obj, i)
            
            global AmbientPressureRef  % in Pa
            global TempSlope  % in K/m
            global GasConstR  % in (J/K/mol)
            global MolarMass  % in (kg/mol)
            global gravity %  in (m/s^2)
            % ----- Sutherland's Constants -----
            global AirViscosityRef  % in (Pa*s)
            global TempConst  % in K
            global TempRef  % in K
            
            % See 'atmosphericProperties.m'
            obj.AmbientTemp(i) = obj.AmbientTemp(1) + TempSlope * ...
                (obj.Altitude(1) - obj.Altitude(i));
            obj.AmbientPressure(i) = AmbientPressureRef * (1 - TempSlope ...
                * obj.Altitude(i) / obj.AmbientTemp(1)) ^ (gravity * MolarMass...
                / GasConstR / obj.Altitude(i));
            obj.AirDensity(i) = obj.AmbientPressure(i) * MolarMass / GasConst ...
                / obj.AmbientTemp(i);
            obj.AirViscosity(i) = AirViscosityRef * (TempRef + TempConst) / ...
                (obj.AmbientTemp(i) + TempConst) * (obj.AmbientTemp(i) / ...
                TempRef) ^ 1.5;
            
            global DragMach
            global DragCoef
            global AirSpecificHeatRatio  % unitless, Cp/Cv
            
            % See 'Aerodynamics.m'
            obj.Mach(i) = obj.Velocity(i) / sqrt(AirSpecificHeatRatio * GasConstR ...
                *obj.AmbientTemp(i) / MolarMass);
            obj.Reynolds(i) = obj.AirDensity(i) * obj.Veolcity(i) * obj.OuterDiam ...
                / obj.AirViscosity(i);
            obj.DragCoef(i) = interp1(DragMach, DragCoef, obj.Mach(i));
            obj.Drag(i) = 0.5 * obj.DragCoef(i) * obj.Velocity(i) ^ 2 * pi / 4 ...
                * obj.OuterDiam ^ 2;
            
        end
        
    end
    
end
