% Artillery Simulation
% George Proner, Kevin Wei
% INFO48874 Simulation and Visualization
% Winter 2018


clear;
main();

function main()
% Constants
GRAVITY = -9.80665;

MAX_X = 5000;
MAX_Y = 5000;
MAX_HEIGHT = 5000;
MASS_BULLET = 14.97; % HE Round 19.08, Projectile 14.97 kg

AIR_DENSITY = 1.2041; % @ 20C and 1 atm. Units kg/m3
DRAG_COEF_BULLET = 0.295; % https://en.wikipedia.org/wiki/Drag_coefficient
CROSS_AREA_BULLET = 0.03463605901; % m^2 Calculated using area of circle with 105mm

%visualization
%drawHowitzer();

% Simulation
elevation =45;
bearing = 45;
time = 0;
TIME_STEP = 0.1;
bullet = [ 0 0 1 ]; % Initial bullet position [ X Y Z] starts at about 1 meter off the ground because barrel height.


%visualization
p = get(gcf, 'Position');
close all;
h_fig = figure('Name', 'Artillery Shot Simulation');
set(h_fig, 'Position', [p(1)  p(2)  p(3)  p(4)]);  % Set figure size same as before

h = animatedline('LineWidth', 3);
view(3);

%     set(h_fig, 'KeyPressFcn', @keypress_callback);
%     set(h_fig, 'KeyReleaseFcn', @keyrelease_callback);


% Label the x, y, z axes
xlabel('X');
ylabel('Y');
zlabel('Height');
axis([0 MAX_X -MAX_Y MAX_Y 0 MAX_HEIGHT]);
grid on;
view(3);
velocity = 472; %initial muzzle velocity m/s
%initial bullet velocities
vx = sqrt(velocity*cos(elevation)*velocity*cos(bearing)); %vx in terms of y and z because both the elevation and 
vy = sqrt(velocity*cos(elevation)*velocity*sin(bearing)); %vy in terms of x and z
vz = velocity*sin(elevation); %vz in terms of x
while bullet(3) >= 0
    dx = vx * TIME_STEP;    % x-distance
    dy = vy * TIME_STEP ;          % y-distance
    dz = vz*TIME_STEP;           % height
    % Bullet position
    bullet(1) = bullet(1) + dx;
    bullet(2) = bullet(2) + dy;
    bullet(3) = bullet(3) + dz;
    % Air Resistance
    Fx = 0.5 * AIR_DENSITY * DRAG_COEF_BULLET * vx^2 * CROSS_AREA_BULLET;
    Fy = 0.5 * AIR_DENSITY * DRAG_COEF_BULLET * vy^2 * CROSS_AREA_BULLET;
    Fz = 0.5 * AIR_DENSITY * DRAG_COEF_BULLET * vz^2 * CROSS_AREA_BULLET;
    
    % Convert force of drag to velocity components of drag
    if (vx > 0)
        drag_x = Fx / MASS_BULLET * TIME_STEP; %
    else
        drag_x = 0;
    end
        % Convert force of drag to velocity components of drag
    if (vy > 0)
        drag_y = Fy / MASS_BULLET * TIME_STEP; %
    else
        drag_y = 0;
    end
    
    
    if (vz > 0)
        drag_z = Fz / MASS_BULLET * TIME_STEP;
    else
        % Drag reduces gravity when Vz <= 0
        drag_z = -Fz / MASS_BULLET * TIME_STEP;
    end
    
    % Projectile Calculations
    vx = vx - drag_x;
    vy = vy - drag_y;
    vz = vz + GRAVITY * TIME_STEP;
    
    time = time + TIME_STEP;
    fprintf("%.3f s X: %f \t Z: %f \t Vx: %f \t Vz: %f total distance: %f\n", time, bullet(1), bullet(3), vx, vz, sqrt(bullet(1)^2+bullet(2)^2));
    
    addpoints(h, bullet(1), bullet(2), bullet(3));
    drawnow;
    
end


end