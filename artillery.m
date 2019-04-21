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
drawHowitzer();

% Simulation
time = 0;
TIME_STEP = 0.1;
bullet = [ 0 0 0 ]; % Initial bullet position [ X Y Z]

angle_x = 10; % Degree of tilt of artillery
angle_y = 100; % Rotation of the base

x = 0;
y = 0;
z = 0.01;

shot_direction = [ 1 0 0 ]; % Initial shot direction

% Create figure window with keyboard callbacks
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

initial_velocity = 472;

% Calculate initial x y
Vx = initial_velocity * cos(angle_x* pi/180);
Vz = initial_velocity * sin(angle_x * pi/180);

while z >= 0
    dx = Vx * TIME_STEP;    % x-distance
    %         dy = v_y * TIME_STEP ;          % y-distance
    dz = Vz + (GRAVITY * TIME_STEP);           % height
    
    % Bullet position
    x = x + dx;
    z = z + dz;
    y = y + cos(angle_y * pi/180)
    % Air Resistance
    Fx = 0.5 * AIR_DENSITY * DRAG_COEF_BULLET * Vx.^2 * CROSS_AREA_BULLET;
    Fz = 0.5 * AIR_DENSITY * DRAG_COEF_BULLET * Vz.^2 * CROSS_AREA_BULLET;
    
    % Convert force of drag to velocity components of drag
    if (Vx > 0)
        drag_x = Fx / MASS_BULLET * TIME_STEP; %
    else
        drag_x = 0;
    end
    
    
    if (Vz > 0)
        drag_z = Fz / MASS_BULLET * TIME_STEP;
    else
        % Drag reduces gravity when Vz <= 0
        drag_z = -Fz / MASS_BULLET * TIME_STEP;
    end
    
    % Projectile Calculations
    Vx = Vx - drag_x;
    Vz = Vz + GRAVITY * TIME_STEP - drag_z;
    
    time = time + TIME_STEP;
    fprintf("%.3f s X: %f \t Z: %f \t Vx: %f \t Vz: %f\n", time, x, z, Vx, Vz);
    
    addpoints(h, x, y, z);
    drawnow;
           pause(0.1)
end



% Reload artillery shell

    function reloadSim()
        time = 0;
        v_x = velocity * cos(angle_x * pi/180)
        
    end


%     function timer_callback(~, ~)
%
%     end
%
%     % TODO - keyboard callback functions arrow keys to change direction
%
%     % TODO - spacebar to fire artillery
%     function fire_callback(~, event)
%         if event.key == "space"
%             spacePressed = true;
%         end
%     end
%Draws howitzer model
    function drawHowitzer()
        [ex,   why,  zee] = cylinder([1 1]); % Cylinder
        h(2) = surface(0.5*zee+0.5,           why+1.75,   ex, 'FaceColor', [0.75 0.75 0.75]);%left wheel
        h(3) = surface(0.5*-zee-0.5,          why+1.75,   ex, 'FaceColor', [0.75 0.75 0.75]);%right wheel
        h(4) = surface(zee*5,           why*0.3,   ex*.3, 'FaceColor', 'green');%barrel
        rotate(h(4), [0 0 0.01], 90);%rotating 90% around the z axis for correct orientation
        rotate(h(4), [0.01 0 0], 45);%tilting barrel up
        h(1) = surface(zee*3,           why*0.3,   ex*.2, 'FaceColor', 'green');%right trail
        h(5) = surface(zee*3,           why*0.3,   ex*.2, 'FaceColor', 'green');%left trail
        rotate(h(1), [0 0 0.01], -45);%rotating 90% around the z axis for correct orientation
        rotate(h(1), [0.001 0 0], 25);%rotating 90% around the z axis for correct orientation
        rotate(h(5), [0 0 0.01], -135);%rotating 90% around the z axis for correct orientation
        rotate(h(5), [0.001 0 0], 25);%rotating 90% around the z axis for correct orientation
        
        %translate(h(4),[-5, -5, 0]);
    end
    function drawShell()
        % Draw simple shell made of cones and cylinders
        [xc, yc, zc] = cylinder([0.1 0]);   % Cone
        [ex,   why,  zee] = cylinder(); % Cylinder
        
        h(1) = surface(xc,    0.25*zc,     -yc, 'FaceColor', 'yellow');
        h(2) = surface(0.105*ex,-0.5*zee, 0.105*why, 'FaceColor', 'yellow');
        
        t = hgtransform;
        set(h, 'Parent', t);
        
    end
end