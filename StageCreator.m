%Stage Creator
function vehicle = StageCreator(engines, boosters, booster, enginevars, massvars, payload, timing, lateSRBsep)
  %%example engine matrix [2, 1, 0; 0, 1, 0; 0, 0, 1]
  %%example fuel matrix [40000, 30000, 20000]
      %In order of stages [core, second, next, so on]
      %Booster Fuel is handled in engine structure
  %%Throttle matix is optional (not yet)
  %%timings is a matrix stage-1 long and two tall
      %Top row is the time between engine cutoff and seperation
      %Bottom row is the time between seperation and engine ignition


  %%This function is a mess to read, I cant wait to have fun later
      %Better handling of the boosters could done, mainly with the input matrix.





extra=massvars.extra;
percent=massvars.percent;
engine=enginevars.engine;
fuel=enginevars.fuel;
throttle=enginevars.throttle;


if nargin < 8
  lateSRBsep='false';
end



%%Extra booster stages
[booster_stage, booster_count] = size(booster);

booster_present = booster > 0;

for n=1:booster_stage
  for i=1:booster_count
    t_burn(n,i) = boosters(i).t_burn*booster_present(n,i);
  end
  if ismember(0, unique(t_burn(n,:)))
    extra_stages(n,:) = length(unique(t_burn(n,:)))-1;
  else
    extra_stages(n,:) = length(unique(t_burn(n,:)));
  end
end






%%Core Stage Properties

  %%Core stage mass calculator, supports details for some reason
[n, l] = size(engine)

last=n+1
mass(last).fuel=0;
mass(last).extra=0;
mass(last).tankWeight=0;
mass(last).payload=payload;
mass(last).total=payload;

i=n;
while i > 0
mass(i).fuel=fuel(i);
mass(i).extra=extra(i);
mass(i).tankWeight=fuel(i)*percent(i);
mass(i).payload=mass(i+1).total;
mass(i).total=mass(i).fuel+mass(i).extra+mass(i).tankWeight+mass(i).payload;
--i;
end



[booster_stages, booster_types] = size(booster)

[test, offset] = unique(booster, 'rows', 'stable');

%%Something here breaks with different booster arrays, possibly related to offset = 0

##if offset == 0
##  offset = zeros(booster_stages, 1);
##end

offset=offset-1

%%Sketchy code to create engine phases for booster sections
inc_offset=1;
for i=1:n
  inc=1;
while inc <= extra_stages(i)+1

val_write=(inc):(booster_types-offset(i));

engine_new(inc_offset, :)=engine(i, :);
actual_stage(inc_offset)=i;

booster_new(inc_offset, val_write)=booster(i, val_write);

inc_offset=inc_offset+1;
inc=inc+1;
end
end

booster_exist = booster_new > 0



m_store=0;
[~, act_stage_index] = unique(actual_stage)

for i=1:length(actual_stage)
m = actual_stage(i);
n = act_stage_index(m);

if m == m_store(i)


  stage(i).engines=engine(m,:);
  stage(i).throttle=throttle(m,:);
  stage(i).m_dot=sum(stage(n).engines .* stage(n).throttle .* engines(1).m_dot);
  stage(i).guidance_mode = 2;

  stage(i).time=stage(n).time;
  stage(i).mass=stage(n).mass;

  #stage(i).area=VehicleTools('Area', DiaM, DiaB, NumbB);
  stage(i).s_phase=0;


else

if i == 1
  stage(i).engines=engine(m,:);
  stage(i).throttle=throttle(m,:);
  stage(i).m_dot=sum(stage(n).engines .* stage(n).throttle .* engines(1).m_dot);
  stage(i).guidance_mode = 1;

  stage(i).time=VehicleTools('MaxBurn', fuel(m), stage(i).m_dot);
  stage(i).mass=mass(m).total;

  #stage(i).area=VehicleTools('Area', DiaM, DiaB, NumbB);
  stage(i).s_phase=0;
else

  stage(i).engines=engine(m,:);
  stage(i).throttle=throttle(m,:);
  stage(i).m_dot=sum(stage(n).engines .* stage(n).throttle .* engines(1).m_dot);
  stage(i).guidance_mode = 2;

  stage(i).time=VehicleTools('MaxBurn', fuel(m), stage(i).m_dot);
  stage(i).mass=mass(m).total;

  #stage(i).area=VehicleTools('Area', DiaM, DiaB, NumbB);
  stage(i).s_phase=0;
end

end

m_store(i+1) = m;
end

time_last=0;
time_sum=0;
for i=1:length(actual_stage)
m = actual_stage(i)
n = act_stage_index(m)

time=0;
m_dot=0;
massB=0;
for b=1:booster_types
  m_dot(b)=booster_new(i,b)*boosters(b).m_dot;

  time(b)=boosters(b).t_burn*booster_exist(i,b);
  if time(b) == 0
    time(b) = inf;
  endif

  massB=massB+booster_new(i,b)*boosters(b).mass;
end

%%Time stuff
  time = min(time);
  if time == inf
    time = 0;
  end
  if i == n+extra_stages(m)
    stage(i).time=stage(n+extra_stages(m)).time-time_sum;
    time_sum=0;
    time_last=0;
  else
    stage(i).time=time-time_sum;
  end

  m_dot_total=sum(m_dot);
  stage(i).m_dot_total=stage(i).m_dot+m_dot_total;

  if i == n
    FuelBurn=0;
    FuelBurn_core=0;
  elseif i == n+extra_stages(m)
    FuelBurn_core=FuelBurn_core+stage(i).m_dot*stage(i-1).time
    FuelBurn=FuelBurn_core
  else
    sum(m_dot*stage(i-1).time)
    FuelBurn_core=FuelBurn_core+stage(i).m_dot*stage(i-1).time
    FuelBurn=FuelBurn+stage(i).m_dot*stage(i-1).time+sum(m_dot*stage(i-1).time);
  endif

  stage(i).mass=stage(i).mass+massB-FuelBurn;

  time_sum=time+time_last;
  time_last=time;
end

  #stage(i).time=stage(n).m_dot



















vehicle.stage=stage;

##
##%%Moving here because it makes sense
##vehicle.state.m=stage(1).mass;
##
##
##%%Stage Seperation timings
##i=1;
##for i=1:n
##if i == 1
##sepDelay(i) = stage(i).time + timing(1,i);
##ignDelay(i) = sepDelay(i) + timing(2,i);
##elseif i == n
##sepDelay(i) = ignDelay(i-1)+stage(i).time;
##ignDelay(i) = sepDelay(i);
##else
##sepDelay(i) = ignDelay(i-1)+stage(i).time + timing(1,i);
##ignDelay(i) = sepDelay(i) + timing(2,i);
##end
##end
##
##vehicle.timings=[sepDelay; ignDelay];

vehicle.engines=engines;
vehicle.curStage=1;
