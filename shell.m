clear;

axis equal;
axis([-1 1 -1 1 -1 1]);
grid on;

% Draw simple shell made of cones and cylinders
[xc, yc, zc] = cylinder([0.1 0]);   % Cone
[x,   y,  z] = cylinder(); % Cylinder

h(1) = surface(xc,    0.25*zc,     -yc, 'FaceColor', 'yellow');
h(2) = surface(0.105*x,-0.5*z, 0.105*y, 'FaceColor', 'yellow');

shell = hgtransform;
set(h, 'Parent', shell); 
