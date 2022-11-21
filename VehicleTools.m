function Output = VehicleTools(Mode, Input1, Input2, Input3, Input4)

  switch Mode
    case 'Area'
      %%Rocket diameter, Booster Diameter array, Amount of Boosters array
      DiaM=Input1;
      if nargin < 4
      DiaB=0;
      Count=0;
      else
      DiaB=Input2;
      Count=Input3;
      end

      AreaM=pi*(DiaM/2)^2;
      AreaB=Count.*pi.*(DiaB./2).^2;
      AreaTotal=sum(AreaB)+AreaM;

      Output=AreaTotal;

    case 'MaxBurn'
      fuel=Input1;
      m_dot=Input2;

      Tburn=fuel/m_dot;

      Output=Tburn;
    case 'Mass'
      mass=Input1;
      stage=Input2;
      engines=Input3;
      lateSRBsep=Input4;

      engines_core=stage.engines;
      engines_core(1)=0;

      m_dot_core=sum(engines_core .* stage.throttle .* engines.m_dot);

    switch lateSRBsep
      case 'true'
        mass=mass.total-mass.fuel-m_dot_core*stage.time;
      case 'false'
        mass=mass.total-mass.boosters-m_dot_core*stage.time;
    end

      Output=mass;
  endswitch
end
