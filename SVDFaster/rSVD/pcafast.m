function [U, S, V] = pcafast(A, r, i)
% The method in [Li et al., 2017] paper
s = 5;
[m, n] = size(A);
B = randn(n, r+s);
if i == 0
    [Q, ~] = qr(A*B, 0);
else
    [Q, ~] = lu(A*B);
end
for j = 1:i
    [Q, ~] = lu((A'*Q));
    if j == i
        [Q, ~] = qr((A*Q), 0);
    else
        [Q, ~] = lu(A*Q);
    end
end
B = Q'*A;
[U, S, V] = svd(B, 'econ');
U = Q*U;
U = U(:, 1:r);
S = S(1:r, 1:r);
V = V(:, 1:r);
end