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
