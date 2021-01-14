function [U, S, V] = basicrSVD(A, r, i)
% the randQB method in [Halko et al., 2011] paper 
s = 5;
[m, n] = size(A);
B = randn(n, r+s);
[Q, ~] = qr(A*B, 0);
for j = 1:i
    [Q, ~] = qr((A'*Q), 0);
    [Q, ~] = qr((A*Q), 0);
end
B = Q'*A;
[U, S, V] = svd(B, 'econ');
U = Q*U;
U = U(:, 1:r);
S = S(1:r, 1:r);
V = V(:, 1:r);
end