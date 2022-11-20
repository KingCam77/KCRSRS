function [r_bar_future, v_bar_future, g_bar_future] = PowFNav(r_bar, v_bar, Deltat, Deltav_bar_meas, g_bar)
  %%Powered Flight Navigation Routine
  %couldnt find the exact document online but this has the same inputs and outputs

  %%Program Consts
  mu=(3.986004188*10^14);
  J_2=0.01467;
  r_E=6378137;
  i_bar_pole=[0,0,1];


  r_bar_future=r_bar+Deltat*(v_bar+(Deltat/2)*g_bar+(Deltav_bar_meas/2));

  i_bar_r=unit(r_bar_future);
  r=norm(r_bar_future);
  cosphi=dot(i_bar_r,i_bar_pole);

  g_bar_future=(-mu/r^2)*(i_bar_r+(3/2)*J_2*((r_E/r)^2)*((1-5*cosphi^2)*i_bar_r+2*cosphi*i_bar_pole));

  v_bar_future=v_bar+(Deltat/2)*(g_bar_future+g_bar)+Deltav_bar_meas;
end
