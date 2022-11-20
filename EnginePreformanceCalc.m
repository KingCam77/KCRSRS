
%%engine calculator

%%Steps
AltStep=50;
MachStep=0.1;

%%Consts
Rstar=8314.46261815324;   %J/(kmol-k)
G=9.80665;
a = -610:AltStep:1000000;
%%Ta
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

%%Pa
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

RhoAir = Pa./(287.052.*(Ta));

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

C=sqrt(1.4*(Rstar/(0.0289645*1000))*273.15)*sqrt(1+(Ta-273.15)/274.15);


%PARAMETERS


manual=1 %set to 1 if not using as a function
if manual==1
%Correction Factor from comparison
CorFac = 0.925
#CorFac = 0.95

%Engine Design Parameters
Pc = 4700000   %Chamber Pressure (Pa)
q = 35         %Mass Flow Rate (Kg/s)
DAlt = 33500    %Design Altitude  (m)
Lstar= 0.9       %Chamber Characteristic Length (m) between 0.76 and 1.02
ThrustMin= 60    %Minimum throttle percent
Ratio= 6        %Fuel/Oxidizer Ratio

%Nozzle Drawing Parameters
  %Use graph for angles of nozzle and exit
ThetaTn = 32  %Angle Throat Nozzle
ThetaNe = 6   %Angle Nozzle Exit
ThetaTc = 25  %Angle Throat Chamber (20 to 45)
P=85          %Bell Length Percent (60 to 90)
else
%Defaults
Lstar=0.9       %Chamber Characteristic Length (m) between 0.76 and 1.02
end




%Pressure at design altitude
DPa= Pa(round((DAlt/AltStep)+1));


%Molar Mass of exhaust by pressure for fuel ratio of 5
if Ratio == 5
%Molar Mass of exhaust by pressure for fuel ratio of 5
MolM = 0.0981384*log(Pc/100000)-0.000057243*(Pc/100000)+11.3962;
%Temp by Pressure for fuel ratio of 5
Tc = 97.6379*log(Pc/100000)+0.0000114766*(Pc/100000)^2-0.0833152*(Pc/100000)+2828.18+71.5598*exp(-0.00581091*(Pc/100000));
%Density by Pressure for fuel ratio of 5
Rho = 0.202976*log((Pc+123.66)/100000)+0.0415696*(Pc/100000)-0.957844;
%Gamma by Pressure for fuel ratio of 5
k = 0.00845456*log((Pc+0.152704)/100000)-0.00000194907*(Pc/100000)+1.12222;
else
%Temp by Pressure for fuel ratio of 6
Tc = 110.969*log(Pc/100000)+0.00000711231*(Pc/100000)^2-0.0534963*(Pc/100000)+3017.7-31.5868*exp(-0.0748538*(Pc/100000));
%Molar Mass of exhaust by pressure for fuel ratio of 6
MolM = 0.147224*log(Pc/100000)-0.0000381131*(Pc/100000)+12.836;
%Density by Pressure for fuel ratio of 6
Rho = 0.496611*log((Pc+158.067)/100000)+0.0434143*(Pc/100000)-2.49283;
%Gamma by Pressure for fuel ratio of 6
k = 0.00648722*log((Pc+0.173371)/100000)+1.11278;
end

Van=sqrt(k*((1+k)/2)^((1+k)/(1-k)));

R=Rstar/MolM;



x=1;
while x<=1

Me = sqrt((2/(k-1))*(((Pc/DPa)^((k-1)/k))-1)); %Mach at exit

#Me = Ve/sqrt(k*R*Te);

#Pe = Pc/((1+((k-1)/2)*Me^2)^(k/(k-1)));  %Pressure at exit

Pe = DPa;

Ve = CorFac*sqrt(((2*k)/(k-1))*(R*Tc)*(1-(Pe/Pc)^((k-1)/k))); %Velocity at exit

Pt = Pc*(1+((k-1)/2))^(-k/(k-1)); %Pressure at throat

Tt = Tc/(1+((k-1)/2));  %Temperature at throat

Te = Tc/(1+((k-1)/2)*(Me^2));  %Temperature at exit

At = (q/Pt)*sqrt((Rstar*Tt)/(MolM*k));  %Area at throat

Ae = (At/Me)*(((1+((k-1)/2)*(Me^2))/((k+1)/2))^((k+1)/(2*(k-1)))); %area at exit

Rt = sqrt(At/pi);

Re = sqrt(Ae/pi);

Veff = Ve + (((Pe-Pa)*Ae)/q);

F = q*Ve+(Pe-Pa)*Ae;

ind = F <= 0;
F(ind) = 0;

Lc = (exp(0.029*log(Rt*200)^2+0.47*log(Rt*200)+1.94)/100);

Vc = Lstar*At;

Isp = Veff/G;
++x;
end


x=1
Rc=1;
while x<=10
Rc = sqrt(((2*Rt)^3+(24/pi)*tand(ThetaTc)*Vc)/((2*Rc)+6*tand(ThetaTc)*Lc))/2;

++x;
end

Rc


qT=linspace(0,q,100)';

t=1:100;
PcT(t,1)=100000;
TeT(t,1)=Te;
VeT(t,1)=Ve;

t=1
while t<=100
x=1;
while x<=10

if Ratio == 5
%Molar Mass of exhaust by pressure for fuel ratio of 5
MolM(t,:) = 0.0981384*log(PcT(t,:)/100000)-0.000057243*(PcT(t,:)/100000)+11.3962;
%Temp by Pressure for fuel ratio of 5
Tc(t,:) = 97.6379*log(PcT(t,:)/100000)+0.0000114766*(PcT(t,:)/100000)^2-0.0833152*(PcT(t,:)/100000)+2828.18+71.5598*exp(-0.00581091*(PcT(t,:)/100000));
%Density by Pressure for fuel ratio of 5
Rho(t,:) = 0.202976*log((PcT(t,:)+123.66)/100000)+0.0415696*(PcT(t,:)/100000)-0.957844;
%Gamma by Pressure for fuel ratio of 5
k(t,:) = 0.00845456*log((PcT(t,:)+0.152704)/100000)-0.00000194907*(PcT(t,:)/100000)+1.12222;
else
%Temp by Pressure for fuel ratio of 6
Tc(t,:) = 110.969*log(PcT(t,:)/100000)+0.00000711231*(PcT(t,:)/100000)^2-0.0534963*(PcT(t,:)/100000)+3017.7-31.5868*exp(-0.0748538*(PcT(t,:)/100000));
%Molar Mass of exhaust by pressure for fuel ratio of 6
MolM(t,:) = 0.147224*log(PcT(t,:)/100000)-0.0000381131*(PcT(t,:)/100000)+12.836;
%Density by Pressure for fuel ratio of 6
Rho(t,:) = 0.496611*log((PcT(t,:)+158.067)/100000)+0.0434143*(PcT(t,:)/100000)-2.49283;
%Gamma by Pressure for fuel ratio of 6
k(t,:) = 0.00648722*log((PcT(t,:)+0.173371)/100000)+1.11278;
end


Van(t,:)=sqrt(k(t,:)*((1+k(t,:))/2)^((1+k(t,:))/(1-k(t,:))));

R(t,:)=(Rstar)./MolM(t,:);

PcT(t,:) = (qT(t,:).*sqrt(R(t,:)*Tc(t,:))/(At*Van(t,:)));

MeT(t,:) = (VeT(t,:)/sqrt(k(t,:)*R(t,:)*TeT(t,:)));

PeT(t,:) = PcT(t,:)/((1+((k(t,:)-1)/2)*MeT(t,:)^2)^(k(t,:)/(k(t,:)-1)));

#MeT(t,:) = sqrt((2/(k(t,:)-1)).*(((PcT(t,:)./Pa).^((k(t,:)-1)/k(t,:)))-1)); %Mach at exit

#PeT(t,:) = PcT(t,:)./((1+((k(t,:)-1)/2).*(MeT(t,:).^2)).^(k(t,:)./(k(t,:)-1)));  %Pressure at exit

TeT(t,:) = Tc(t,:)/(1+((k(t,:)-1)/2)*(MeT(t,:)^2));

VeT(t,:) = sqrt(((2*k(t,:))/(k(t,:)-1))*((Rstar*Tc(t,:))./(MolM(t,:)))*(1-(PeT(t,:)./PcT(t,:)).^((k(t,:)-1)/k(t,:)))); %Velocity at exit

VeffT(t,:) = VeT(t,:) + ((PeT(t,:)-Pa)*(Ae./qT(t,:)));

FT(t,:) = qT(t,:).*VeT(t,:)+(PeT(t,:)-Pa)*Ae;

IspT(t,:) = VeffT(t,:)/G;

++x;
end
++t;
end

x=1:1:ThrustMin;

FT(x,:)=0;
IspT(x,:)=0;

ind = FT < 0;
FT(ind)=0;
ind = IspT < 0;
IspT(ind)=0;

qfinal(x,:)=0;

Ffinal=CorFac.*FT;
Ispfinal=CorFac.*IspT;

if manual==1
%Engine drawing calcs
t=linspace(0,1,100);

ExpR = Ae/At

Ey=Re;
Ex=(P/100)*(((sqrt(ExpR)-1)*Rt)/(tand(15)));

Nx=0.382*Rt*cosd(ThetaTn-90);
Ny=0.382*Rt*sind(ThetaTn-90)+0.382*Rt+Rt;

C1=Ny-tand(ThetaTn)*Nx;
C2=Ey-tand(ThetaNe)*Ex;

Qx=(C2-C1)/(tand(ThetaTn)-tand(ThetaNe));
Qy=((tand(ThetaTn)*C2)-(tand(ThetaNe)*C1))/(tand(ThetaTn)-tand(ThetaNe));

Bx=(1-t).^2*Nx+2*(1-t).*t*Qx+(t.^2)*Ex;
By=(1-t).^2*Ny+2*(1-t).*t*Qy+(t.^2)*Ey;

t=linspace(270,(270+ThetaTn),100);

Tc1x = (0.382*Rt)*cosd(t);
Tc1y = (1.382*Rt)+(0.382*Rt)*sind(t);

t=linspace((270-ThetaTc),270,100);

Tc2x = (1.5*Rt)*cosd(t);
Tc2y = (2.5*Rt)+(1.5*Rt)*sind(t);

t=linspace(0,(Rc-(2.5*Rt)-(1.5*Rt)*sind(270-ThetaTc))/tand(ThetaTc),100);

Cl1x = (1.5*Rt)*cosd(270-ThetaTc)-t;
Cl1y = (2.5*Rt)+(1.5*Rt)*sind(270-ThetaTc)+t*tand(ThetaTc);

t=linspace(0,Lc,100);

Cl2x = (1.5*Rt)*cosd(270-ThetaTc)-(Rc-(2.5*Rt)-(1.5*Rt)*sind(270-ThetaTc))/tand(ThetaTc)-t;
Cl2y = Rc+0*t;

t=linspace(0,2*Rc,100);

Cl3x = (1.5*Rt)*cosd(270-ThetaTc)-(Rc-(2.5*Rt)-(1.5*Rt)*sind(270-ThetaTc))/tand(ThetaTc)-Lc+0*t;
Cl3y = Rc-t;

subplot(2,3,[1,2,4,5])
plot(Bx,By,'-k',Tc1x,Tc1y,'-k',Tc2x,Tc2y,'-k',Cl1x,Cl1y,'-k',Cl2x,Cl2y,'-k')
hold on
plot(Bx,-By,'-k',Tc1x,-Tc1y,'-k',Tc2x,-Tc2y,'-k',Cl1x,-Cl1y,'-k',Cl2x,-Cl2y,'-k')
plot(Cl3x,Cl3y,'-k')
hold off
title('Cross Sectional View Of Rocket Engine')
axis('equal')


%Var Trim and plots
ind = a<300000;
FfinalTrim = Ffinal(:,ind);
IspfinalTrim = Ispfinal(:,ind);

aTrim = a(ind);

subplot(2,3,3)
plot(aTrim,FfinalTrim(60,:),aTrim,FfinalTrim(80,:),aTrim,FfinalTrim(100,:))
title('Thrust')
xlabel('Altitude (m)')
ylabel('Thrust (n)')
subplot(2,3,6)
plot(aTrim,IspfinalTrim(60,:),aTrim,IspfinalTrim(80,:),aTrim,IspfinalTrim(100,:))
title('Isp')
xlabel('Altitude (m)')
ylabel('Isp (s)')
axis([0, 300000, 0, 500])
grid on
end
