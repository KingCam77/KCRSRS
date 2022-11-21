function val = AtmoProp(alt, type)
global g0
global Rstar
  %1 = Pressure
  %2 = Air Density
  %3 = Speed Of Sound
  %4 = Temperature

if nargin < 2
  type = 5;
else
  type = type;
endif

i=1;
while i <= length(alt)

if (type == 2 || type == 4 || type == 5)
%%Temp by alt
if alt(i) <= 11000
  Ta= @(x) 288.15-6.5*(x/1000);
elseif alt(i)>11000 && alt(i)<=20000
  Ta= @(x) 216.65-0*((x-11000)/1000);
elseif alt(i)>20000 && alt(i)<=32000
  Ta= @(x) 216.65+1*((x-20000)/1000);
elseif alt(i)>32000 && alt(i)<=47000
  Ta= @(x) 228.65+2.8*((x-32000)/1000);
elseif alt(i)>47000 && alt(i)<=51000
  Ta= @(x) 270.65+0*((x-47000)/1000);
elseif alt(i)>51000 && alt(i)<=71000
  Ta= @(x) 270.65-2.8*((x-51000)/1000);
elseif alt(i)>71000 && alt(i)<=84852;
  Ta= @(x) 214.65-2*((x-71000)/1000);
elseif alt(i)>84852;
  Ta= @(x) 186.87+0;
end
Temperature(i)=Ta(alt(i));
end

if type ~= 4
%Pressure by alt
if alt(i) <= 11000
  Pa= @(x) 101325*((288.15./(288.15-(6.5/1000)*x)).^((g0*0.0289644)/((Rstar/1000)*-(6.5/1000))));
elseif alt(i)>11000 && alt(i)<=20000
  Pa= @(x) 22632.06*exp((-g0*0.0289644*(x-11000))/((Rstar/1000)*216.65));
elseif alt(i)>20000 && alt(i)<=32000
  Pa= @(x) 5474.889*((216.65./(216.65+(1/1000)*(x-20000))).^((g0*0.0289644)/((Rstar/1000)*(1/1000))));
elseif alt(i)>32000 && alt(i)<=47000
  Pa= @(x) 868.0187*((228.65./(228.65+(2.8/1000)*(x-32000))).^((g0*0.0289644)/((Rstar/1000)*(2.8/1000))));
elseif alt(i)>47000 && alt(i)<=51000
  Pa= @(x) 110.9063*exp((-g0*0.0289644*(x-47000))/((Rstar/1000)*270.65));
elseif alt(i)>51000 && alt(i)<=71000
  Pa= @(x) 66.93887*((270.65./(270.65-(2.8/1000)*(x-51000))).^((g0*0.0289644)/((Rstar/1000)*-(2.8/1000))));
elseif alt(i)>71000 && alt(i)<=84852;
  Pa= @(x) 3.95642*((214.65./(214.65-(2/1000)*(x-71000))).^((g0*0.0289644)/((Rstar/1000)*-(2/1000))));
elseif alt(i)>84852;
  Pa= @(x) 0.3734*exp((-g0*0.0289644*(x-84852))/((Rstar/1000)*186.87));
end
Pressure(i)=Pa(alt(i));
end


if (type == 2 || type == 5)
%%Air density by alt
RhoAir(i) = Pressure(i)/(287.052*(Temperature(i)));
end

if (type == 3 || type == 5)
%%Speed of Sound by alt
C(i)=sqrt(1.4*(Rstar/(0.0289645*1000))*273.15)*sqrt(1+(Pressure(i)-273.15)/274.15);
end

i=i+1;
end

if type == 1
val=[Pressure];
elseif type == 2
val=[RhoAir];
elseif type == 3
val=[C];
elseif type == 4
val=[Temperature];
elseif type == 5
val=[Pressure; RhoAir; C; Temperature];
end

end
