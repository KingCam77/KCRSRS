%%Physics loop
clear
clc

ConstantInitializer
TokpelaInitializer;


dt=1
TimeEval=1000;
ENG=1;

v_bar=vehicle.state.v_bar;
r_bar=vehicle.state.r_bar;
x=1
major_cycle=15;
mass=vehicle.stage(1).mass;
area=vehicle.stage(1).area;
start=1

valset=0;

guidance.type = 1
guidance.velocity = 50
guidance.pitch = 90
guidance.azimuth = vehicle.target.azi



Deltav_bar_sensed=0;

lc=0;
test=2
GuideCall=0;

%%Initialization

%%Initialize Guidance Types
if guidance.type == 1
  GT_v=guidance.velocity;
  GT_angle=guidance.pitch;
  azi=guidance.azimuth;
  GT=0;
elseif guidance.type == 2
  target=guidance.target;
  cycle=guidance.cycle;
  lc=0;

  UPFG_state.time=t(1);
  UPFG_state.mass=m;
  UPFG_state.r_bar=r_bar;
  UPFG_state.v_bar=v_bar;

  pre.Deltat_prime_c=0;
  pre.x_prime_c=0;
  pre.A=0;
  pre.D=0;
  pre.E=0;

  UPFG_internal.s_pre=1;

  UPFG(vehicle, target, UFPG_state, UPFG_internal)

elseif guidance.type == 3
accel=0;
ENG=-1;
end


nav=GetFrame(r_bar);
circum=GetFrame(r_bar, v_bar);

v_bar_surf=v_bar-surfSpeed(r_bar, nav);

v_radial=0;

Angle_surf_pitch = GetAngle(v_bar_surf, nav, 'pitch');
Angle_surf_yaw = GetAngle(v_bar_surf, nav, 'yaw');


alt=norm(r_bar)-r_E;

t=0;

while x<=(TimeEval/dt) && test == 2
#try

%%GUIDANCE SET UP
if guidance.type == 1
  %%Gravity Turn

  if (v_radial >= GT_v && GT == 0)
    GT = 1;
  elseif (Angle_surf_pitch > GT_angle && GT == 1)
    GT = 2;
  endif

  if GT == 0
    pitch=0;
    yaw=azi;
  elseif GT == 1
    pitch=min(pitch+dt, GT_angle);
    yaw=azi;
  else
    pitch=Angle_surf_pitch;
    yaw=azi;
  end
elseif guidance.type == 2
  %%UPFG, needs implementing

end

%%Stage Manager
[vehicle, mass, area, ENG] = StageManager(vehicle, t, mass);





%%Thrust
[thrust, m_dot] = GetThrust(vehicle, alt, ENG);

%%Mass

%add minor jettison code here, handles fairing sep and late booster sep

mass=mass-m_dot;




%%Guidance Angles To Vector
guide_bar = rodrigues(nav(1,:), nav(2,:), pitch);
guide_bar = rodrigues(guide_bar, nav(1,:), yaw);

%%Gravity acceleration
g_bar=unit(r_bar)*(-mu_E/(norm(r_bar)^2));
%%Drag acceleration
mach = norm(v_bar)/AtmoProp(alt,3);
Dy_p = 0.5*AtmoProp(alt,2)*norm(v_bar)^2;
drag = (CdBasic(mach)*area*Dy_p)/mass;
drag = drag*unit(v_bar_surf);

%Thrust acceleration
Thrust_bar=(thrust*unit(guide_bar))/mass;

%Total acceleration
a_bar=Thrust_bar+drag+g_bar;

%Velocity
v_bar=v_bar+a_bar*dt;

v_bar_surf=v_bar-surfSpeed(r_bar, nav);

v_radial=dot(v_bar_surf,nav(1,:));
v_down=dot(v_bar_surf,nav(2,:));

%%Position
r_bar=r_bar+v_bar;

%%Altitude
alt=norm(r_bar)-r_E;



%%Rebuild local reference frames
nav=GetFrame(r_bar);
circum=GetFrame(r_bar, v_bar);
%%Angles
Angle_surf_pitch = GetAngle(v_bar_surf, nav, 'pitch');
Angle_surf_yaw = GetAngle(v_bar_surf, nav, 'yaw');



%%Value Record
v_record(x)=norm(v_bar);
alt_record(x)=alt;
r_bar_record(x,:)=r_bar;
a_record(x)=norm(a_bar);
thrust_record(x)=thrust;
GrnTrack(x,:)=unit(r_bar)*(r_E);

%Accelerometer
#Deltav_bar_sensed=a_bar*dt+Deltav_bar_sensed;
#data.t=x*dt;

t=t+dt;
x=x+1;
%Fail Conditions
if alt < -10
  disp('Rocket Crashed into the ground')
  break;
end


#catch
#  error=1
#  break;
#end_try_catch
end

x1=target.r_bar_d(1);
y1=target.r_bar_d(2);
z1=target.r_bar_d(3);
r_x=r_bar_record(:,1)';
r_y=r_bar_record(:,2)';
r_z=r_bar_record(:,3)';

g_x=GrnTrack(:,1)';
g_y=GrnTrack(:,2)';
g_z=GrnTrack(:,3)';


[a,b,c]=sphere(50);
surf(a*r_E,b*r_E,c*r_E, 'FaceColor','texturemap','EdgeColor','none','Cdata',flipud(Background))
hold on
plot3(x1,y1,z1,'ro')
plot3(r_x,r_y,r_z,'r-', 'LineWidth',2)
plot3(g_x,g_y,g_z,'y-', 'LineWidth',1)
hold off
axis('equal')
zlim([0 inf])
