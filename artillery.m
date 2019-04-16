% Artillery Simulation
% George Proner, Kevin Wei
% INFO48874 Simulation and Visualization
% Winter 2018


clear;
main();


function main()

    % Constants
    GRAVITY = -9.80665;
    
    % Simulation
    time = 0
    TIME_STEP = 0.01;
    BULLET = [ 0 0 0 ] % Initial bullet position [ X Y Z]
    
    
    % Create figure window with keyboard callbacks
    p = get(gcf, 'Position');
    close all;
    h_fig = figure('Name', 'Lunar Lander');
    set(h_fig, 'Position', [p(1)  p(2)  p(3)  p(4)]);  % Set figure size same as before
    set(h_fig, 'KeyPressFcn', @keypress_callback);
    set(h_fig, 'KeyReleaseFcn', @keyrelease_callback);
    
    % Mesh grid
    % TODO - random slopes/elevation to map?
    [X,Y] = meshgrid(-8:.15:8,-8:.15:8); 
    Z = peaks(X,Y)*5;
    mesh(X,Y,Z);

    % Label the x, y, z axes
    xlabel('X', 'Color', 'r');      % red
    ylabel('Y', 'Color', [0 .6 0]); % dark green
    zlabel('Z', 'Color', 'b');      % blue

    % Simulation Timer
    t = timer;set(t, 'Period', TIME_STEP, 'ExecutionMode', 'fixedRate', 'BusyMode', 'queue', 'TimerFcn', @timer_callback);
    
    
    
    
    % TODO - keyboard callback functions arrow keys to change direction
    
    % TODO - spacebar to fire artillery
    function fire_callback(~, event)
        if event.key == "space"
            spacePressed = true;
        end
    end
end