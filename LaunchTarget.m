%%alt
function target = LaunchTarget(Guidance, LaunchSite)
  global r_E
  global mu_E
  global Pe_E
alt=Guidance.Alt+r_E;
inc=Guidance.Inclination;
DeltaLAN=Guidance.DeltaLAN;
opposingApsis=Guidance.oppApsis+r_E;
lat=LaunchSite.Lat;
long=LaunchSite.Long;
r_bar=LaunchSite.r_bar;

if inc > lat && lat < 180-inc
Beta_inertial = asind(cosd(inc)/cosd(lat));
else
inc=0;
Beta_inertial = asind(cosd(inc)/cosd(lat));
end

v_orbit=sqrt(mu_E/alt)
v_rotate=(2*pi*r_E/Pe_E)*cosd(lat);
v_rotx=v_orbit*sind(Beta_inertial)-v_rotate;
v_roty=v_orbit*cosd(Beta_inertial);
azi=atan2d(v_roty,v_rotx);



lan = mod((long - asind(min(1,tand(90-inc)*tand(lat)))) + 360 + DeltaLAN, 360);

    Rx=[1,0,0;
        0,cosd(inc),-sind(inc);
        0,sind(inc),cosd(inc)];                 %about x for inclination (preserve zero node)
    Ry=[cosd(0),0,sind(0);
        0,1,0;
        -sind(0),0,cosd(0)];                                    %in case we needed it for something
    Rz=[cosd(lan),-sind(lan),0;
        sind(lan),cosd(lan),0;
        0,0,1];                                                 %about z for node
i_bar_y = (Rz*Rx*[0,0,-1]')';



v_d = sqrt( mu_E*((2/alt) - 1 / ((alt+opposingApsis)/2)));
gamma_d=0;


r_bar_d=rodrigues(unit(r_bar), -i_bar_y, 20);
v_bar_d=v_d*unit(cross(-i_bar_y,r_bar_d));


target.azi=azi;
target.lan=lan;
target.r_d=alt;
target.v_d=v_d;
target.r_bar_d=r_bar_d*alt;
target.v_bar_d=v_bar_d;
target.i_bar_y=i_bar_y;
target.gamma_d=gamma_d;
end

