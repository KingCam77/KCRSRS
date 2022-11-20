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
TankWallThickness=0.1;
TankRatio=0.5;

%%%Calculations

LH2mass1=Fuel1/6;
LOXmass1=Fuel1-LH2mass1;
LOXvol1=LOXmass1/LOXdensity;
LH2vol1=LH2mass1/LH2density;

LH2mass2=Fuel2/6;
LOXmass2=Fuel2-LH2mass2;
LOXvol2=LOXmass2/LOXdensity;
LH2vol2=LH2mass2/LH2density;

TankR=DiaM/2-TankWallThickness;

V=LH2vol1;
tanks = TankCalc(V, TankR, TankRatio);

V=LOXvol1;
tanks = TankCalc(V, TankR, TankRatio, 2, tanks);

V=LH2vol2;
tanks = TankCalc(V, TankR, TankRatio, 3, tanks);

V=LOXvol2;
tanks = TankCalc(V, TankR, TankRatio, 4, tanks);

%%Create Engines
%First Stage Engine

engines.thrust_asl=2250000;
engines.isp_asl=260;
engines.isp_vac=280;
engines.m_dot=600;

[engines]=EngineCalc(14600000,640,9000,6,25,70,0.95,2,engines);
%Second Stage Engine
[engines]=EngineCalc(4700000,35,33500,6,25,60,0.925,3,engines);

%%Mass Calculations
mass = MassCalc([Fuel1, Fuel2], [2000, 1500], [0.05, 0.04], Payload);

%%Stage creator

global rocket



%%Stages
stage(1).engines=[2,1,0];
stage(1).throttle=[1,1,1];
stage(1).time=VehicleTools('MaxBurn', FuelB, qB);
stage(1).mass=mass(1).Total;
stage(1).area=VehicleTools('Area', DiaM, DiaB, NumbB);
stage(1).s_phase=0;


stage(2).engines=[0,1,0];
stage(2).throttle=[1,1,1];
stage(2).time=VehicleTools('MaxBurn', Fuel1, rocket.engines.m_dot(2))-stage(1).time;
stage(2).mass=mass(1).Total-FuelB*2-stage(1).time*rocket.engines.m_dot(2);
stage(2).area=VehicleTools('Area', DiaM);
stage(2).s_phase=0;

stage(3).engines=[0,0,1];
stage(3).throttle=[1,1,1];
stage(3).time=VehicleTools('MaxBurn', Fuel2, rocket.engines.m_dot(3));
stage(3).mass=mass(2).Total;
stage(3).area=VehicleTools('Area', DiaM);
stage(3).s_phase=0;



TargetAlt=200000;

LaunchSiteName='Plesetsk';
launchSite=LaunchSites(LaunchSiteName);

state.r_bar=launchSite.r_bar;
state.v_bar=launchSite.v_bar;
state.t=0;



guidance.DeltaLAN=2;
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

clear XtraMass1 XtraMass2 TankP1 TankP2 mass launchSite guidance
