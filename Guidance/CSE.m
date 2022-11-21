function [r_bar, v_bar, pre, Deltat_c, x_c, e_flag] = CSE(r_bar_0, v_bar_0, Deltat, pre)
%%Conic State Extrapolation

%Program Constants
mu=398600441800000;
i_max=10;
k_max=10;
s_min=1;
s_max=10;
epsilon_alpha=0.00001;
epsilon_w=0.00001;
epsilon_tilde_t=0.00001;
epsilon_prime_t=0.00001;

if nargin == 3
  x=0;
  Deltat_prime_c=Deltat;
  x_prime_c=0;
  A=0;
  D=0;
  E=0;
else
  if pre.Deltat_prime_c==0
    Deltat_prime_c=Deltat;
  else
    Deltat_prime_c=pre.Deltat_prime_c;
  end
  x=pre.x_prime_c;
  x_prime_c=pre.x_prime_c;
  A=pre.A;
  D=pre.D;
  E=pre.E;
end


if Deltat >= 0
  f_0=1;
else
  f_0=-1;
end

n=0;
r_0=norm(r_bar_0);

f_1=(f_0*sqrt(r_0))/sqrt(mu);
f_2=1/f_1;
f_3=f_2/r_0;
f_4=f_1*r_0;
f_5=f_0/sqrt(r_0);
f_6=f_0*sqrt(r_0);

i_bar_r0=r_bar_0/r_0;
v_tilde_bar_0=f_1*v_bar_0;
sigma_tilde_0=dot(i_bar_r0,v_tilde_bar_0);
b_0=dot(v_tilde_bar_0,v_tilde_bar_0)-1;
alpha_tilde=1-b_0;

x_tilde_guess=f_5*x;
x_tilde_last=f_5*x_prime_c;
x_tilde_min=0;
Deltat_tilde=f_3*Deltat;
Deltat_tilde_last=f_3*Deltat_prime_c;
Deltat_tilde_min=0;

if sqrt(abs(alpha_tilde))<epsilon_alpha
  x_tilde_max=2*pi*s_max^(1/3);
  Deltat_tilde_max=2*pi*s_max;
else
  x_tilde_max=2*pi/sqrt(abs(alpha_tilde));

if alpha_tilde>0
    Deltat_tilde_max=x_tilde_max/alpha_tilde;
    x_tilde_P=x_tilde_max;
    P_tilde=Deltat_tilde_max;
    while Deltat_tilde >= P_tilde
      n=n+1;
      Deltat_tilde=Deltat_tilde-P_tilde;
      Deltat_tilde_last=Deltat_tilde_last-P_tilde;
      x_tilde_guess=x_tilde_guess-x_tilde_P;
      x_tilde_last=x_tilde_last-x_tilde_P;
    endwhile
  else

  Deltat_tilde_max = KepTrans(x_tilde_max, sigma_tilde_0, alpha_tilde, epsilon_w, s_max, k_max);

  while Deltat_tilde_max < Deltat_tilde
    Deltat_tilde_min=Deltat_tilde_max;
    x_tilde_min=x_tilde_max;
    x_tilde_max=2*x_tilde_max;

    Deltat_tilde_max = KepTrans(x_tilde_max, sigma_tilde_0, alpha_tilde, epsilon_w, s_max, k_max);
  end
end
end


if x_tilde_min < x_tilde_guess && x_tilde_guess < x_tilde_max
  %just skip if true
else
  x_tilde_guess=(x_tilde_min+x_tilde_max)/2;
end

  Deltat_tilde_guess = KepTrans(x_tilde_guess, sigma_tilde_0, alpha_tilde, epsilon_w, s_max, k_max);

if Deltat_tilde < Deltat_tilde_guess
  if x_tilde_guess < x_tilde_last && x_tilde_last < x_tilde_max && Deltat_tilde_guess < Deltat_tilde_last && Deltat_tilde_last < Deltat_tilde_max
    x_tilde_max=x_tilde_last;
    Deltat_tilde_max = Deltat_tilde_last;
  end
else
  if x_tilde_min < x_tilde_last && x_tilde_last < x_tilde_guess && Deltat_tilde_min < Deltat_tilde_last && Deltat_tilde_last < Deltat_tilde_guess
    x_tilde_min=x_tilde_last;
    Deltat_tilde_min = Deltat_tilde_last;
  end
end

[x_tilde_guess, Deltat_tilde_guess, A, D, E, e_flag] = KepIterLoop(i_max, epsilon_tilde_t, epsilon_prime_t, Deltat_tilde, x_tilde_guess, Deltat_tilde_guess, x_tilde_min, Deltat_tilde_min, x_tilde_max, Deltat_tilde_max, sigma_tilde_0, alpha_tilde, s_max, k_max, epsilon_w, A, D, E);

r_tilde = 1+2*(b_0*A+sigma_tilde_0*D*E);
b_4 = 1/r_tilde;

if n>0
x_c=f_6*(x_tilde_guess+n*x_tilde_P);
Deltat_c=f_4*(Deltat_tilde_guess+n*P_tilde);
else
x_c=f_6*x_tilde_guess;
Deltat_c=f_4*Deltat_tilde_guess;
end

[r_bar, v_bar] = ExtraStateV(f_2, b_4, sigma_tilde_0, r_0, A, D, E, i_bar_r0, v_tilde_bar_0);

  pre.Deltat_prime_c=Deltat_c;
  pre.x_prime_c=x_c;
  pre.A=A;
  pre.D=D;
  pre.E=E;

endfunction


%%Extrapolated State Vector
function [r_bar, v_bar] = ExtraStateV(f_2, b_4, sigma_tilde_0, r_0, A, D, E, i_bar_r0, v_tilde_bar_0)
  F=1-2*A;
  G_tilde = 2*(D*E+sigma_tilde_0*A);
  F_tilde_t = -2*b_4*D*E;
  G_t = 1-2*b_4*A;

  r_bar = r_0*(F*i_bar_r0+G_tilde*v_tilde_bar_0);
  v_bar = f_2*(F_tilde_t*i_bar_r0+G_t*v_tilde_bar_0);
end



%%Kepler Transfer Time Interval
function [Deltat_tilde_arg, A, D, E, e_flag] = KepTrans(x_tilde_arg, sigma_tilde_0, alpha_tilde, epsilon_w, s_max, k_max)
  e_flag=0;

  [u_1, e_flag] = USeriesSum(x_tilde_arg, alpha_tilde, k_max);


  z_tilde=2*u_1;
  E=1-0.5*alpha_tilde*z_tilde^2;
  w=sqrt(max((0.5+E/2),0));
  D=w*z_tilde;
  A=D^2;
  B=2*(E+sigma_tilde_0*D);

  Q = QConFract(w, epsilon_w, s_max);

  Deltat_tilde_arg=D*(B+A*Q);
endfunction

%%Kepler Iteration Loop
function [x_tilde_guess, Deltat_tilde_guess, A, D, E, e_flag] = KepIterLoop(i_max, epsilon_tilde_t, epsilon_prime_t, Deltat_tilde, x_tilde_guess, Deltat_tilde_guess, x_tilde_min, Deltat_tilde_min, x_tilde_max, Deltat_tilde_max, sigma_tilde_0, alpha_tilde, s_max, k_max, epsilon_w, A, D, E)

  Lbreak=0;
  i=1;

  while i<i_max

    Deltat_tilde_error=Deltat_tilde-Deltat_tilde_guess;

    if abs(Deltat_tilde_error) < epsilon_tilde_t
      Lbreak = 1;
      e_flag=0;
      break;
    else
      [Deltax_tilde, x_tilde_min, Deltat_tilde_min, x_tilde_max, Deltat_tilde_max] = SecantIter(epsilon_prime_t, Deltat_tilde_error, x_tilde_guess, Deltat_tilde_guess, x_tilde_min, Deltat_tilde_min, x_tilde_max, Deltat_tilde_max);

      x_tilde_old = x_tilde_guess;
      x_tilde_guess = x_tilde_guess+Deltax_tilde;

      if x_tilde_guess == x_tilde_old
        Lbreak = 1;
        break;
      endif
    Deltat_tilde_old=Deltat_tilde_guess;
    [Deltat_tilde_guess, A, D, E, e_flag] = KepTrans(x_tilde_guess, sigma_tilde_0, alpha_tilde, epsilon_w, s_max, k_max);

     if Deltat_tilde_guess == Deltat_tilde_old
        Lbreak = 1;
        e_flag=e_flag;
        break;
      endif

    endif
  i=i+1;
end

  if Lbreak == 0
  e_flag=e_flag+1;
  end
  Lbreak=0;
endfunction

%%Secant Iterator
function [Deltax_tilde, x_tilde_min, Deltat_tilde_min, x_tilde_max, Deltat_tilde_max] = SecantIter(epsilon_prime_t, Deltat_tilde_error, x_tilde_guess, Deltat_tilde_guess, x_tilde_min, Deltat_tilde_min, x_tilde_max, Deltat_tilde_max)

  Deltat_prime_min=Deltat_tilde_guess-Deltat_tilde_min;
  Deltat_prime_max=Deltat_tilde_guess-Deltat_tilde_max;

if abs(Deltat_prime_min) < epsilon_prime_t || abs(Deltat_prime_max) < epsilon_prime_t
Deltax_tilde=0;
else

if Deltat_tilde_error < 0

  Deltax_tilde=((x_tilde_guess-x_tilde_max)/Deltat_prime_max)*Deltat_tilde_error;

  if (x_tilde_guess+Deltax_tilde) <= x_tilde_min
    Deltax_tilde=((x_tilde_guess-x_tilde_min)/Deltat_prime_min)*Deltat_tilde_error;
  end

x_tilde_max=x_tilde_guess;
Deltat_tilde_max=Deltat_tilde_guess;

else

  Deltax_tilde=((x_tilde_guess-x_tilde_min)/Deltat_prime_min)*Deltat_tilde_error;

  if x_tilde_guess+Deltax_tilde >= x_tilde_max
    Deltax_tilde=((x_tilde_guess-x_tilde_max)/Deltat_prime_max)*Deltat_tilde_error;
  end

x_tilde_min=x_tilde_guess;
Deltat_tilde_min=Deltat_tilde_guess;

end
end
endfunction

%%Q Continued Fraction
function Q = QConFract(w, epsilon_w, s_max)

if w < epsilon_w
  if w==0
   Q=0;
  else
   Q=s_max;
  endif
else


if w < 1
  x_q=21.04-13.04*w;
elseif w < 4.625
  x_q=(5*(2*w+5))/3;
elseif w < 13.846
  x_q=(10*(w+12))/7;
elseif w < 44
  x_q=(w+60)/2;
elseif w < 100
  x_q=(w+164)/4;
else
  x_q=70;
endif

  b=0;
  y=(w-1)/(w+1);
  j=floor(x_q);
  b=y/(1+((j-1)/(j+2))*(1-b));

  while j > 2
    j=j-1;
    b=y/(1+((j-1)/(j+2))*(1-b));
  end
  Q=(1/(w^2))*(1+((2*(1-b/4))/(3*w*(w+1))));
  end
end

%%U_1 Series Summation
function [u_1, e_flag] = USeriesSum(x_tilde_arg, alpha_tilde, k_max)

deltau_1=x_tilde_arg/4;
u_1=deltau_1;
f_7=-alpha_tilde*deltau_1^2;

k=3;

while k < k_max

deltau_1=(f_7*deltau_1)/(k*(k-1));
u_1old=u_1;
u_1=u_1+deltau_1;

if u_1 == u_1old
  break;
end

k=k+2;
end
e_flag=2;
endfunction
