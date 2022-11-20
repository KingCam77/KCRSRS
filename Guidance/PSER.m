%%Simplified Precision State Extapolation
%inputs reduced for my sanity
function [r_bar_F, v_bar_F] = simplePSE(r_bar_0, v_bar_0, t_0, t_F, s_pert)
  %%Universal Constants
  mu=(3.986004188*10^14);
  J_2=0.01467;
  r_E=6378137;
  i_bar_pole=[0,0,1];

  %%Program constants
  epsilon_t=0.00001;
  Deltat_max=10;
  delta_max=10;
  nu_max=10;

  t=t_0;

  s_cont=0; %hard coded input
  if s_cont==0
    delta_bar=[0,0,0];
    nu_bar=[0,0,0];
    r_bar_con=r_bar_0;
    v_bar_con=v_bar_0;
    x=0;
    x_prime=0;
    tau=0;
    tau_prime=0;
  endif

  Deltat_nom=c_nom*r_con^(3.2)/sqrt(mu);
  sigma=sign(t_F-t)
  deltat=sigma*min(abs(t_F-t), Deltat_nom, Deltat_max)

  if abs(Deltat) < epsilon_t
    r_bar_F=r_bar_con+delta_bar
    v_bar_F=v_bar_con+nu_bar

    %W_F= %some matrix that i dont care about

    %end of code, probably some break to exit a loop
  endif

  s_W=0;
  h=0;
  j=1;
  alpha_bar=delta_bar;
  Beta_bar=nu_bar;
  r=norm(r_bar);

  if s_W == 0
    r_bar=r_bar_con+alpha_bar;
    v_bar=v_bar_con+beta_bar;
    t=t_0+tau;

    if d~= 0
      r_bar_j=r_bar;
    end
    if s_pert <= 0
      disp("ERROR - invalid s_pert.")
    elseif s_pert == 1
      sinphi=dot(r_bar/r,i_bar_pole);           %Unsure if it should be expressed as phi = asin
      a_bar_d=(-mu/r^2)*((3/2)*J_2*(r_E/r)^2*((1-5*sinphi^2)*(r_bar/r)+2*sinphi*i_bar_pole));


    elseif s_pert >= 1
      %%Compute a_bar_d from r_bar, v_bar, and t

    endif
    q=(dot((alpha_bar-2*r_bar),alpha_bar)/r^2);
    f(q)=q((3+3*q+q^2)/(1+(1+q)^(3/2)));

    f_bar=(-mu/(r_con^3))*(f(q)*r_bar+alpha_bar)+a_bar_d;
  else
    f_bar=(mu/(r_j^5))*(3*dot(r_bar_j,alpha_bar)*r_bar_j-(r_j^2)*alpha_bar);

    if (s_q == 1 || s_q == 2) && (i==k+3 || i==k+4 || i==k+5)
      u_bar(3,:)=[1,0,0];
      u_bar(4,:)=[0,1,0];
      u_bar(5,:)=[0,0,1];
      f_bar=f_bar+(1/(2*u_bar(i,:)+Beta_bar))*q_bar(i);
    endif
  endif
  k_bar(j)=f_bar;

  if j==4




  else
    if j == 2
    if s_W == 0
    %%assuming no becuase idk what it does.
    disp("ERROR - s_W equal to zero")
    end
    k_bar(3)==k_bar(2)
  endif

  h=h+Deltat/2
  alpha_bar=delta_bar+h*(nu_bar+(h/2)*f_bar)

  Beta_bar=nu_bar+h*f_bar
  j=j+1

