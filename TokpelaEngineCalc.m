%%engine calculator
clc, clear

%Generate global constants
ConstantInitializer

%Create Vehicle Properties
%In this case the tokpela
TokpelaInitializer

TimeEval=10;

t=0:1:TimeEval;

Tburn1 = 240
Sep1T = 245
Tburn2s = 250
Sep2T = 1000
Tburn2 = 600

Throttle = 100
ThrottleEnd = 70
target = 400000;

Target= target+(6.3781*10^6);

TburnB=FuelB/qB;


z=1:3;
Vr(z,1)=0;
Vrr(z,1)=0;
Vrt(z,1)=0;
d(z,1)=0;
Mach(z,1)=0;
DyP(z,1)=0;
Mass(z,1)=MassI1;
Grav(z,1)=G*MassI1;
GravAngle(z,1)=0;
DistEarth(z,1)=(6.3781*10^6);
CalcAlt(z,1)=0;
AirAngle(z,1)=0;
Ft(z,1)=Thrust1(Throttle,fix((CalcAlt(z,1)/AltStep))+1);
ValSet = 0;
Fuel(1,1)=Fuel1;
Fuel(2,1)=Fuel2;
Fuel(3,1)=0;
GammaAngle(z,1)=90;
Vangle(z,1)=GammaAngle(z,1);
Accel(z,1)=0;
temp(z,1)=0;
Accelraw(z,1)=Ft(z,1)./Mass(z,1);
Start=1

b=1:2;
A(b)=0;
B(b)=0;
T(1)=240;
T(2)=800;
ct=10;
lc=0;
Ve2=100;

OmegaT=2*pi*sqrt(Target^3/GravMu);
TWR(z,1)=(Ft(z,round((CalcAlt(1,1)./AltStep)+1))./(G.*Mass(z,1)));

MaxLoop = TimeEval*3+100;
MaxLoopS = 0;
MaxLoopM = 0;
x=2
s=1
while x<TimeEval && MaxLoopM < MaxLoop
++MaxLoopM;
#try
while s<4 && MaxLoopS < MaxLoop
++MaxLoopS;
if CalcAlt(s,x-1) >= -10

if Vr(s,x-1) > 7700 && ValSet <= 1
Tburn2 = x-Tburn2s-1;
ValSet = 1
end

%Booster Stage Marker
if x <= TburnB
Boost = 1;
Area(s,x)= NumbB*pi*(DiaB/2)^2+19.63;
else
Boost = 2;
Area(s,x)= 19.63;
end

if x <= Tburn1 && Fuel(1,x-1) > 0
E1=1;
else
E1=0;
end

if x >= Tburn2s && Fuel(2,x-1) > 0 && x <= (Tburn2s+Tburn2)
E2=1;
else
E2=0;
end


if x >= Sep1T
Sep1=1;
else
Sep1=0;
end

if x >= Sep2T
Sep2=1;
else
Sep2=0;
end


%%Atmosphere Dependent Calculations
if CalcAlt(s,x-1)<=90000
Mach(s,x) = abs(Vr(s,x-1))/AtmoProp(4,fix((CalcAlt(s,x-1)/AltStep))+1);
DyP(s,x)=0.5*AtmoProp(3,fix((CalcAlt(s,x-1)/AltStep))+1)*Vr(s,x-1)^2;

%Area
if Boost == 2
Area(s,x)= pi*(DiaM/2)^2;
else
Area(s,x)= NumbB*pi*(DiaB/2)^2+pi*(DiaM/2)^2;
end

if x < 500
Atmo(s) = x; %%Flag for atmospheric property graphing
end
  if Mach(s,x)>4.5
   d(s,x)=0.5*Cd(fix(4.5/MachStep+1))*Area(s,x)*AtmoProp(3,fix((CalcAlt(s,x-1)/AltStep))+1)*Vr(s,x-1)^2;
  else
   d(s,x)=0.5*Cd(fix(Mach(s,x)/MachStep)+1)*Area(s,x)*AtmoProp(3,fix((CalcAlt(s,x-1)/AltStep))+1)*Vr(s,x-1)^2;
  end
else
  Mach(s,x)=abs(Vr(s,x-1))/274.04;
  d(s,x)=0;
  DyP(s,x)=0;
end


%%Thrust Calculator
if E1 == 1
    Ft(s,x)=Thrust1(Throttle,fix((CalcAlt(x-1)/AltStep))+1);
    Isp(s,x)=Isp1(Throttle,fix((CalcAlt(x-1)/AltStep))+1);
elseif E2 == 1
    if s == 1
      Ft(s,x)=0;
      Isp(s,x)=0;
    else
      Ft(s,x)=Thrust2(Throttle,fix((CalcAlt(s,x-1)/AltStep))+1);
      Isp(s,x)=Isp1(Throttle,fix((CalcAlt(x-1)/AltStep))+1);
    end
else
    Ft(s,x)=0;
    Isp(s,x)=0;
end


%Fuel Calc
if E1 == 1
switch s
  case 1
    Fuel(s,x)=Fuel(s,x-1)-q1(Throttle);
  case 2
    Fuel(s,x)=Fuel(s,x-1);
  case 3
    Fuel(s,x)=0;
end
elseif E2 == 1
switch s
  case 1
    Fuel(s,x)=Fuel(s,x-1);
  case 2
    Fuel(s,x)=Fuel(s,x-1)-q2(Throttle);
  case 3
    Fuel(s,x)=0;
end
else
    Fuel(s,x)=Fuel(s,x-1);
end



%%Mass
if Sep1 == 0
  Mass(s,x)=MassF1+Fuel(1,x);
elseif Sep1 == 1 && Sep2 == 0
  if s == 1
    Mass(s,x)=MassF1+Fuel(1,x);
  else
    Mass(s,x)=MassF2+Fuel(2,x);
  end
elseif Sep2 == 1
switch s
  case 1
    Mass(s,x)=MassF1+Fuel(1,x);
  case 2
    Mass(s,x)=MassF2+Fuel(2,x);
  case 3
    Mass(s,x)=Payload;
  end
end

Accelraw(s,x)=Ft(s,x)/Mass(s,x);

if Boost == 1 && Sep1 == 0
  Ft(s,x) = Ft(s,x)+NumbB*ThrustB;
  Mass(s,x)=Mass(s,x)+MassIB-qB*x;
end


CalcAlt(s,x)=DistEarth(s,x-1)-(6.3781*10^6);

Grav(s,x) = (GravMu.*Mass(s,x))./(DistEarth(s,x-1).^2);

if CalcAlt(s,x-1) < 3000;
GammaAngle(s,x) = 90;
elseif CalcAlt(s,x-1) < 4000;
GammaAngle(s,x) = 80;
else
GammaAngle(s,x) = Vangle(s,x-1);
end


%%TWR Calculator
if Ft(s,x) > 0
TWR(s,x)=Ft(s,x)/(Grav(s,x));
else
TWR(s,x)=0;
end

Accelt(s,x) = (Ft(s,x)*cosd(GammaAngle(s,x))-(d(s,x)*cosd(Vangle(s,x-1))))/(Mass(s,x));
Accelr(s,x) = (Ft(s,x)*sind(GammaAngle(s,x))-(d(s,x)*sind(Vangle(s,x-1)))-Grav(s,x))/(Mass(s,x));

Vrt(s,x)=Vrt(s,x-1)+Accelt(s,x);
Vrr(s,x)=Vrr(s,x-1)+Accelr(s,x);
omega(s,x)=Vrt(s,x)/DistEarth(s,x-1);

GravAngle(s,x)= GravAngle(s,x-1)+omega(s,x);
DistEarth(s,x)= DistEarth(s,x-1)+Vrr(s,x);

Vr(s,x)=sqrt(Vrr(s,x)^2+Vrt(s,x)^2);
Accel(s,x)=sqrt(Accelr(s,x)^2+Accelt(s,x)^2);
Vangle(s,x)=atand(Vrr(s,x)/Vrt(s,x));

else
TWR(s,x) = 0;
Mach(s,x)= 0;
d(s,x)= 0;
DyP(s,x)= 0;
Ft(s,x) = 0;
Mass(s,x) = Mass(s,x-1);
DistEarth(s,x) = DistEarth(s,x-1);
Grav(s,x) = 0;
CalcAlt(s,x)= CalcAlt(s,x-1);
Accelt(s,x)=0;
Accelr(s,x)=0;
Vrt(s,x)=0;
Vrr(s,x)=0;
Vr(s,x)=0;
Accel(s,x)=0;
GravAngle(s,x)=GravAngle(s,x-1);
Area(s,x)=Area(s,x-1);
GammaAngle(s,x)=0;
end

  ++s;
end
if (lc < ct-1)
++lc;
else
Guidance;
Pitch(1,x)=asind(Fr1(T0));
Pitch(2,x)=asind(Fr2(T0));
lc=0;
end;

++x;
s=1;
#catch
#  error=1
#  break;
#end_try_catch
end

t=1:1:x-1;
tAtmo=1:1:Atmo(1)-1;
dTrim=d(tAtmo);
MachTrim=Mach(tAtmo);
DyPTrim=DyP(tAtmo);
GammaAngleR = deg2rad(GammaAngle);
GravAngleR = deg2rad(GravAngle);
AirAngleR = deg2rad(AirAngle);

subplot(3,6,[1,2,7,8,13,14])

[Ycoord,Xcoord]=pol2cart(GravAngle,DistEarth);

plot(Xcoord(1,:),Ycoord(1,:),'-r')
hold on
plot(Xcoord(2,:),Ycoord(2,:),'-r')
plot(Xcoord(3,:),Ycoord(3,:),'-r')
theta=0:3.1415/100:6.283;
x1=(6.3781*10^6)*cos(theta);
y1=(6.3781*10^6)*sin(theta);
x2=(6.3781*10^6+100000)*cos(theta);
y2=(6.3781*10^6+100000)*sin(theta);
x3=(6.3781*10^6+400000)*cos(theta);
y3=(6.3781*10^6+400000)*sin(theta);
plot(x1,y1,'-g',x2,y2,'-.b',x3,y3,':k')
axis("equal")
#axis([-20000, 400000, -20000, 400000], "equal")
hold off
title("Orbit Track")
xlabel('Distance (m)')
ylabel('Distance (m)')

subplot(3,6,3)
plot(t,CalcAlt)
hold on
AltGoal(t)=400000;
plot(t,AltGoal, ":k")
kar(t)=100000;
plot(t,kar, "-r")
xlabel('Time (s)')
ylabel('Altitude (m)')
title("Altitude")
hold off


subplot(3,6,4)
plot(t,Vr)
title("Velocity")
xlabel('Time (s)')
ylabel('Speed (m/s)')

subplot(3,6,5)
plot(t,Accel)
title("Acceleration")
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')

subplot(3,6,6)
plot(t,Mass)
title("Mass")
xlabel('Time (s)')
ylabel('Mass (kg)')

subplot(3,6,9)
plot(t,Ft)
title("Thrust")
xlabel('Time (s)')
ylabel('Force (N)')

subplot(3,6,10)
plot(t,TWR)
title("Thrust To Weight Ratio")
xlabel('Time (s)')
ylabel('TWR Number')

subplot(3,6,11)
polar(GammaAngleR,t)
hold on
#polar(AirAngleR(2,:),t)
hold off
title("Gravity Turn angle")
xlabel('Time (s)')
ylabel('Angle (Degrees)')

subplot(3,6,12)
polar(GravAngleR,t)
title("Gravity angle")
xlabel('Time (s)')
ylabel('Angle (Degrees)')


subplot(3,6,15)
plot(tAtmo,dTrim)
title("Drag")
xlabel('Time (s)')
ylabel('Force (N)')

subplot(3,6,16)
plot(tAtmo,MachTrim)
title("Mach")
xlabel('Time (s)')
ylabel('Mach Number')

subplot(3,6,17)
plot(tAtmo,DyPTrim)
title("Dynamic Pressure")
xlabel('Time (s)')
ylabel('Dynamic Pressure (Pa)')
