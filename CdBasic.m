function val = CdBasic(mach)
%%Basic Coefficient of drag piecewise

if mach>=0 && mach<=0.6
Cd = @(x) 0.2083333*x^(2)-(0.25)*x+0.46;
elseif mach>0.6 && mach<=0.8;
Cd = @(x) 0.2083333*x^(2)-(0.25)*x+0.46;
elseif mach>0.6 && mach<=0.8;
Cd = @(x) 1.25*x^3-2.125*x^2+1.2*x+0.16;
elseif mach>0.8 && mach<=0.95;
Cd = @(x) 10.37037*x^3-22.88889*x^2+16.91111*x-3.78963;
elseif mach>0.95 && mach<=1.05;
Cd = @(x) -30*x^3+88.5*x^2-85.425*x+27.51375;
elseif mach>1.05 && mach<=1.15;
Cd = @(x) 10*x^3-40.5*x^2+53.475*x-22.41375;
elseif mach>1.15 && mach<=1.3;
Cd = @(x) 11.85185*x^3-44.88889*x^2+56.22222*x-22.58519;
elseif mach>1.3 && mach<=2;
Cd = @(x) -0.04373178*x^3+0.3236152*x^2-1.019679*x+1.554752;
elseif mach>2 && mach<=3.25;
Cd = @(x) 0.01024*x^3-0.00864*x^2-0.33832*x+1.08928;
elseif mach>3.25 && mach<=4.5;
Cd = @(x) -0.01408*x^3+0.19168*x^2-0.86976*x+1.53544;
elseif mach>4.5;
Cd = @(x) 0.22;
end
val=Cd(mach);
end
