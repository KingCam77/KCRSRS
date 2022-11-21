%%Steps
global MachStep
global mu_E
global Rstar
global G
global g0
global Cd
global LOXdensity
global LH2density
global Background
global r_E
global Pe_E

MachStep=0.1;

%%Consts
Rstar=8314.46261815324;   %J/(kmol-k)
G=9.80665;
g0=9.80665; %%G needs to be phased out with g0
mu_E =398600441800000;
r_E=6378137;
Pe_E=86164.09;

%Sphere texture creator
%Make sure that your 0 long is at the vertical border. i.e. equirectangular focused on the pacific (180 W).
Filename='earth2.jpg';

Background=imread(Filename);
clear a Pa RhoAir C Ta ind M Filename
