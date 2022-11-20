%%UPFG block 8

r_bar_p=r_bar+v_bar*t_go+r_bar_grav+r_bar_thrust;

r_bar_p=r_bar_p-dot(r_bar_p,i_bar_y)*i_bar_y;
switch s_mode
  case {1, 3, 4, 5, 7, 8}
    switch s_mode
      case {1, 3, 4, 5}
        r_bar_d=r_d*unit(r_bar_p);
      case {7, 8}
        r_bar_d=r_bar_p;
      end
      if s_mode == 1
        i_bar_x=unit(r_bar_d);
        i_bar_z=cross(i_bar_x,i_bar_y);

        v_bar_d=v_d*( [i_bar_x; i_bar_y; i_bar_z]'*[sind(gamma_d); 0; cosd(gamma_d)])';
      else
      disp("ERROR - Launch mode unsupported, only standard ascent is avalible.")
      end
  case 2

  if t_b(k)<Deltat
    i_bar_N=unit(cross(r_bar_ref,v_bar_ref));
    n_rev=0;
    r_d=norm(r_bar_d);
    s_mode=3;

    [r_bar_t, ~, pre] = CSE(r_bar_ref, v_bar_ref, (t_t-t_ref), pre);
  else
    [r_bar_d, v_bar_d, pre] = CSE(r_bar_ref, v_bar_ref, (t+t_go-t_ref), pre);
    Deltar_z=dot(i_bar_z,(r_bar_d-r_bar_p));
    v_goz=dot(i_bar_z,v_bar_go);
    Deltat_go=-2*Deltar_z/v_goz;
    K(k)=(K(k)*t_b(k))/(t_b(k)+Deltat_go);

    if K(k)>K_max
      K(k)=K_max;
    endif
  end
end

v_bar_prime_go = v_bar_d-v_bar-v_bar_grav-v_bar_bias;
Deltav_bar_go = rho*(v_bar_prime_go-v_bar_go);
v_bar_go=v_bar_prime_go+Deltav_bar_go;






