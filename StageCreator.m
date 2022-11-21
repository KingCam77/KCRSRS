%Stage Creator
function vehicle = StageCreator(engines, engine, fuel, throttle, massvars, payload, timing, lateSRBsep)
  %%example engine matrix [2, 1, 0; 0, 1, 0; 0, 0, 1]
  %%example fuel matrix [40000, 3000, 30000]
      %In order of stages [boosters, core, second, next, so on]
      %Does not support multiple SRB stages, only initial stage
      %If no boosters, leave first spot as zero, program will understand.
  %%Throttle matix is optional (not yet)
  %%timings is a matrix stage-1 long and two tall
      %Top row is the time between engine cutoff and seperation
      %Bottom row is the time between seperation and engine ignition


extra=massvars.extra;
percent=massvars.percent;

if fuel(1) > 0
  SRB=1;
  vehicle.SRB=1;
  n=length(fuel);
  m=length(fuel)+1;
else
  SRB=0;
  vehicle.SRB=0;
  n=length(fuel)-1;
  m=length(fuel);
  fuel=fuel(2:m);
end

if nargin < 8
  lateSRBsep='false';
end


%initial mass

mass(m).fuel=0;
mass(m).extra=0;
mass(m).tankWeight=0;
mass(m).payload=payload;
mass(m).total=payload;

i=m-1;
while i > 0
mass(i).fuel=fuel(i);
mass(i).extra=extra(i);
mass(i).tankWeight=fuel(i)*percent(i);
mass(i).payload=mass(i+1).total;
mass(i).total=mass(i).fuel+mass(i).extra+mass(i).tankWeight+mass(i).payload;
--i;
end

if SRB == 1
  mass(1).boosters=mass(1).total-mass(2).total;
end


i=1;
for i=1:n
stage(i).engines=engine(i,:);
stage(i).throttle=throttle(i,:);
stage(i).m_dot=sum(stage(i).engines .* stage(i).throttle .* engines.m_dot);



if i==1 && SRB==1
stage(i).time=VehicleTools('MaxBurn', fuel(1), engines.m_dot(1));
stage(i).mass=mass(1).total;


elseif i==2 && SRB==1
stage(i).time=VehicleTools('MaxBurn', fuel(2), stage(2).m_dot)-stage(1).time;
stage(i).mass=VehicleTools('Mass', mass(1), stage(1), engines, lateSRBsep);

else
stage(i).time=VehicleTools('MaxBurn', fuel(i), stage(i).m_dot);
stage(i).mass=mass(i).total;
end

#stage(i).area=VehicleTools('Area', DiaM, DiaB, NumbB);
stage(i).s_phase=0;
end

vehicle.stage=stage

%%Moving here because it makes sense
vehicle.state.m=stage(1).mass;


%%Stage Seperation timings
i=1;
for i=1:n
if (SRB == 1 && i == 1)
sepDelay(i) = stage(i).time;
ignDelay(i) = stage(i).time;
elseif (SRB == 0 && i == 1)
sepDelay(i) = stage(i).time + timing(1,i);
ignDelay(i) = sepDelay(i) + timing(2,i);
elseif i == n
sepDelay(i) = ignDelay(i-1)+stage(i).time;
ignDelay(i) = sepDelay(i);
else
sepDelay(i) = ignDelay(i-1)+stage(i).time + timing(1,i);
ignDelay(i) = sepDelay(i) + timing(2,i);
end
end

vehicle.timings=[sepDelay; ignDelay]

vehicle.engines=engines;
vehicle.curStage=1;
