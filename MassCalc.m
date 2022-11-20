function Mass = MassCalc(Fuel,Extra,Percent,Payload)
n=length(Fuel)+1;

Mass(n).Fuel=0;
Mass(n).Extra=0;
Mass(n).TankWeight=0;
Mass(n).Payload=Payload;
Mass(n).Total=Payload;


i=n-1
while i > 0
Mass(i).Fuel=Fuel(i);
Mass(i).Extra=Extra(i);
Mass(i).TankWeight=Fuel(i)*Percent(i);
Mass(i).Payload=Mass(i+1).Total;
Mass(i).Total=Mass(i).Fuel+Mass(i).Extra+Mass(i).TankWeight+Mass(i).Payload;
--i;
end
end
