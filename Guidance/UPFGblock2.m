%%UPFG block 2

%%Data in
Deltav_bar_sensed=data.Deltav_bar_sensed;
t=data.t;



Deltat=t-t_prev;
t_prev=t;

if s_pass1==1
  Deltav_bar_sensed=[0,0,0];
  s_pass1=0;
else
  v_bar_go=v_bar_go-Deltav_bar_sensed;
end

#[r_bar, v_bar, g_bar] = PowFNav(r_bar, v_bar, Deltat, Deltav_bar_sensed, g_bar);

r_bar=Pr_bar;
v_bar=Pv_bar;
g_bar=Pg_bar;

if t > t_ig

  if k==n && t_c>0
    t_c=t_c-Deltat;
    if t_c < 0
      t_c=0;
    endif
  else
    i=k;
    while i<=n
      t_go_i(i)=t_go_i(i)-Deltat;
      i=i+1;
    endwhile
    m=m-m_dot(k)*Deltat;
    t_b(k)=t_b(k)-Deltat;
end

if t_b(k)<=0
  t_gc(k)=0;
  k=k+1;
end
end

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
