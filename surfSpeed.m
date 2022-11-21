%%Another function taken from PEGAS
%%Doesnt need its own file but didnt want to call
%finds Earth's rotation velocity vector at given cartesian location
function [rot] = surfSpeed(r, nav)
    global r_E;
    global Pe_E;
    [~,lat,~] = cart2sph(r(1), r(2), r(3));
    vel = 2*pi*r_E/Pe_E * cos(lat);
    rot = vel*nav(3,:); %third componend is East vector
end
