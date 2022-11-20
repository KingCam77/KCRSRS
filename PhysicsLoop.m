%%Physics loop
clear
clc

ConstantInitializer
TokpelaInitializer;


dt=1
TimeEval=5000;

Pv_bar=rocket.v_bar;
Pr_bar=rocket.r_bar;
x=1
major_cycle=15;
Pm=rocket.mass(1).Total;
start=1

Fuel(1)=rocket.mass(1).Fuel;
Fuel(2)=rocket.mass(2).Fuel;
valset=0;

Deltav_bar_sensed=0;

UPFG;
lc=0;
test=2
GuideCall=0;
while x<=(TimeEval/dt) && test == 2
#try
Palt=norm(Pr_bar)-r_E;
Palt_record(x)=Palt;
if Palt < -10
  break;
end

%simple grav accel calc
Pg_bar=unit(Pr_bar)*(-mu_E/(norm(Pr_bar)^2));

%%Atmosphere Dependent Calculations
if Palt<=90000
Pmach = norm(Pv_bar) / AtmoProp(4,fix(Palt/AltStep)+1);
#DyP(s,x)=0.5*AtmoProp(3,fix(alt/AltStep)+1)*Vr(s,x-1)^2;

%Area
#if Boost == 2
Area= pi*(DiaM/2)^2;
#else
#Area(s,x)= NumbB*pi*(DiaB/2)^2+pi*(DiaM/2)^2;
#end

#if x < 500
#Atmo(s) = x; %%Flag for atmospheric property graphing
#end
  if Pmach>4.5
   Pdrag_bar=-1*unit(Pv_bar)*(0.5*Cd(fix(4.5/MachStep)+1)*Area*AtmoProp(3,fix(Palt/AltStep)+1)*norm(Pv_bar)^2);
  else
   Pdrag_bar=-1*unit(Pv_bar)*(0.5*Cd(fix(Pmach/MachStep)+1)*Area*AtmoProp(3,fix(Palt/AltStep)+1)*norm(Pv_bar)^2);
  end
else
  Pmach=norm(Pv_bar)/274.04;
  Pdrag_bar=[0,0,0];
#  DyP(s,x)=0;
end

direct=i_bar_f;



if Fuel(1)>0
Pf_bar=2*rocket.engines(1).thrust(100,200)*unit(direct);
Fuel(1)=Fuel(1)-rocket.engines(1).m_dot(100);
Pm=Pm-rocket.engines(1).m_dot(100);
if x<50
Pf_bar=Pf_bar+10000000*unit(direct);
end
elseif t_go_i(1) < 10 && Fuel(1)<=0 && Fuel(2)>0
if valset == 0
Pm=rocket.mass(2).Total;
valset=1;
end
Fuel(2)=Fuel(2)-rocket.engines(2).m_dot(100);
Pm=Pm-rocket.engines(2).m_dot(100);
Pf_bar=rocket.engines(2).thrust(100,10000)*unit(direct)*0;
else
Pf_bar=[0,0,0];
end


%%Acceleration Vector - Right now is just gravity vector
Pa_bar=Pg_bar+(Pdrag_bar+Pf_bar)/Pm;

Pv_bar=Pv_bar+Pa_bar*dt;

Pr_bar=Pr_bar+Pv_bar*dt;

Pr_x(x)=Pr_bar(1);
Pr_y(x)=Pr_bar(2);
Pr_z(x)=Pr_bar(3);


%Accelerometer
Deltav_bar_sensed=Pa_bar*dt+Deltav_bar_sensed;
data.t=x*dt;

x=x+1;

if lc < major_cycle
  lc=lc+dt;
else
  data.Deltav_bar_sensed=Deltav_bar_sensed;
  Deltav_bar_sensed=0;
  UPFG;
  ++GuideCall;
  lc=0;
end

#catch
#  error=1
#  break;
#end_try_catch
end

#x1=launchSite.r_bar(1);
#y1=launchSite.r_bar(2);
#z1=launchSite.r_bar(3);
[a,b,c]=sphere(50);
surf(a*r_E,b*r_E,c*r_E, 'FaceColor','texturemap','EdgeColor','none','Cdata',flipud(Background))
hold on
#plot3(x1,y1,z1,'ro')
plot3(Pr_x,Pr_y,Pr_z,'r-', 'LineWidth',2)
hold off
axis('equal')
zlim([0 inf])