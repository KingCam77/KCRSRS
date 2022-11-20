%%Vehicle Creator

%%Data from sensors
data.Deltav_bar
data.DeltaAngle_bar
data.t

%%Estimated Vehicle State
state.mass
state.r_bar
state.v_bar
state.t
state.engine      %Engine running flag

%%Engine statistics
engine(n).K_max
engine(n).thrust
engine(n).isp
engine(n).m_dot

%%Stages
%All values dependent on vehicle stage

stage(n).s_engine   %Number of engines in phase
stage(n).s_phase    %Phase switch
stage(n).m_0        %Initial mass in phase
stage(n).K          %Throttle setting in phase
stage(n).t_b        %Time remaining in phase


%%Guidance
%All values related to guidance that are not stage dependent

guidance.r_d        %Desired radius at cutoff
guidance.v_d        %Desired velocity at cutoff
guidance.r_bar_d    %Desired cutoff position
guidance.gamma_d    %Desired flight path angle at cutoff

%x is radial to desired position
%z is downrange direction
guidance.i_bar_x
guidance.i_bar_y    %Unit vector normal to desired trajectory
guidance.i_bar_z

guidance.s_pre      %Prethrust switch
guidance.t_c        %Coast time between last and next to last phase
guidance.s_mode     %Maneuver Mode
                        %1 = Ascent, standard
                        %2 = Ascent, reference trajectory
                        %3 = Ascent, Lambert
                        %4 = Ascent, once-around abort
                        %5 = Ascent, return-to-launch-site abort
                        %6 = On-orbit, external DeltaV
                        %7 = On-orbit, Lambert
                        %8 = On-orbit, deorbit
