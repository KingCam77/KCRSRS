%%%Input Variables
  %%Prethrust Call Only - All Modes
if start == 1
s_pre=1;  %Pre thrust switch,
           %1 = prethrust
           %0 = active guidance
s_mode=1; %Maneuver Mode
           %1 = Ascent, standard
           %2 = Ascent, reference trajectory
           %3 = Ascent, Lambert
           %4 = Ascent, once-around abort
           %5 = Ascent, return-to-launch-site abort
           %6 = On-orbit, external DeltaV
           %7 = On-orbit, Lambert
           %8 = On-orbit, deorbit
n=rocket.n;     %Number of thrust phases
t_ig=rocket.t_ig;  %Ignition time, first phase

  %State Vector
t=0;         %Time
r_bar=rocket.r_bar; %Vehicle position vector
v_bar=rocket.v_bar; %Vehicle velocity vector

  %Number of engines for i th phase
s_AElower=rocket.s_AElower;
s_AEupper=rocket.s_AEupper;

s_phase=[0,0]; %Phase switch for i th phase
                                   %0 = Constant thrust
                                   %1 = Constant acceleration

v_bar_go=rocket.v_bar_go;       %Estimated velocity-to-be-gained vector

m_0(1)=rocket.mass(1).Total;      %Mass at beginning of phase i
m_0(2)=rocket.mass(2).Total;
m_0(3)=rocket.mass(3).Total;

  %%Active Guidance Call - All Modes

%%%Program Constants

epsilon_cone=0.00001;  %Lambert required sine of half cone angle of exclusion
epsilon_vgo=0.00001;   %Value of |DeltaV_go| defining prethrust convergence limit

Deltat_t0=rocket.Deltat_t0;            %Time interval before t_ig to start active guidance calls
deltat=rocket.deltat;                     %Offset in coast time used in deorbit required velocity computations to determine sensitivity to coast time
Deltat_cutoff=rocket.Deltat_cutoff;   %Value of t_go used to define time to issue engine cutoff command and terminate active steering computations
S_pert=1;                 %Gravity perturbation switch

%%%Universal Constants
mu=(3.986004188*10^14);   %Gravitational constant

%Full thrust of single engine
f_AElower=rocket.engines(1).thrust(100,200);
f_AEupper=rocket.engines(2).thrust(100,10000);

K_max=100/100;   %Maximum throttle setting of SSME

%Mass flow rate of single engine at full thrust
m_dot_AElower=rocket.engines(1).m_dot(100);
m_dot_AEupper=rocket.engines(2).m_dot(100);

K=rocket.K/100;
a_L=100000;

%%%%CODE START
UPFGcycle=0;

t_go_prime=0;

pre.Deltat_prime_c=0;
pre.x_prime_c=0;
pre.A=0;
pre.D=0;
pre.E=0;

i_bar_y=target.i_bar_y;
r_d=target.r_d;
v_d=target.v_d;
gamma_d=target.gamma_d;
start=0;
end

skip=0;
s_pre;
UPFGcycle=0;
if s_pre > 0
  UPFGblock1
else
  UPFGblock2
  if t<t_ig || s_engoff == 1
    skip=1;
  endif
end

if skip ~= 1

while UPFGcycle < 100
  UPFGblock3
  UPFGblock4
  UPFGblock5
#  UPFGblock6   %Unnecessary due to nature of simulation
if s_mode ~= 6
  UPFGblock7
  UPFGblock8
endif
#  UPFGblock9   %Unnecessary due to nature of simulation

++UPFGcycle;
Dt_record(UPFGcycle)=abs((t_prime_go-t_go)/t_prime_go);
  if abs((t_prime_go-t_go)/t_prime_go) < epsilon_vgo || s_pre == 0
    s_pre=0;
    if abs((t_prime_go-t_go)/t_prime_go) < epsilon_vgo
    converged=UPFGcycle
    end
    break;
  end
end
end
skip=0;




##UPFG.a_L
##UPFG.a_T
##UPFG.C_1
##UPFG.C_2
##UPFG.C_1c
##UPFG.t_AElower
##UPFG.t_AEupper
##UPFG.i_T
##UPFG.i_bar
##UPFG.H
##UPFG.H_i
##UPFG.i_bar_f
##UPFG.i_bar_x
##UPFG.i_bar_y
##UPFG.i_bar_z
##UPFG.i_bar_N
##UPFG.i_bar_rt
##UPFG.J
##UPFG.J_i
##UPFG.K
##UPFG.K_max
##UPFG.k
##UPFG.L
##UPFG.L_i
##UPFG.m
##UPFG.m_0
##UPFG.m_dot_AElower
##UPFG.m_dot_AEupper
##UPFG.m_dot
##UPFG.n
##UPFG.n_rev
##UPFG.P
##UPFG.P_i
##UPFG.Q
##UPFG.Q_i
##UPFG.r_bar
##UPFG.r_bar_bias
##UPFG.r_bar_c1
##UPFG.r_bar_c2
##UPFG.r_bar_d
##UPFG.r_d
##UPFG.r_bar_go
##UPFG.r_bar_goxy
##UPFG.r_goz
##UPFG.r_bar_grav
##UPFG.r_bar_p
##UPFG.r_bar_ref
##UPFG.r_bar_t
##UPFG.r_bar_tef
##UPFG.r_bar_thrust
##UPFG.S
##UPFG.s_engoff
##UPFG.s_guess
##UPFG.S_i
##UPFG.s_mode
##UPFG.s_pass1
##UPFG.s_pert
##UPFG.s_phase
##UPFG.s_pre
##UPFG.s_proj
##UPFG.s_soln
##UPFG.s_AElower
##UPFG.s_AEupper
##UPFG.t
##UPFG.t_b
##UPFG.t_c
##UPFG.t_ref
##UPFG.t_go
##UPFG.t_prime_go
##UPFG.t_go_i
##UPFG.t_go0
##UPFG.t_ig
##UPFG.t_prev
##UPFG.t_t
##UPFG.u
##UPFG.v_bar
##UPFG.v_bar_bias
##UPFG.v_bar_c1
##UPFG.v_bar_c2
##UPFG.v_bar_d
##UPFG.v_d
##UPFG.v_bar_prime_d
##UPFG.v_ex
##UPFG.v_bar_go
##UPFG.v_goz
##UPFG.v_bar_prime_go
##UPFG.v_bar_grav
##UPFG.v_bar_ref
##UPFG.v_bar_t
##UPFG.v_bar_prime_t
##UPFG.v_bar_th
##UPFG.v_bar_prime_th
##UPFG.v_bar_thrust
##UPFG.v_bar_tv
##UPFG.v_bar_prime_tv
##UPFG.gamma_d
##UPFG.Deltar_bar_c
##UPFG.Deltar_z
##UPFG.Deltat
##UPFG.Deltat_cutoff
##UPFG.Deltat_go
##UPFG.Deltat_to
##UPFG.Deltav_bar_c
##UPFG.Deltav_bar_go
##UPFG.Deltav_bar_sensed
##UPFG.Deltav_OMS
##UPFG.deltat
##UPFG.epsilon_cone
##UPFG.epsilon_vgo
##UPFG.lambda_bar
##UPFG.lambda_bar_dot
##UPFG.rho
##UPFG.sigma
##UPFG.tau
##UPFG.phi
##UPFG.phi_dot
##UPFG.omega_f



















