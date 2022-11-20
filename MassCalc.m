function Mass = MassCalc(Fuel,Extra,Percent,Payload)
n=length(Fuel)+1;

Mass(n).fuel=0;
Mass(n).extra=0;
Mass(n).tankWeight=0;
Mass(n).payload=Payload;
Mass(n).total=Payload;


i=n-1
while i > 0
Mass(i).fuel=Fuel(i);
Mass(i).extra=Extra(i);
Mass(i).tankWeight=Fuel(i)*Percent(i);
Mass(i).payload=Mass(i+1).Total;
Mass(i).total=Mass(i).fuel+Mass(i).extra+Mass(i).tankWeight+Mass(i).payload;
--i;
end
end
