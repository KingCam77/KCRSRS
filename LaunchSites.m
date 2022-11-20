function LaunchSite = LaunchSites(Name,plot)
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
  case 'Guiana'
    Lat=5.264636;
    Long=-52.792204;
    Alt=10;
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
