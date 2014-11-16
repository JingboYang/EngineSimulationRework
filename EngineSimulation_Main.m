% UTAT Rocket Engine Simulation
% EngineSimulation_Main

clear

DefineGlobalVariables

% ----- Create objects ----- 
% Loaded global variables from 'ObjectProperties.xlsx'
disp('Creating objects (this step takes a bit long)');

engine = ClassEngine();
fuelcore = ClassFuelCore();
injector = ClassInjector();
nozzle = ClassNozzle();
oxtank = ClassOxTank();
plumbing = ClassPlumbing();
rocket = ClassRocket();

% ----- Initialize fuel core-----
disp('Initializing fuel core')
engine = engine.Initialize();
fuelcore = fuelcore.Initialize(engine);
%injector has no initialize
nozzle = nozzle.Initialize();
oxtank = oxtank.Initialize();
plumbing = plumbing.Initialize();
rocket = rocket.Initialize();


% ----- Simulation -----
i = 1;
while fuelcore.InnerDiam < engine.InnerDiam && fuelcore.Mass > 0
    
    disp('In progress')
    rocket = rocket.UpdatePhysicalConditions(i);
    
    i = i + 1;
end




