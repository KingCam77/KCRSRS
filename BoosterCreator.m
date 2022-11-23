function boosters = BoosterCreator(engines, enginevars, massvars)
%%Booster Creator
  %%Engines is used engine structure passed in.
  %%Engine vars is structure with engines per booster type, fuel, ectra.
      %example [1, 2;
      %         0, 1];
      %This creates two boosters, one with three engines (1 first and 2 second)
      %and one with only one engine (second engine type)
  %%Mass vars is structure with mass variables.

extra=massvars.extra;
percent=massvars.percent;
engine=enginevars.engine;
fuel=enginevars.fuel;
throttle=enginevars.throttle;

[n, ~] = size(engine);

for i=1:n
boosters(i).engines=engine(i,:);
boosters(i).throttle=throttle(i,:);
boosters(i).m_dot=sum(boosters(i).engines .* boosters(i).throttle .* engines.m_dot);

mass(i).fuel=fuel(i);
mass(i).extra=extra(i);
mass(i).tankWeight=fuel(i)*percent(i);
mass(i).total=mass(i).fuel+mass(i).extra+mass(i).tankWeight;

boosters(i).mass=mass(i).total;
boosters(i).t_burn=fuel(i)/boosters(i).m_dot;
end

end




