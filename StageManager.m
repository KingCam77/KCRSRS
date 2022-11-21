function [vehicle, mass, area, ENG] = StageManager(vehicle, t, mass)

  n=length(vehicle.timings);
  timings=vehicle.timings;

  if timings(1,1) == -1
    SRB = 1;
  else
    SRB = 0;
  endif

  test = t > timings;

  sep=sum(test(1,:))+1;
  ign=sum(test(2,:))+1;

  stage=sep;

  if (sep == ign && sep ~= n+1)
    %Engine running normally
    ENG = 1;
  else
    ENG = -1;
  endif

  if (vehicle.curStage ~= stage && sep ~= n+1)
    mass = vehicle.stage(stage).mass;
    area = vehicle.stage(stage).area;
    vehicle.curStage=stage;
  elseif sep == n+1
    area = vehicle.stage(stage-1).area;
    mass=mass;
  else
    area = vehicle.stage(stage).area;
    mass=mass;
  endif
end
