function LaunchSite = LaunchSites(Name,Input1,Input2,Input3)
%%Multi Pad Support is intendend but not implemented
global r_E
global Background
global Pe_E


switch Name
  case 'SAZLC'
    %Fictional launch site in southern Arizona
    Lat=31.55219182036449;
    Long=-113.75311595101736;
    Alt=25;
  case 'KSC'
    Lat=28.608270;
    Long=-80.604178;
    Alt=3;
  case 'Vandenburg'
    Lat=34.756085;
    Long=-113.75311595101736;
    Alt=113;
  case 'Tanegashima'
    Lat=30.400961;
    Long=130.977552;
    Alt=36;
  case 'Baikonur'
    Lat=45.965000;
    Long=63.305000;
    Alt=90;
  case 'Kourou'
    Lat=5.264636;
    Long=-52.792204;
    Alt=10;
  case 'Plesetsk'
    Lat=62.925556;
    Long=40.577778;
    Alt=90;
  case 'Starbase'
    Lat=25.996;
    Long=-97.154;
    Alt=2;
  case 'Uchinoura'
    Lat=31.2523;
    Long=131.0785;
    Alt=287;
  case 'Jiuquan'
    Lat=40.96056;
    Long=100.29833;
    Alt=1073;
  case 'Taiyuan'
    Lat=38.849086;
    Long=111.608497;
    Alt=1455;
  case 'Xichang'
    Lat=28.24646;
    Long=102.02814;
    Alt=1861;
  case 'Wenchang'
    Lat=19.614492;
    Long=110.951133;
    Alt=9;
  case 'Semnan'
    Lat=35.234631;
    Long=53.920941;
    Alt=943;
  case 'Woomera'
    Lat=-30.94907;
    Long=136.53418;
    Alt=137;
%  case ' '
%    Lat= ;
%    Long= ;
%    Alt= ;
  case 'Custom'
   if nargin < 4
    Input1=0;
    Input2=0;
    Input3=0;
   end


    Lat=Input1;
    Long=Input2;
    Alt=Input3;
  otherwise
    Lat=0;
    Long=0;
    Alt=0;
end

r_bar=[(Alt+r_E)*cosd(Long)*cosd(Lat),(Alt+r_E)*sind(Long)*cosd(Lat),(Alt+r_E)*sind(Lat)];


v=2*pi*(Alt+r_E)/Pe_E * cosd(Lat);
v_bar=v*cross([0,0,1],unit(r_bar));

LaunchSite.Lat=Lat;
LaunchSite.Long=Long;
LaunchSite.Alt=Alt+r_E;
LaunchSite.r_bar=r_bar;
LaunchSite.v_bar=v_bar;
end
