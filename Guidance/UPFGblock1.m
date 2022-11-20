%%UPFG block 1



%temp
#Deltav_OMS=400;
r_bar_d=target.r_bar_d;
v_bar_d=target.v_bar_d;

k=1;
g_bar=[0,0,0];
#L_i(n)=Deltav_OMS;
Deltat=15;
i=1;
s_pass1=1;
s_guess=0;
s_proj=0;
s_engoff=0;
m=m_0(i);
r_bar_bias=[0,0,0];
r_bar_ref=r_bar_d;
v_bar_ref=v_bar_d;
t_go=1;
r_bar_grav=-(mu/2)*r_bar/norm(r_bar)^3;
t_go0=1;
rho=0.000001;
v_bar_go=v_bar_d-v_bar;

while i<=n
f_T(i)=s_AElower(i)*K(i)*f_AElower+s_AEupper(i)*K(i)*f_AEupper;
m_dot(i)=s_AElower(i)*K(i)*m_dot_AElower+s_AEupper(i)*K(i)*m_dot_AEupper;

v_ex(i)=f_T(i)/m_dot(i);
a_T(i)=f_T(i)/m_0(i);
tau(i)=v_ex(i)/a_T(i);
i=i+1;
end

#[r_bar, v_bar] = simplePSE(r_bar, v_bar, t, (t_ig-Deltat_t0), s_pert);
#[r_bar, v_bar, pre] = CSE(r_bar, v_bar, (t_ig-Deltat_t0));

t=t_ig-Deltat_t0;
t_prev=t;
