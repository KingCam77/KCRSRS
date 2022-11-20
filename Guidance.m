dT=10;
Start
if Start == 1
A1=0.1;
B1=0.1;
T2=600;
T1=290;
R(T1)=200000+(6.3781*10^6);
T0=1;
Omega(T1)=1000/R(T1);
PegCall=1
Start=0;
else
A1=A1+B1*dT;
T1=T1-dT;
PegCall=PegCall+1
end
%use stage 3 (payload) for variables that are not stage dependent
%but are position dependent.


T=T1+T2;

Ve1=Isp1(Throttle,fix((CalcAlt(1,x)/AltStep))+1)*G;
#Ve2=Isp2(100,fix((R(T1)-(6.3781*10^6))/AltStep)+1)*G;
Ve2=3646.7;

R(T0)=DistEarth(3,x);
Rdot(T0)=Vrr(3,x);

Accel1(T0)=Accelraw(1,x);
Accel2(T0)=Accelraw(2,x);

Tau1=Ve1/Accel1(T0);
Tau2=Ve2/Accel2(T0);

Accel1(T1)=Accel1(T0)/(1-T1/Tau1);
Accel2(T2)=Accel2(T0)/(1-T1/Tau2);

Omega(T0)=Vrt(3,x)/DistEarth(3,x);

%%Rocket Equations

b01(T1)=-Ve1*log(1-T1/Tau1);
b11(T1)=b01(T1)*Tau1-Ve1*T1;
b21(T1)=b11(T1)*Tau1-(Ve1*T1^2)/2;

c01(T1)=b01(T1)*T1-b11(T1);
c11(T1)=c01(T1)*Tau1-(Ve1*T1^2)/2;

b02(T2)=-Ve2*log(1-T2/Tau2);
b12(T2)=b02(T2)*Tau2-Ve2*T2;
b22(T2)=b12(T2)*Tau2-(Ve2*T2^2)/2;

c02(T2)=b02(T2)*T2-b12(T2);
c12(T2)=c02(T2)*Tau2-(Ve2*T2^2)/2;



%%Vertical State at staging
Rdot(T1)=Rdot(T0)+b01(T1)*A1+b11(T1)*B1;
R(T1)=R(T0)+Rdot(T0)*T1+c01(T1)*A1+c11(T1)*B1;

R(T)=Target;

Rdot(T)=0;

Vtheta(T)=sqrt(GravMu/R(T));

%Current required pitch
Fr1(T0)=A1+((GravMu/(R(T0)^2))-(Omega(T0)^2*R(T0)))/Accel1(T0);

%Horizontal state at staging
i=1;
while i<=5
Fr1(T1)=A1+B1*T1+((GravMu/(R(T1)^2))-(Omega(T1)^2*R(T1)))/Accel1(T1);

FrDot1=(Fr1(T1)-Fr1(T0))/T1;

Ftheta1=1-Fr1(T1)^2/2;
FthetaDot1=-Fr1(T1)*FrDot1;
FthetaDDot1=FrDot1^2/2;

H(T1)=((R(T0)+R(T1))/2)*(Ftheta1*b01(T1)+FthetaDot1*b11(T1)+FthetaDDot1*b21(T1));

Vtheta(T1)=H(T1)/R(T1);

Omega(T1)=Vtheta(T1)/R(T1);
++i;
end

%Guidance Staging Discontinuites
dA=(GravMu/(R(T1)^2)-Omega(T1)^2*R(T1))*((1/Accel1(T1))-(1/Accel2(T0)));
dB=-(GravMu/(R(T1)^2)-Omega(T1)^2*R(T1))*(1/Ve1-1/Ve2)+(3*Omega(T1)^2-(2*GravMu)/(R(T1)^3))*Rdot(T1)*((1/Accel1(T1))-(1/Accel2(T0)));

%Solve Guidance Equations
matA=[b01(T1)+b02(T2), b11(T1)+b12(T2)+b02(T2)*T1; c01(T1)+c02(T2)+b01(T1)*T2, c11(T1)+b11(T1)*T2+c02(T2)*T1+c12(T2)];
matB=[Rdot(T)-Rdot(T0)-b02(T2)*dA-b12(T2)*dB; R(T)-R(T0)-Rdot(T0)*(T1+T2)-c02(T2)*dA-c12(T2)*dB];

matX=matA\matB;
A1=matX(1);
B1=matX(2);

%Estimate Stage 2 T2

A2=dA+A1+B1*T1;
B2=dB+B1;

H(T1)=R(T1)*Vtheta(T1);
H(T)=R(T)*Vtheta(T);
dH=H(T)-H(T1);

Rbar=(R(T)+R(T1))/2;

C2(T0)=((GravMu/(R(T1)^2)-Omega(T1)^2*R(T1))/Accel2(T0));

Fr2(T0)=A2+C2(T0);

Omega(T)=Vtheta(T)/R(T);

C2(T)=((GravMu/(R(T)^2)-Omega(T)^2*R(T))/Accel2(T2));

Fr2(T)=A2+B2*T2+C2(T);

FrDot2=(Fr2(T)-Fr2(T0))/T2;

Ftheta2=1-(Fr2(T0)^2)/2;

FthetaDot2=-Fr2(T0)*FrDot2;

FthetaDDot2=-(FthetaDot2^2)/2;

dV=(dH/Rbar+Ve2*T2*(FthetaDot2+FthetaDDot2*Tau2)+(FthetaDDot2*Ve2*T2^2)/2)/(Ftheta2+FthetaDot2*Tau2+FthetaDDot2*Tau2^2);

T2=Tau2*(1-exp(-dV/Ve2));

b01(T1)
b11(T1)
b21(T1)
c01(T1)
c11(T1)
Accel1(T1)






