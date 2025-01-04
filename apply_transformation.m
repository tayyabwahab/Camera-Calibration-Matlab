function apply_transformation(x)
    IA = imread('check1.jpg');
    IB = imread('check2.jpg');
    theta = x(1);
    tx = x(2);
    ty = x(3);
    A = [cos(theta) -sin(theta) tx; sin(theta) cos(theta) ty; 0 0 1];
    y = [x(1) x(1) x(1); x(2) x(2) x(2); x(3) x(3) x(3)];
    u0 = fProject(y, [0;0;0;1], A); % origin
    uX = fProject(y, [1;0;0;1], A); % unit X vector
    uY = fProject(y, [0;1;0;1], A); % unit Y vector
    uZ = fProject(y, [0;0;1;1], A); % unit Z vector
    line([u0(1) uX(1)], [u0(2) uX(2)], 'color', 'y','LineWidth',2);
    line([u0(1) uY(1)], [u0(2) uY(2)], 'color', 'y','LineWidth',2);
    line([u0(1) uZ(1)], [u0(2) uZ(2)], 'color', 'y','LineWidth',2);
end