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
Payload=4000;

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

[engines]=EngineCalc(14600000,640,9000,6,25,70,0.95,1);
%Second Stage Engine
[engines]=EngineCalc(4700000,35,33500,6,25,60,0.925,2,engines);

%%Mass Calculations
mass = MassCalc([Fuel1, Fuel2], [2000, 1500], [0.05, 0.04], Payload);

%%Stage creator

global rocket

rocket.s_AElower=[1,0];
rocket.s_AEupper=[0,1];


rocket.n=2;

rocket.t_ig=0;
rocket.K=[100,100];
rocket.K_max=100;

rocket.engines=engines;
rocket.mass=mass;

rocket.s_phase=[0,0];


rocket.Deltat_t0=0;
rocket.deltat=0;
rocket.Deltat_cutoff=3;



LaunchSiteName='SAZLC';
launchSite=LaunchSites(LaunchSiteName);

rocket.r_bar=launchSite.r_bar;
rocket.v_bar=launchSite.v_bar;

TargetAlt=400000;


guidance.DeltaLAN=1.5;
guidance.oppApsis=TargetAlt;
guidance.Alt=TargetAlt;
guidance.Inclination=40;
target = LaunchTarget(guidance, launchSite);

rocket.target=target;

rocket.v_bar_go=target.v_d*unit(cross(-target.i_bar_y,unit(rocket.r_bar)))-rocket.v_bar;


#t_b(1)=rocket.mass(1).Fuel/rocket.engines(1).m_dot(100);
#t_b(2)=rocket.mass(2).Fuel/rocket.engines(2).m_dot(100);
t_c=0;
t_b(1)=0
t_b(2)=0



clear XtraMass1 XtraMass2 TankP1 TankP2 mass engines launchSite guidance
