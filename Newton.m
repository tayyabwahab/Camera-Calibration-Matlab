close all
clc

pA = [28 24 122 118 182 184; 365 440 366 449 358 430;1 1 1 1 1 1 ];
pB = [348 348 408 410 482 484;352 419 358 431 355 422];
N = size(pA,2);
theta = 2;
tx = 100;
ty = 100;
x = [theta; tx; ty];

while true
    disp('Parameters: '),disp(x);
    y = fRigid(x,pA);
    temp = reshape(pB,[],1);
    dy = temp-y;
    J = zeros(2*N,3);
    theta = x(1);
    for i = 1:N
        J(2*(i-1)+1,:) = [-sin(theta)*pA(1,i)-cos(theta)*pA(2,i) 1 0];
        J(2*(i-1)+2,:) = [cos(theta)*pA(1,i)-sin(theta)*pA(2,i) 0 1];
    end
    dx = pinv(J)*dy;
    if abs(norm(dx)/norm(x)) < 1e-6
        break;
    end
    x = x+dx;
end 

