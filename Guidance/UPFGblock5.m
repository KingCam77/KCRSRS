%%UPFG block 5

lambda_bar=unit(v_bar_go);

switch s_mode
  case {1,2,3,4,5}
    mode=1;
  case {6,7,8}
    mode=2;
end

if mode == 1
  r_bar_grav = ((t_go/t_prime_go)^2)*r_bar_grav;
  r_bar_go = r_bar_d - (r_bar + v_bar*t_go+r_bar_grav);
  i_bar_z = unit(cross(r_bar_d,i_bar_y));
  r_bar_goxy = r_bar_go - (dot(i_bar_z,r_bar_go))*i_bar_z;
  r_goz = (S - dot(lambda_bar,r_bar_goxy))/(dot(lambda_bar,i_bar_z));
  r_bar_go = r_bar_goxy+r_goz*i_bar_z+r_bar_bias;
  lambda_bar_dot = (r_bar_go - S*lambda_bar)/(Q-S*J/L);
else
  lambda_bar_dot = omega_f*unit(cross(cross(lambda_bar,r_bar),lambda_bar));
end

i_bar_f=unit(lambda_bar-(J/L)*lambda_bar_dot);
phi=acos(dot(i_bar_f,lambda_bar));
phi_dot=-phi*L/J;

v_bar_thrust = (L-0.5*L*phi^2-J*phi*phi_dot-0.5*H*phi_dot^2)*lambda_bar-(L*phi+J*phi_dot)*unit(lambda_bar_dot);
r_bar_thrust = (S-0.5*S*phi^2-Q*phi*phi_dot-0.5*P*phi_dot^2)*lambda_bar-(S*phi+Q*phi_dot)*unit(lambda_bar_dot);

v_bar_bias=v_bar_go-v_bar_thrust;
r_bar_bias=r_bar_go-r_bar_thrust;

clear mode
