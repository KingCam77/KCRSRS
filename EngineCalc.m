function [Engine] = EngineCalc(Pc,q,DAlt,Ratio,ThetaTc,ThrustMin,CorFac, n, Engine)
%%engine calculator
global AltStep;
global Rstar;
global G;
global AtmoProp;



Lstar=0.9;       %Chamber Characteristic Length (m) between 0.76 and 1.02



%Pressure at design altitude
DPa= AtmoProp(2,round((DAlt/AltStep)+1));


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

Veff = Ve + (((Pe-AtmoProp(2,:))*Ae)/q);

F = q*Ve+(Pe-AtmoProp(2,:))*Ae;

ind = F <= 0;
F(ind) = 0;

Lc = (exp(0.029*log(Rt*200)^2+0.47*log(Rt*200)+1.94)/100);

Vc = Lstar*At;

Isp = Veff/G;
++x;
end

qT=linspace(0,q,100)';

t=1:100;
PcT(t,1)=100000;
TeT(t,1)=Te;
VeT(t,1)=Ve;

t=1;
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

TeT(t,:) = Tc(t,:)/(1+((k(t,:)-1)/2)*(MeT(t,:)^2));

VeT(t,:) = sqrt(((2*k(t,:))/(k(t,:)-1))*((Rstar*Tc(t,:))./(MolM(t,:)))*(1-(PeT(t,:)./PcT(t,:)).^((k(t,:)-1)/k(t,:)))); %Velocity at exit

VeffT(t,:) = VeT(t,:) + ((PeT(t,:)-AtmoProp(2,:))*(Ae./qT(t,:)));

FT(t,:) = qT(t,:).*VeT(t,:)+(PeT(t,:)-AtmoProp(2,:))*Ae;

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
IspT(ind)=0;

qfinal=qT;
qfinal(x,:)=0;

Ffinal=CorFac.*FT;
Ispfinal=CorFac.*IspT;



if nargin == 7
  n=1;
end

if Ffinal(100,13) == 0
%%Vaccum Engine, use vaccum properties for asl
Engine.thrust_asl(n)=Ffinal(100,20000);
Engine.isp_vac(n)=Ispfinal(100,20000);
Engine.isp_asl(n)=Ispfinal(100,20000);
else
Engine.thrust_asl(n)=Ffinal(100,13);
Engine.isp_vac(n)=Ispfinal(100,20000);
Engine.isp_asl(n)=Ispfinal(100,13);
end

Engine.m_dot(n)=qfinal(100);
endfunction
