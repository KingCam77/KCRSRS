%%UPFG block 7

Deltar_bar_c = -0.1*r_bar_thrust - (1/30)*v_bar_thrust*t_go;
Deltav_bar_c = (6/5)*r_bar_thrust/t_go - 0.1*v_bar_thrust;
r_bar_c1=r_bar+Deltar_bar_c;
v_bar_c1=v_bar+Deltav_bar_c;

[r_bar_c2, v_bar_c2, pre] = CSE(r_bar_c1, v_bar_c1, t_go, pre);


v_bar_grav = v_bar_c2-v_bar_c1;
r_bar_grav = r_bar_c2-r_bar_c1-v_bar_c1*t_go;
