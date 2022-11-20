%%Steps
global AltStep
global MachStep
global mu_E
global Rstar
global G
global Cd
global AtmoProp
global LOXdensity
global LH2density
global Background
global r_E
global Pe_E

AltStep=50;
MachStep=0.1;

%%Consts
Rstar=8314.46261815324;   %J/(kmol-k)
G=9.80665;
a = -610:AltStep:1000000;
mu_E = (3.986004188*10^14);
r_E=6378137;
Pe_E=86164.09;

%%Temp by alt
  Ta = zeros (size (a));
  ind = a<=11000;
  Ta(ind) = 288.15-6.5*((a(ind))/1000);
  ind = a>11000 & a<=20000;
  Ta(ind) = 216.65-0*((a(ind)-11000)/1000);
  ind = a>20000 & a<=32000;
  Ta(ind) = 216.65+1*((a(ind)-20000)/1000);
  ind = a>32000 & a<=47000;
  Ta(ind) = 228.65+2.8*((a(ind)-32000)/1000);
  ind = a>47000 & a<=51000;
  Ta(ind) = 270.65+0*((a(ind)-47000)/1000);
  ind = a>51000 & a<=71000;
  Ta(ind) = 270.65-2.8*((a(ind)-51000)/1000);
  ind = a>71000 & a<=84852;
  Ta(ind) = 214.65-2*((a(ind)-71000)/1000);
  ind = a>84852;
  Ta(ind) = 186.87;

%%Pressure by alt
  Pa = zeros (size (a));
  ind = a<=11000;
  Pa(ind) = 101325*((288.15./(288.15-(6.5/1000)*(a(ind)))).^((G*0.0289644)/((Rstar/1000)*-(6.5/1000))));
  ind = a>11000 & a<=20000;
  Pa(ind) = 22632.06*exp((-G*0.0289644*(a(ind)-11000))/((Rstar/1000)*216.65));
  ind = a>20000 & a<=32000;
  Pa(ind) = 5474.889*((216.65./(216.65+(1/1000)*(a(ind)-20000))).^((G*0.0289644)/((Rstar/1000)*(1/1000))));
  ind = a>32000 & a<=47000;
  Pa(ind) = 868.0187*((228.65./(228.65+(2.8/1000)*(a(ind)-32000))).^((G*0.0289644)/((Rstar/1000)*(2.8/1000))));
  ind = a>47000 & a<=51000;
  Pa(ind) = 110.9063*exp((-G*0.0289644*(a(ind)-47000))/((Rstar/1000)*270.65));
  ind = a>51000 & a<=71000;
  Pa(ind) = 66.93887*((270.65./(270.65-(2.8/1000)*(a(ind)-51000))).^((G*0.0289644)/((Rstar/1000)*-(2.8/1000))));
  ind = a>71000 & a<=84852;
  Pa(ind) = 3.95642*((214.65./(214.65-(2/1000)*(a(ind)-71000))).^((G*0.0289644)/((Rstar/1000)*-(2/1000))));
  ind = a>84852;
  Pa(ind) = 0.3734*exp((-G*0.0289644*(a(ind)-84852))/((Rstar/1000)*186.87));

%%Speed of Sound by alt
C=sqrt(1.4*(Rstar/(0.0289645*1000))*273.15)*sqrt(1+(Ta-273.15)/274.15);

%%Air density by alt
RhoAir = Pa./(287.052.*(Ta));

%%Coeff of drag
M = 0:MachStep:10;
  Cd = zeros (size (M));
  ind = M>=0 & M<=0.6;
  Cd(ind) = 0.2083333*M(ind).^(2)-(0.25)*M(ind)+0.46;
  ind = M>0.6 & M<=0.8;
  Cd(ind) = 1.25*M(ind).^3-2.125*M(ind).^2+1.2*M(ind)+0.16;
  ind = M>0.8 & M<=0.95;
  Cd(ind) = 10.37037*M(ind).^3-22.88889*M(ind).^2+16.91111*M(ind)-3.78963;
  ind = M>0.95 & M<=1.05;
  Cd(ind) = -30*M(ind).^3+88.5*M(ind).^2-85.425*M(ind)+27.51375;
  ind = M>1.05 & M<=1.15;
  Cd(ind) = 10*M(ind).^3-40.5*M(ind).^2+53.475*M(ind)-22.41375;
  ind = M>1.15 & M<=1.3;
  Cd(ind) = 11.85185*M(ind).^3-44.88889*M(ind).^2+56.22222*M(ind)-22.58519;
  ind = M>1.3 & M<=2;
  Cd(ind) = -0.04373178*M(ind).^3+0.3236152*M(ind).^2-1.019679*M(ind)+1.554752;
  ind = M>2 & M<=3.25;
  Cd(ind) = 0.01024*M(ind).^3-0.00864*M(ind).^2-0.33832*M(ind)+1.08928;
  ind = M>3.25 & M<=4.5;
  Cd(ind) = -0.01408*M(ind).^3+0.19168*M(ind).^2-0.86976*M(ind)+1.53544;
  ind = M>4.5;
  Cd(ind) = 0.22;

%AtmoPropties(type,val)
AtmoProp(1,:)=a;
AtmoProp(2,:)=Pa;
AtmoProp(3,:)=RhoAir;
AtmoProp(4,:)=C;
AtmoProp(5,:)=Ta;

LOXdensity=1141;
LH2density=70.85;

%Sphere texture creator
%Make sure that your 0 long is at the vertical border. i.e. equirectangular focused on the pacific (180 W).
Filename='earth2.jpg';

Background=imread(Filename);
clear a Pa RhoAir C Ta ind M Filename
