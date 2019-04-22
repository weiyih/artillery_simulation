% Artillery Simulation
% George Proner, Kevin Wei
% INFO48874 Simulation and Visualization
% Winter 2018

clear;
main();

function main()
    % Constants
    GRAVITY = -9.80665;
    target_coord = [5438 5966 0]; %where the enemy target lies
    MAX_X = 10000;
    MAX_Y = 10000;
    MAX_HEIGHT = 10000;
    MASS_BULLET = 14.97; % HE Round 19.08, Projectile 14.97 kg

    % Drag Constants
    AIR_DENSITY = 1.2041; % @ 20C and 1 atm. Units kg/m3
    DRAG_COEF_BULLET = 0.295; % https://en.wikipedia.org/wiki/Drag_coefficient
    CROSS_AREA_BULLET = 0.03463605901; % m^2 Calculated using area of circle with 105mm
    
    % Wind - Constant in the x-y plane
    % x - north (+) south (-)
    % y - east (+) west (-)
    wind_speed = 2.8; % m/s
    wind_direction = 150 %Degrees
    WIND = [cos(wind_direction)*wind_speed sin(wind_direction)*wind_speed 0]

    % Simulation
    elevation =45;
    bearing = 45;
    time = 0;
    TIME_STEP = 0.1;
    bullet = [ 0 0 1 ]; % Initial bullet position [ X Y Z] starts at about 1 meter off the ground because barrel height.
    previous_bullet = bullet; %storing the previous value to kind of cheat instead of the derivative and get the slope of the two points, for bullet tilt

    %visualization
    l = light;           % Add a light
    set(l, 'Color', [1 1 1], 'Position', [5000 5000 10000]);  % Set light color (WHITE) and position
    lighting gouraud;    % Change from flat to Gouraud shading, 'gouraud' preferred for curved surfaces
    material metal;   % Set material properties
    p = get(gcf, 'Position');
    
    h_fig = figure('Name', 'Artillery Shot Simulation');
    set(h_fig, 'Position', [p(1)  p(2)  p(3)  p(4)]);  % Set figure size same as before
    h = animatedline('LineWidth', 1, 'LineStyle', ':');
    view(3);

    drawHowitzer();
    drawShell();
    drawTarget();

    % Label the x, y, z axes
    xlabel('X');
    ylabel('Y');
    zlabel('Height');
    axis([0 MAX_X -MAX_Y MAX_Y 0 MAX_HEIGHT]);
    grid on;
    view(3);
    
    %initial bullet velocities
    velocity = 472; %initial muzzle velocity m/s
    vx = sqrt(velocity*cos(elevation)*velocity*cos(bearing)); %vx in terms of y and z because both the elevation and
    vy = sqrt(velocity*cos(elevation)*velocity*sin(bearing)); %vy in terms of x and z
    vz = velocity*sin(elevation); %vz in terms of x
    pause(2)

while bullet(3) >= 0
    dx = (vx + WIND(1)) * TIME_STEP;    % x-distance
    dy = (vy + WIND(2)) * TIME_STEP;    % y-distance
    dz = vz * TIME_STEP;                % height
    % Bullet position
    bullet(1) = bullet(1) + dx;
    bullet(2) = bullet(2) + dy;
    bullet(3) = bullet(3) + dz;
    
    calcAirResistance();
        
    time = time + TIME_STEP;
    fprintf("%.3f s X: %f \t Y: %f \t Z: %f \t Vx: %f \t Vz: %f \t total distance: %f\n", time, bullet(1),bullet(2), bullet(3), vx, vz, sqrt(bullet(1)^2+bullet(2)^2));
    
    addpoints(h, bullet(1), bullet(2), bullet(3));
    
    drawnow;
    
end


    if abs(bullet(1) - target_coord(1)) <30 && abs(bullet(2)-target_coord(2)) <30 %we don't really care about the height since rounds burst on impact. simulation will have it thunder in around 30-40 meters. we're comparing x and y though.
        fprintf('The Target was destroyed.');
    else
        fprintf('The target was outside the effective radius.');

    end

    % Artillery model

    function calcAirResistance()
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
        vz = vz - drag_z + GRAVITY * TIME_STEP;
        
    end

    function drawHowitzer()
        [x,   y,  z] = cylinder([1 1]); % Cylinder
        howitzer(1) = surface(0.5*z,           y,   x, 'FaceColor', [0.75 0.75 0.75]);%left wheel
        howitzer(2) = surface(0.5*z,          y,   x, 'FaceColor', [0.75 0.75 0.75]);%right wheel
        howitzer(3) = surface(z*5,           y*0.3,   x*.3+1, 'FaceColor', 'green');%barrel
        rotate(howitzer(1:2), [0 0 0.01], 90);%rotating 90% around the z axis for correct orientation
        rotate(howitzer(3), [0 1 0], -45);%tilting barrel up
        t = hgtransform;
        set(howitzer, 'Parent', t);  % Apply the transform to all surfaces in vector 'h'
        M = eye(4);
        M = M * makehgtform('scale', [200 200 200]);%scaled up so it was visible
        set(t, 'Matrix', M);   % Update transformation matrix
    end
    
    % Artillery shell model
    function drawShell()
        % Draw simple shell made of cones and cylinders
        [xc, yc, zc] = cylinder([0.1 0]);   % Cone
        [x,   y,  z] = cylinder(); % Cylinder
        
        shell(1) = surface(xc,    0.25*zc,     -yc, 'FaceColor', 'yellow');
        shell(2) = surface(0.105*x,-0.5*z, 0.105*y, 'FaceColor', 'yellow');
        
        t = hgtransform;
        set(shell, 'Parent', t);
    end

    function drawTarget()
        
        X = [0 0.5 0.5 0];
        Y = [0 0 1 1];
        Z = [0 0 0 0];
        target(1) = patch(X,Y,Z,'green');
        
        X = [0 0.5 0.5 0];
        Y = [0 0 1 1];
        Z = [0.25 0.25 0.25 0.25];
        target(2) = patch(X,Y,Z,'green');
        
        X = [0 0.5 0.5 0];
        Y = [0 0 0 0];
        Z = [0 0 0.25 0.25];
        target(3) = patch(X,Y,Z,'green');
        
        X = [0.5 0.5 0.5 0.5];
        Y = [0 1 1 0];
        Z = [0 0 00.25 0.25];
        target(4) = patch(X,Y,Z,'green');
        
        X = [0.5 0 0 0.5];
        Y = [1 1 1 1];
        Z = [0 0 0.25 0.25];
        target(5) = patch(X,Y,Z,'green');
        
        X = [0 0 0 0];
        Y = [0 0 1 1];
        Z = [0 0.25 0.25 0];
        target(6) = patch(X,Y,Z,'green');
        [x,   y,  z] = cylinder([0.15 0.15]); % Cylinder
        target(7) = surface(0.1*z+0.5,           y,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(8) = surface(0.1*-z,          y,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(9) = surface(0.1*z+0.5,           y+0.35,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(10) = surface(0.1*-z,          y+0.35,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(11) = surface(0.1*z+0.5,           y+1,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(12) = surface(0.1*-z,          y+1,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(13) = surface(0.1*z+0.5,           y+.65,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(14) = surface(0.1*-z,          y+.65,   x, 'FaceColor', [0.75 0.75 0.75]);
        target(15) = surface(-0.1*z,          y,   0.2*x, 'FaceColor', 'green');
        rotate(target(8), [0 0 0.00001], 90);%rotating 90% around the z axis for correct orientation
        t = hgtransform;
        set(target, 'Parent', t);  % Apply the transform to all surfaces in vector 'h'
        M = eye(4);
        M = M * makehgtform('translate', [4205 4695 0]);
        M = M * makehgtform('scale', [500 500 500]);%scaled up so it was visible
        
        set(t, 'Matrix', M);   % Update transformation matrix
    end
end