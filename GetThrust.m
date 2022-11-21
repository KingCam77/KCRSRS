%%Get Real Thrust
function [thrust, m_dot] = GetThrust(Vehicle, alt, ENG)
  global g0
%%Simple for now, doesnt handle current srbs.

if nargin == 2
  ENG = 1;
end


  engines=Vehicle.engines;
  stage=Vehicle.stage(Vehicle.curStage);

  Pa=AtmoProp(alt,1);

  q=engines.m_dot;
  Ve=engines.ve;
  Ae=engines.ae;
  Pe=engines.pe;

  F=q.*Ve+(Pe-Pa).*Ae;

  ind = F <= 0;
  F(ind) = 0;

  engine=stage.engines;
  throttle=stage.throttle;

  thrust=sum(F.*engine.*throttle);
  m_dot=sum(q.*engine.*throttle);

  switch ENG
    case 1
      thrust = thrust;
      m_dot = m_dot;
    case -1
      thrust = 0;
      m_dot = 0;
  endswitch
end

