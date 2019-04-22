clear;

main()
function main()
% Set up axes
h = [];%polygons belonging to rover
G = [];%values for rover movement
fields = {};
axis equal;
axis([-11 11 -2 11 -1.5 1.5]);
grid on;


% Draw simple rover made cylinders and squares
drawWheels();
drawbody();
l = light;           % Add a light
set(l, 'Color', [1 1 1], 'Position', [5 5 5]);  % Set light color (WHITE) and position
lighting gouraud;    % Change from flat to Gouraud shading, 'gouraud' preferred for curved surfaces
material metal;   % Set material properties
% Create a homogeneous transform to animate the airplane
t = hgtransform;
set(h, 'Parent', t);  % Apply the transform to all surfaces in vector 'h'
rotate(h, [0 0 1], 90)%rotating 90% around the z axis for correct orientation
% Define the rover trajectory.
importData()
longitude = cell2mat(fields(1));
latitude  = cell2mat(fields(2));
height = cell2mat(fields(3));
bearing   = cell2mat(fields(4));

% Loop through the points updating the transform to animate the rover
% for i = 1:size(longitude)
%     M = eye(4);
%     M = M * makehgtform('zrotate', bearing(i));
%     M = M * makehgtform('translate', [latitude(i) longitude(i) height(i)]);
%     
%     set(t, 'Matrix', M);   % Update transformation matrix
%     
%     pause(0.05);
% end
    function drawbody()

        X = [0 0.5 0.5 0];
        Y = [0 0 1 1];
        Z = [0 0 0 0];
        h(1) = patch(X,Y,Z,'green');
        
        X = [0 0.5 0.5 0];
        Y = [0 0 1 1];
        Z = [0.25 0.25 0.25 0.25];
        h(9) = patch(X,Y,Z,'green');
        
        X = [0 0.5 0.5 0];
        Y = [0 0 0 0];
        Z = [0 0 0.25 0.25];
        h(10) = patch(X,Y,Z,'green');
        
        X = [0.5 0.5 0.5 0.5];
        Y = [0 1 1 0];
        Z = [0 0 00.25 0.25];
        h(11) = patch(X,Y,Z,'green');
        
        X = [0.5 0 0 0.5];
        Y = [1 1 1 1];
        Z = [0 0 0.25 0.25];
        h(12) = patch(X,Y,Z,'green');
        
        X = [0 0 0 0];
        Y = [0 0 1 1];
        Z = [0 0.25 0.25 0];
        h(13) = patch(X,Y,Z,'green');
    end
    function drawWheels()
        [x,   y,  z] = cylinder([0.15 0.15]); % Cylinder
        h(2) = surface(0.1*z+0.5,           y,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(3) = surface(0.1*-z,          y,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(4) = surface(0.1*z+0.5,           y+0.35,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(5) = surface(0.1*-z,          y+0.35,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(6) = surface(0.1*z+0.5,           y+1,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(7) = surface(0.1*-z,          y+1,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(14) = surface(0.1*z+0.5,           y+.65,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(15) = surface(0.1*-z,          y+.65,   x, 'FaceColor', [0.75 0.75 0.75]);
        h(8) = surface(-0.1*z,          y,   0.2*x, 'FaceColor', 'green');
        rotate(h(8), [0 0 0.00001], 90);%rotating 90% around the z axis for correct orientation
        
    end
    function importData()
        f = fopen('driving_data.txt', 'rt');
        if f == -1
            disp("Error opening file");
            return;
        end
        % Read the entire file into cell array 'fields'
        fields = textscan(f, '%f %f %f %f', 'Delimiter', ',');
        fclose(f);
    end

    % Artillery Shell
    function shell()
        [xc, yc, zc] = cylinder([0.1 0]);   % Cone
        [x,   y,  z] = cylinder(); % Cylinder

        h(1) = surface(xc,    0.25*zc,     -yc, 'FaceColor', 'yellow');
        h(2) = surface(0.105*x,-0.5*z, 0.105*y, 'FaceColor', 'yellow');

        shell = hgtransform;
    end
end
