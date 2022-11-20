%%%Tokpela Vehicle Initalizer

%%Temporary Booster Location
NumbB=2;
DiaB=1;
ThrustB=2250000;
qB=600;
FuelB=66000;

%%Vehicle Mass

%%Fuel Input
%First Stage Fuel (kg)
Fuel1=220000;
%Second Stage Fuel (kg)
Fuel2=20000;

%Payload Mass (kg)
Payload=100;

%%Extra Mass Parameters
%%Mass fraction of fuel that the tank weights
%First stage percent (0 to 1)
TankP1 = 0.05;
%Second stage percent (0 to 1)
TankP2 = 0.04;

%%Extra Mass
%Extra Mass in first stage (kg)
XtraMass1 = 2000;
%Extra Mass in second stage (kg)
XtraMass2 = 1500;

%%Mass fraction of fuel that the tank weights
TankP1 = 0.05;
TankP2 = 0.04;


%%Rocket Diameter
DiaM=5;

%%%Calculations

Settings.TankWallThickness=0.1;
Settings.TankRatio=0.5
tanks = FuelCalc([Fuel1,Fuel2], [6,6], 'LOX/LH2', DiaM, Settings)

%%Create Engines


engines.thrust_asl=2250000;
engines.isp_asl=260;
engines.isp_vac=280;
engines.m_dot=600;

[engines]=EngineCalc(14600000,640,9000,6,25,70,0.95,2,engines);


[engines]=EngineCalc(4700000,35,33500,6,25,60,0.925,3,engines);



%%Stages
engine=[2,1,0;0,1,0;0,0,1]
fuel=[FuelB, Fuel1, Fuel2]
throttle=[1,1,1;1,1,1;1,1,1]
massvars.percent=[0.08,0.05,0.04]
massvars.extra=[0,2000,1500]
payload=Payload


stage = StageCreator(engines, engine, fuel, throttle, massvars, payload)

TargetAlt=200000;

LaunchSiteName='Plesetsk';
launchSite=LaunchSites(LaunchSiteName);

state.r_bar=launchSite.r_bar;
state.v_bar=launchSite.v_bar;
state.t=0;



guidance.DeltaLAN=1.5;
guidance.oppApsis=TargetAlt;
guidance.Alt=TargetAlt;
guidance.Inclination=90;
target = LaunchTarget(guidance, launchSite);
target.t_ig=0;
target.Deltat_t0=0;

rocket.target=target;

rocket.v_bar_go=target.v_d*unit(cross(-target.i_bar_y,unit(rocket.r_bar)))-rocket.v_bar;

vehicle.stage=stage;
vehicle.engines=engines;
vehicle.target=target;
vehicle.state=state;

clear XtraMass1 XtraMass2 TankP1 TankP2 launchSite guidance
