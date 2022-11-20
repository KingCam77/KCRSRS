%%UPFG block 3
#f_T(k)=s_AElower(k)*K(k)*f_AElower+s_AEupper(k)*K(k)*f_AEupper;
#m_dot(k)=s_AElower(k)*K(k)*m_dot_AElower+s_AEupper(k)*K(k)*m_dot_AEupper;
Lbreak=0;
#
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


