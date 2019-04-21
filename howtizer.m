clear;
main()
function main()
axis equal;
axis([-11 11 -11 11 -1.5 5]);
grid on;

drawWheels();
    function drawWheels()
        [x,   y,  z] = cylinder([1 1]); % Cylinder
        h(2) = surface(0.5*z+0.5,           y+1.75,   x, 'FaceColor', [0.75 0.75 0.75]);%left wheel
        h(3) = surface(0.5*-z-0.5,          y+1.75,   x, 'FaceColor', [0.75 0.75 0.75]);%right wheel
        h(4) = surface(z*5,           y*0.3,   x*.3, 'FaceColor', 'green');%barrel
        rotate(h(4), [0 0 0.01], 90);%rotating 90% around the z axis for correct orientation
        rotate(h(4), [0.01 0 0], 45);%tilting barrel up
        h(1) = surface(z*3,           y*0.3,   x*.2, 'FaceColor', 'green');%right trail
        h(5) = surface(z*3,           y*0.3,   x*.2, 'FaceColor', 'green');%left trail
        rotate(h(1), [0 0 0.01], -45);%rotating 90% around the z axis for correct orientation
        rotate(h(1), [0.001 0 0], 25);%rotating 90% around the z axis for correct orientation
        rotate(h(5), [0 0 0.01], -135);%rotating 90% around the z axis for correct orientation
        rotate(h(5), [0.001 0 0], 25);%rotating 90% around the z axis for correct orientation
        
        %translate(h(4),[-5, -5, 0]); 
    end

end