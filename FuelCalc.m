%%FuelCalc
function tank = FuelCalc(fuel, ratio, fueltype, DiaM, Settings)

switch fueltype
  case 'LOX/LH2'
    OxDensity = MaterialLookup('LOX')
    FuelDensity = MaterialLookup('LH2')
end

if nargin < 5
  TankWallThickness=0;
  TankRatio=0.5;
else
  TankWallThickness=Settings.TankWallThickness;
  TankRatio=Settings.TankRatio;
end

OxAmount = fuel./ratio;
FuelAmount = fuel-OxAmount;

OxVol=OxAmount./OxDensity;
FuelVol=FuelAmount./FuelDensity;

TankR=DiaM/2-TankWallThickness;

n=length(fuel)

tank(1).shape=0;
i=1;
for i=1:n

tank = TankCalc(OxVol(i), TankR, TankRatio, 2*i-1, tank, 'Ox Tank')
tank = TankCalc(FuelVol(i), TankR, TankRatio, 2*i, tank, 'Fuel Tank')

end
end

function tank = TankCalc(volume, radius, ratio, n, tank, name)

  length=(volume-(4/3)*pi*radius^2*(radius*ratio))/(pi*radius^2);
  if length <=0
  shape ='Shrunk Capsule';
  radius=(volume/((4/3)*pi))^(1/3);
  length=(volume-(4/3)*pi*radius^2*(radius*ratio))/(pi*radius^2);
  else
  shape ='Capsule';
  end

  tank(n).shape=shape;
  tank(n).radius=radius;
  tank(n).length=length;
  tank(n).volume=volume;
  tank(n).stage=ceil(n/2)
  tank(n).name=name;
end

