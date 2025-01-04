function y = fRigid(x,pIn)

theta = x(1);
tx = x(2);
ty = x(3);
H = [cos(theta) -sin(theta) tx; sin(theta) cos(theta) ty; 0 0 1];
pOut = H*pIn;
pOut = pOut(1:2,:);
y = reshape(pOut,[],1);
end