function tank = TankCalc(volume, radius, ratio, n, tank)

  length=(volume-(4/3)*pi*radius^2*(radius*ratio))/(pi*radius^2);
  if length <=0
  shape ='Shrunk Capsule';
  radius=(volume/((4/3)*pi))^(1/3);
  length=(volume-(4/3)*pi*radius^2*(radius*ratio))/(pi*radius^2);
  else
  shape ='Capsule';
  end

  if nargin == 3
  n=1;
  end

  tank(n).shape=shape;
  tank(n).radius=radius;
  tank(n).length=length;
  tank(n).volume=volume;
  tank(n).stage=ceil(n/2);
end
