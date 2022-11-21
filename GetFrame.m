function f = GetFrame(r_bar, v_bar)
%This code was taken from PEGAS, slightly adapted

if nargin == 2
  type = 2;
else
  type = 1;
end


switch type
  case 1
%constructs a local reference frame, KSP-navball style
    %pass current position under r (1x3)
    up = unit(r_bar);                   %true Up direction (radial away from Earth)
    east = cross([0,0,1],up);       %true East direction
    north = cross(up, east);        %true North direction (completes frame)
    f = zeros(3,3);
    %return a right-handed coordinate system base
    f(1,:) = up;
    f(2,:) = unit(north);
    f(3,:) = unit(east);


  case 2
%constructs a local reference frame in style of PEG coordinate base
    %pass current position under r (1x3)
    %current velocity under v (1x3)
    radial = unit(r_bar);               %Up direction (radial away from Earth)
    normal = unit(cross(r_bar, v_bar));     %Normal direction (perpendicular to orbital plane)
    circum = cross(normal, radial); %Circumferential direction (tangential to sphere, in motion plane)
    f = zeros(3,3);
    %return a left(?)-handed coordinate system base
    f(1,:) = radial;
    f(2,:) = normal;
    f(3,:) = circum;
end

end
