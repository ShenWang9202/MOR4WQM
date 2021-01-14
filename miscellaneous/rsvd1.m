function [U,S,V] = rsvd1(X,r,i,s)

% Step 1: Sample column space of X with P matrix
ny = size(X,2);
P = randn(ny,r+s);
Z = X*P;
Xtranspose = X';
for r=1:i
    Z = X*(Xtranspose*Z);
end
[Q,~] = qr(Z,0);

% Step 2: Compute SVD on projected Y=Q'*X;
Y = Q'*X;
[UY,S,V] = svd(Y,'econ');
U = Q*UY;