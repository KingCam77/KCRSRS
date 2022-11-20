%%UPFGsingle
function [current, guidance] = UPFG(vehicle, previous)


stage=vehicle.stage
engines=vehicle.engines
state=vehicle.state
target=vehicle.target
n=length(stage)

skip=0;
s_pre
UPFGcycle=0;
if s_pre > 0

%-------------------------------------------------------------------------------
    %%UPFG block 1

    %Val read set
    i=1;
    while i<=n
    m_0(i)=stage(i).mass
    i=i+1;
    end



    %temp
    r_bar_d=target.r_bar_d;
    v_bar_d=target.v_bar_d;

    r_bar=state.r_bar;
    v_bar=state.v_bar;


    k=1;
    gamma_d=target.gamma_d;
    Deltat=15;
    i=1;
    s_pass1=1;
    s_guess=0;
    s_proj=0;
    s_engoff=0;
    m=m_0(i)
    r_bar_bias=[0,0,0];
    r_bar_ref=r_bar_d;
    v_bar_ref=v_bar_d;
    t_go=1;
    r_bar_grav=-(mu/2)*r_bar/norm(r_bar)^3;
    t_go0=1;
    rho=0.000001;
    v_bar_go=v_bar_d-v_bar;

    while i<=n
    f_T(i)=sum(stage(i).engines .* stage(i).throttle .* engines.thrust_asl);
    m_dot(i)=sum(stage(i).engines .* stage(i).throttle .* engines.m_dot);

    v_ex(i)=f_T(i)/m_dot(i);
    a_T(i)=f_T(i)/m_0(i);
    tau(i)=v_ex(i)/a_T(i);
    i=i+1;
    end


    #[r_bar, v_bar] = simplePSE(r_bar, v_bar, t, (t_ig-Deltat_t0), s_pert);
    #[r_bar, v_bar, pre] = CSE(r_bar, v_bar, (t_ig-Deltat_t0));

    t=t_ig-Deltat_t0;
    t_prev=t;
%-------------------------------------------------------------------------------

else

%-------------------------------------------------------------------------------
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
%-------------------------------------------------------------------------------

  if t<t_ig || s_engoff == 1
    skip=1;
  endif
end

if skip ~= 1

while UPFGcycle < 100

%-------------------------------------------------------------------------------
    %%UPFG block 3
    Lbreak=0;
    if m_dot(k) ~= 0
      a_T(k)=f_T(k)/m;       %m = mass now
      v_ex(k)=f_T(k)/m_dot(k);
      tau(k)=v_ex(k)/a_T(k);
    end

    i=k;
    L=0;
    j=n-1;

    while i <= j
      if s_phase(i)==0
        L_i(i)=-v_ex(i)*log((tau(i)-t_b(i))/tau(i));
      else
        L_i(i)=a_L*t_b(i);
      end
      L=L+L_i(i);
      i=i+1;
    end



    if i < n
    L_i(n)=norm(v_bar_go)-L #-L_i(n);
    else
    L_i(n)=norm(v_bar_go);
    end


    while L_i(i) <= 0
      L_i(i)=0;
      t_b(i)=0;

      if k < j
        i=i-1;
        j=j-1;
        L=L-L_i(i);

        L_i(i)=norm(v_bar_go)-L-L_i(n);
      else
        Lbreak=1;
        break;
      end
    end

    if Lbreak==1
      Lbreak=0;
    else
      if s_phase(i)==0
        t_b(i)=tau(i)*(1-exp(-L_i(i)/v_ex(i)));
      else
        t_b(i)=L_i(i)/a_L;     %a_L is acceleration limit
      end
    end

    i=k;

    while i <= n
      if i-1==0
        t_go_i(i)=t_b(i);
      else
        t_go_i(i)=t_go_i(i-1)+t_b(i);
      endif
    i=i+1;
    end

    t_prime_go=t_go;

    t_go_i(n)=t_go_i(n)+t_c;
    t_go=t_go_i(n);


%-------------------------------------------------------------------------------

    %%UPFG block 4
    i=k;
    L=0;
    J=0;
    S=0;
    Q=0;
    H=0;
    P=0;

    while i <= n

    if i-1==0
    if s_phase(i)==0
      J_i(i) = tau(i)*L_i(i)-v_ex(i)*t_b(i);
      S_i(i) = -J_i(i)+t_b(i)*L_i(i);
      Q_i(i) = S_i(i)*(tau(i)+t_go0)-0.5*v_ex(i)*t_b(i)^2;
      P_i(i) = Q_i(i)*(tau(i)+t_go0)-0.5*v_ex(i)*t_b(i)^2*((1/3)*t_b(i)+t_go0);
    else
      J_i(i) = 0.5*L_i(i)*t_b(i);
      S_i(i) = J_i(i);
      Q_i(i) = S_i(i)*((1/3)*t_b(i)+t_go_i(i-1));
      P_i(i) = (1/6)*S_i(i)*(t_go_i(i)^2+2*t_go_i(i)*t_go0+3*t_go0^2);
    end
      J_i(i) = J_i(i)+L_i(i)*t_go0;
    else
    if s_phase(i)==0
      J_i(i) = tau(i)*L_i(i)-v_ex(i)*t_b(i);
      S_i(i) = -J_i(i)+t_b(i)*L_i(i);
      Q_i(i) = S_i(i)*(tau(i)+t_go_i(i-1))-0.5*v_ex(i)*t_b(i)^2;
      P_i(i) = Q_i(i)*(tau(i)+t_go_i(i-1))-0.5*v_ex(i)*t_b(i)^2*((1/3)*t_b(i)+t_go_i(i-1));
    else
      J_i(i) = 0.5*L_i(i)*t_b(i);
      S_i(i) = J_i(i);
      Q_i(i) = S_i(i)*((1/3)*t_b(i)+t_go_i(i-1));
      P_i(i) = (1/6)*S_i(i)*(t_go_i(i)^2+2*t_go_i(i)*t_go_i(i-1)+3*t_go_i(i-1)^2);
    end
    J_i(i) = J_i(i)+L_i(i)*t_go_i(i-1);
    end
    S_i(i) = S_i(i)+L*t_b(i);
    Q_i(i) = Q_i(i)+J*t_b(i);
    P_i(i) = P_i(i)+H*t_b(i);

    if i == n
      S_i(i)=S_i(i)+L*t_c;
      Q_i(i)=Q_i(i)+J*t_c;
      P_i(i)=P_i(i)+H*t_c;
    end

    L = L+L_i(i);
    J = J+J_i(i);
    S = S+S_i(i);
    Q = Q+Q_i(i);
    P = P+P_i(i);
    H = J*t_go_i(i)-Q;

    i=i+1;
    end

%-------------------------------------------------------------------------------

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

%-------------------------------------------------------------------------------
#  UPFGblock6   %Unnecessary due to nature of simulation

if s_mode ~= 6
%-------------------------------------------------------------------------------
    %%UPFG block 7

    Deltar_bar_c = -0.1*r_bar_thrust - (1/30)*v_bar_thrust*t_go;
    Deltav_bar_c = (6/5)*r_bar_thrust/t_go - 0.1*v_bar_thrust;
    r_bar_c1=r_bar+Deltar_bar_c;
    v_bar_c1=v_bar+Deltav_bar_c;

    [r_bar_c2, v_bar_c2, pre] = CSE(r_bar_c1, v_bar_c1, t_go, pre);


    v_bar_grav = v_bar_c2-v_bar_c1;
    r_bar_grav = r_bar_c2-r_bar_c1-v_bar_c1*t_go;

%-------------------------------------------------------------------------------

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
%-------------------------------------------------------------------------------


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



end
