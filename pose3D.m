clear all
close all
clc
I = imread('check2.jpg');
imshow(I, [])
% These are the points in the model's coordinate system

X_coord=[1.5 3.5 5.5 7.5 4.5 1.5 3.5 5.5 7.5 4.5 1.5 3.5 5.5 7.5 0 0 0 0 0 0 0 0 0 0 0];
Y_coord=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 1.5 3.5 5.5 2.5 1.5 3.5 5.5 2.5 1.5 3.5 5.5];
Z_coord=[0.5 0.5 0.5 0.5 1.5 2.5 2.5 2.5 2.5 3.5 4.5 4.5 4.5 4.5 0.5 0.5 0.5 1.5 2.5 2.5 2.5 3.5 4.5 4.5 4.5];

P_M = [X_coord; Y_coord; Z_coord; ones(1,25)];
f =636;
cx = 317;
cy =240;
K = [ f 0 cx; 0 f cy; 0 0 1 ]; % intrinsic parameter matrix
% cameraParams.IntrinsicMatrix';

% %points for first pose camera1 - use yd=[x1;y1;x2;y2...];
% yd pose1

yd=[421; 421;436; 420;451; 419;465;417;444; 408;420;399;436;398;451; 397;465; 396;443; 387;420;378;
    435;377;450;377;464;376;397;419;384;417;372;414;390;407;397;398;384;396;371;395;390;387;397;378;384;376;371;375];

% Make an initial guess of the pose [ax ay az tx ty tz]
x = [0.1; 0.0; 0.0; 5; 5; 10];
 
for i=1:15  %max number of iterations
    fprintf('\nIteration %d\nCurrent pose:\n', i);
    disp(x);  
    y = fProject(x, P_M, K);
    imshow(I, [])
    for t=1:2:length(y)
        rectangle('Position', [y(t)-8 y(t+1)-8 5 5], 'FaceColor', 'r');
    end
    pause(3);
    % Estimate Jacobian
    e = 0.00001; % a tiny number
    J(:,1) = ( fProject(x+[e;0;0;0;0;0],P_M,K) - y )/e;
    J(:,2) = ( fProject(x+[0;e;0;0;0;0],P_M,K) - y )/e;
    J(:,3) = ( fProject(x+[0;0;e;0;0;0],P_M,K) - y )/e;
    J(:,4) = ( fProject(x+[0;0;0;e;0;0],P_M,K) - y )/e;
    J(:,5) = ( fProject(x+[0;0;0;0;e;0],P_M,K) - y )/e;
    J(:,6) = ( fProject(x+[0;0;0;0;0;e],P_M,K) - y )/e;
    % Error is observed image points - predicted image points
    dy = yd - y;
    fprintf('Residual error: %f\n', norm(dy));
    % Ok, now we have a system of linear equations dy = J dx
    % Solve for dx using the pseudo inverse
    dx = pinv(J) * dy;
    % Stop if parameters are no longer changing
    if abs( norm(dx)/norm(x) ) < 1e-6
        break;
    end  
    x = x + dx; % Update pose estimate
end

%project the coordiante system
u0 = fProject(x, [0;0;0;1], K); % origin
uX = fProject(x, [1;0;0;1], K); % unit X vector
uY = fProject(x, [0;1;0;1], K); % unit Y vector
uZ = fProject(x, [0;0;1;1], K); % unit Z vector
 

line([u0(1) uX(1)], [u0(2) uX(2)], 'color', 'y','LineWidth',2);
line([u0(1) uY(1)], [u0(2) uY(2)], 'color', 'y','LineWidth',2);
line([u0(1) uZ(1)], [u0(2) uZ(2)], 'color', 'y','LineWidth',2);


